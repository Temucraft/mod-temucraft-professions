/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

// Treasures, herbs and ore, closer to newer clients:
// - Chests and other "Opening" objects open at once (the generic Opening spells are instant; the client's
//   Spell.dbc in patch-T has the same change, so the cast bar matches). Battleground captures (8 s) are untouched.
// - Herbs, ore veins and treasure chests always show on the minimap, for everyone, whatever tracking is chosen.
// - They sparkle in the world (the sparkle quest objects have), for every player near them. Objects that are only
//   there for a quest (quest loot, like Cactus Apple Surprise's apples) are left alone: the core sparkles those for
//   players on the quest.
// - Dwarves' Treasure Finding is no longer a tracking spell everyone now has for free: dwarves find more gold
//   (Temucraft.Treasures.Dwarf.GoldPercent on any loot, .ChestGoldPercent from treasure chests).

#include "TemucraftLocked.h"
#include "Cell.h"
#include "CellImpl.h"
#include "Config.h"
#include "DBCStores.h"
#include "GameObject.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "LootMgr.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellInfo.h"
#include "UpdateData.h"
#include "UpdateMask.h"
#include <list>
#include <unordered_map>
#include <unordered_set>

namespace
{
    // the generic "Opening" spells the client casts on chests and similar objects
    constexpr uint32 OPENING_SPELLS[] = { 3365, 6477, 6478, 22810, 26868 };
    constexpr uint32 TRACK_MASK = (1u << (LOCKTYPE_HERBALISM - 1)) | (1u << (LOCKTYPE_MINING - 1)) | (1u << (LOCKTYPE_TREASURE - 1));

    struct Settings
    {
        bool instantOpen = true;
        bool minimap = true;
        bool sparkle = true;
        float sparkleRange = 80.0f;
        uint32 interval = 1000;
        float dwarfGold = 20.0f;
        float dwarfChestGold = 50.0f;
    };
    Settings cfg;

    struct Seen
    {
        uint32 timer = 0;
        std::unordered_set<ObjectGuid> sparkling;   // objects this player was told to sparkle
    };
    Temucraft::LockedMap<ObjectGuid, Seen> players;

    void LoadSettings()
    {
        cfg.instantOpen = sConfigMgr->GetOption<bool>("Temucraft.Treasures.InstantOpen", true);
        cfg.minimap = sConfigMgr->GetOption<bool>("Temucraft.Treasures.Minimap", true);
        cfg.sparkle = sConfigMgr->GetOption<bool>("Temucraft.Treasures.Sparkle", true);
        cfg.sparkleRange = std::clamp(sConfigMgr->GetOption<float>("Temucraft.Treasures.SparkleRange", 80.0f), 10.0f, 200.0f);
        cfg.interval = std::max<uint32>(250, sConfigMgr->GetOption<uint32>("Temucraft.Treasures.Interval", 1000));
        cfg.dwarfGold = std::max(0.0f, sConfigMgr->GetOption<float>("Temucraft.Treasures.Dwarf.GoldPercent", 20.0f));
        cfg.dwarfChestGold = std::max(0.0f, sConfigMgr->GetOption<float>("Temucraft.Treasures.Dwarf.ChestGoldPercent", 50.0f));
    }

    // herb, ore vein or treasure chest (by the kind of lock it has)
    bool IsResource(GameObject const* go)
    {
        GameObjectTemplate const* info = go->GetGOInfo();
        if (!info || info->type != GAMEOBJECT_TYPE_CHEST || !info->chest.lockId)
            return false;
        // quest objects: their own sparkle, only for players on the quest
        if (info->chest.questId || info->IsGameObjectForQuests())
            return false;
        LockEntry const* lock = sLockStore.LookupEntry(info->chest.lockId);
        if (!lock)
            return false;
        for (uint8 i = 0; i < MAX_LOCK_CASE; ++i)
            if (lock->Type[i] == LOCK_KEY_SKILL &&
                (lock->Index[i] == LOCKTYPE_HERBALISM || lock->Index[i] == LOCKTYPE_MINING || lock->Index[i] == LOCKTYPE_TREASURE))
                return true;
        return false;
    }

    bool IsTreasure(GameObject const* go)
    {
        GameObjectTemplate const* info = go->GetGOInfo();
        if (!info || info->type != GAMEOBJECT_TYPE_CHEST || !info->chest.lockId)
            return false;
        LockEntry const* lock = sLockStore.LookupEntry(info->chest.lockId);
        if (!lock)
            return false;
        for (uint8 i = 0; i < MAX_LOCK_CASE; ++i)
            if (lock->Type[i] == LOCK_KEY_SKILL && lock->Index[i] == LOCKTYPE_TREASURE)
                return true;
        return false;
    }

    // tells one player's client that this object sparkles (its dynamic flags, as for a quest object)
    void SendSparkle(Player* player, GameObject* go)
    {
        UpdateMask mask;
        mask.SetCount(go->GetValuesCount());
        mask.SetBit(GAMEOBJECT_DYNAMIC);
        ByteBuffer buf(64);
        buf << uint8(UPDATETYPE_VALUES);
        buf << go->GetPackGUID();
        buf << uint8(mask.GetBlockCount());
        mask.AppendToPacket(&buf);
        buf << uint16(GO_DYNFLAG_LO_SPARKLE);
        buf << int16(-1);
        UpdateData data;
        data.AddUpdateBlock(buf);
        WorldPacket packet;
        if (data.BuildPacket(packet))
            player->SendDirectMessage(&packet);
    }

    struct ResourceCheck
    {
        explicit ResourceCheck(Player* p, float r) : player(p), range(r) { }
        bool operator()(GameObject* go) const
        {
            return go->isSpawned() && go->GetGoState() == GO_STATE_READY && player->IsWithinDistInMap(go, range) &&
                player->HaveAtClient(go) && IsResource(go);
        }
        Player* player;
        float range;
    };

    void UpdateSparkles(Player* player, Seen& seen)
    {
        std::list<GameObject*> found;
        ResourceCheck check(player, cfg.sparkleRange);
        Acore::GameObjectListSearcher<ResourceCheck> searcher(player, found, check);
        Cell::VisitObjects(player, searcher, cfg.sparkleRange);

        std::unordered_set<ObjectGuid> now;
        for (GameObject* go : found)
        {
            now.insert(go->GetGUID());
            // new in range (or spawned again): the client got the object without sparkle
            if (!seen.sparkling.count(go->GetGUID()))
                SendSparkle(player, go);
        }
        seen.sparkling = std::move(now);
    }
}

class TemucraftTreasuresWorld : public WorldScript
{
public:
    TemucraftTreasuresWorld() : WorldScript("TemucraftTreasuresWorld", { WORLDHOOK_ON_AFTER_CONFIG_LOAD }) { }
    void OnAfterConfigLoad(bool /*reload*/) override { LoadSettings(); }
};

class TemucraftTreasuresSpells : public GlobalScript
{
public:
    TemucraftTreasuresSpells() : GlobalScript("TemucraftTreasuresSpells", { GLOBALHOOK_ON_LOAD_SPELL_CUSTOM_ATTR }) { }

    void OnLoadSpellCustomAttr(SpellInfo* spell) override
    {
        if (!sConfigMgr->GetOption<bool>("Temucraft.Treasures.InstantOpen", true))
            return;
        for (uint32 id : OPENING_SPELLS)
            if (spell->Id == id)
                spell->CastTimeEntry = sSpellCastTimesStore.LookupEntry(1);   // instant
    }
};

class TemucraftTreasuresPlayer : public PlayerScript
{
public:
    TemucraftTreasuresPlayer() : PlayerScript("TemucraftTreasuresPlayer",
        { PLAYERHOOK_ON_LOGOUT, PLAYERHOOK_ON_UPDATE, PLAYERHOOK_ON_MAP_CHANGED, PLAYERHOOK_ON_BEFORE_LOOT_MONEY }) { }

    void OnPlayerLogout(Player* player) override { players.erase(player->GetGUID()); }

    // a new map sends every object again, without the sparkle
    void OnPlayerMapChanged(Player* player) override
    {
        auto it = players.find(player->GetGUID());
        if (it != players.end())
            it->second.sparkling.clear();
    }

    void OnPlayerUpdate(Player* player, uint32 diff) override
    {
        if (!cfg.minimap && !cfg.sparkle)
            return;
        Seen& seen = players[player->GetGUID()];
        seen.timer += diff;
        if (seen.timer < cfg.interval)
            return;
        seen.timer = 0;
        if (!player->IsInWorld() || player->IsBeingTeleported())
            return;

        // herbs, ore and treasure on the minimap: the bits tracking spells set; put back if a tracking change
        // cleared them
        if (cfg.minimap && (player->GetUInt32Value(PLAYER_TRACK_RESOURCES) & TRACK_MASK) != TRACK_MASK)
            player->SetFlag(PLAYER_TRACK_RESOURCES, TRACK_MASK);

        if (cfg.sparkle)
            UpdateSparkles(player, seen);
    }

    void OnPlayerBeforeLootMoney(Player* player, Loot* loot) override
    {
        if (!loot || !loot->gold || player->getRace() != RACE_DWARF)
            return;
        float pct = cfg.dwarfGold;
        if (loot->sourceWorldObjectGUID.IsGameObject())
            if (GameObject* go = player->GetMap()->GetGameObject(loot->sourceWorldObjectGUID))
                if (IsTreasure(go))
                    pct = cfg.dwarfChestGold;
        if (pct > 0.0f)
            loot->gold = uint32(loot->gold * (1.0f + pct / 100.0f));
    }
};

void AddTemucraftTreasuresScripts()
{
    new TemucraftTreasuresWorld();
    new TemucraftTreasuresSpells();
    new TemucraftTreasuresPlayer();
}
