/*
 * mod-temucraft-professions: gathering stats (Finesse, Perception, Deftness), from tools you carry.
 *
 *   Finesse     chance for each stack you gather (ore, herbs, leather, fish) to come with half again as much
 *   Perception  chance to also find a rare reagent that fits the node (gems from ore, rare herbs, rare hides)
 *   Deftness    shorter gathering casts (mining, herb gathering, skinning)
 *
 * Tools work from your bags or equipped, like profession tools in later expansions, so they never take a gear
 * slot. Each tool gives its stats to one gathering skill (or all, Skill = 0): mod_temucraft_gathering_tool. Rare
 * reagents per skill and node level: mod_temucraft_gathering_rare.
 *
 * Deftness works through a hidden aura (spell 95420) that lowers cast time; the spell-mod hook limits it to the
 * gathering spells, so combat casts are never faster.
 */
#include "TemucraftKnowledge.h"
#include "TemucraftProfGear.h"

#include "Chat.h"
#include "Config.h"
#include "DBCStores.h"
#include "DatabaseEnv.h"
#include "GameObject.h"
#include "Log.h"
#include "LootMgr.h"
#include "MiscScript.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "PlayerScript.h"
#include "ScriptMgr.h"
#include "SpellAuraEffects.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "WorldScript.h"
#include <algorithm>
#include <mutex>
#include <unordered_map>
#include <vector>

namespace
{
    constexpr uint32 SKILL_HERB = 182, SKILL_MINE = 186, SKILL_SKIN = 393, SKILL_FISH = 356;
    constexpr uint32 SPELL_DEFTNESS = 95420;

    struct Tool { uint32 item; uint32 skill; int32 finesse; int32 perception; int32 deftness; };
    struct Rare { uint32 skill; uint32 minNode; uint32 maxNode; uint32 item; uint32 weight; };
    struct Node { uint32 skill; uint32 level; };
    struct GatherStats { int32 finesse = 0, perception = 0, deftness = 0; };

    struct Settings
    {
        bool enable = true;
        int32 maxFinesse = 75, maxPerception = 50, maxDeftness = 50;
        uint32 finesseBonus = 50;   // percent more of a stack on a Finesse proc
    } sSet;

    std::vector<Tool> sTools;
    std::vector<Rare> sRares;
    std::unordered_map<LootTemplate const*, Node> sNodes;   // gameobject loot -> gathering skill and node level
    // Player updates run on several map threads at once, so the shared timer map needs a lock.
    std::unordered_map<ObjectGuid::LowType, uint32> sTimers;
    std::mutex sTimersLock;

    void LoadConfig()
    {
        sSet.enable = sConfigMgr->GetOption<bool>("Temucraft.Gathering.Enable", true);
        sSet.maxFinesse = sConfigMgr->GetOption<int32>("Temucraft.Gathering.MaxFinesse", 75);
        sSet.maxPerception = sConfigMgr->GetOption<int32>("Temucraft.Gathering.MaxPerception", 50);
        sSet.maxDeftness = sConfigMgr->GetOption<int32>("Temucraft.Gathering.MaxDeftness", 50);
        sSet.finesseBonus = sConfigMgr->GetOption<uint32>("Temucraft.Gathering.FinesseBonusPercent", 50);
    }

    void LoadData()
    {
        sTools.clear();
        if (QueryResult r = WorldDatabase.Query("SELECT `ItemID`, `Skill`, `Finesse`, `Perception`, `Deftness` FROM `mod_temucraft_gathering_tool`"))
            do
            {
                Field* f = r->Fetch();
                sTools.push_back({ f[0].Get<uint32>(), f[1].Get<uint32>(), f[2].Get<int32>(), f[3].Get<int32>(), f[4].Get<int32>() });
            } while (r->NextRow());
        sRares.clear();
        if (QueryResult r = WorldDatabase.Query("SELECT `Skill`, `MinNode`, `MaxNode`, `ItemID`, `Weight` FROM `mod_temucraft_gathering_rare`"))
            do
            {
                Field* f = r->Fetch();
                sRares.push_back({ f[0].Get<uint32>(), f[1].Get<uint32>(), f[2].Get<uint32>(), f[3].Get<uint32>(), f[4].Get<uint32>() });
            } while (r->NextRow());

        // which gameobject loot tables are herbs and ore, and how much skill the node asks for
        sNodes.clear();
        for (auto const& [entry, t] : *sObjectMgr->GetGameObjectTemplates())
        {
            if (t.type != GAMEOBJECT_TYPE_CHEST || !t.chest.lockId || !t.chest.lootId)
                continue;
            LockEntry const* lock = sLockStore.LookupEntry(t.chest.lockId);
            if (!lock)
                continue;
            for (uint8 i = 0; i < MAX_LOCK_CASE; ++i)
            {
                if (lock->Type[i] != LOCK_KEY_SKILL)
                    continue;
                uint32 skill = lock->Index[i] == LOCKTYPE_HERBALISM ? SKILL_HERB : lock->Index[i] == LOCKTYPE_MINING ? SKILL_MINE : 0;
                if (!skill)
                    continue;
                if (LootTemplate const* tab = LootTemplates_Gameobject.GetLootFor(t.chest.lootId))
                    sNodes[tab] = { skill, lock->Skill[i] };
                break;
            }
        }
        LOG_INFO("module", "mod-temucraft-professions: {} gathering tools, {} rare reagents, {} herb and ore loot tables", sTools.size(), sRares.size(), sNodes.size());
    }

    GatherStats StatsFor(Player* player, uint32 skill)
    {
        GatherStats s;
        for (Tool const& t : sTools)
        {
            if (t.skill && skill && t.skill != skill)
                continue;
            if (!player->HasItemCount(t.item, 1, false))
                continue;
            s.finesse += t.finesse;
            s.perception += t.perception;
            s.deftness += t.deftness;
        }
        // Profession equipment worn (.temucraft profgear)
        s.finesse += TemucraftProfGearStat(player, skill, GEAR_FINESSE);
        s.perception += TemucraftProfGearStat(player, skill, GEAR_PERCEPTION);
        s.deftness += TemucraftProfGearStat(player, skill, GEAR_DEFTNESS);
        // Specializations (.temucraft knowledge); the Deftness aura covers every gathering skill, so it takes the best one
        if (skill)
        {
            s.finesse += TemucraftSpecBonus(player, skill, PROF_STAT_FINESSE);
            s.perception += TemucraftSpecBonus(player, skill, PROF_STAT_PERCEPTION);
            s.deftness += TemucraftSpecBonus(player, skill, PROF_STAT_DEFTNESS);
        }
        else
        {
            int32 best = 0;
            for (uint32 gather : { SKILL_HERB, SKILL_MINE, SKILL_SKIN })
                best = std::max(best, TemucraftSpecBonus(player, gather, PROF_STAT_DEFTNESS));
            s.deftness += best;
        }
        s.finesse = std::min(s.finesse, sSet.maxFinesse);
        s.perception = std::min(s.perception, sSet.maxPerception);
        s.deftness = std::min(s.deftness, sSet.maxDeftness);
        return s;
    }

    bool IsGatheringSpell(SpellInfo const* spell)
    {
        for (uint8 i = 0; i < MAX_SPELL_EFFECTS; ++i)
        {
            SpellEffectInfo const& e = spell->Effects[i];
            if (e.Effect == SPELL_EFFECT_SKINNING)
                return true;
            if (e.Effect == SPELL_EFFECT_OPEN_LOCK && (e.MiscValue == LOCKTYPE_HERBALISM || e.MiscValue == LOCKTYPE_MINING))
                return true;
        }
        return false;
    }

    // deftness for the cast-time aura: the best of the three gathering skills the player carries tools for
    void UpdateDeftness(Player* player)
    {
        int32 d = 0;
        if (sSet.enable)
            for (uint32 skill : { SKILL_HERB, SKILL_MINE, SKILL_SKIN })
                if (player->HasSkill(skill))
                    d = std::max(d, StatsFor(player, skill).deftness);
        Aura* aura = player->GetAura(SPELL_DEFTNESS);
        int32 current = aura && aura->GetEffect(EFFECT_0) ? -aura->GetEffect(EFFECT_0)->GetAmount() : 0;
        if (d == current)
            return;
        player->RemoveAurasDueToSpell(SPELL_DEFTNESS);
        if (d > 0 && sSpellMgr->GetSpellInfo(SPELL_DEFTNESS))
        {
            int32 bp = -d;
            player->CastCustomSpell(player, SPELL_DEFTNESS, &bp, nullptr, nullptr, true);
        }
    }
}

class TemucraftGathering_Misc : public MiscScript
{
public:
    TemucraftGathering_Misc() : MiscScript("TemucraftGathering_Misc", { MISCHOOK_ON_AFTER_LOOT_TEMPLATE_PROCESS }) { }

    void OnAfterLootTemplateProcess(Loot* loot, LootTemplate const* tab, LootStore const& store, Player* owner, bool /*personal*/, bool /*noEmptyError*/, uint16 /*lootMode*/) override
    {
        if (!sSet.enable || !loot || !owner)
            return;
        uint32 skill = 0, node = 0;
        if (&store == &LootTemplates_Skinning)
            skill = SKILL_SKIN, node = owner->GetSkillValue(SKILL_SKIN);
        else if (&store == &LootTemplates_Fishing)
            skill = SKILL_FISH, node = owner->GetSkillValue(SKILL_FISH);
        else if (&store == &LootTemplates_Gameobject)
        {
            auto itr = sNodes.find(tab);
            if (itr == sNodes.end())
                return;
            skill = itr->second.skill;
            node = itr->second.level;
        }
        else
            return;

        // Knowledge for each kind of item gathered for the first time
        for (LootItem const& item : loot->items)
            if (ItemTemplate const* proto = sObjectMgr->GetItemTemplate(item.itemid))
                TemucraftKnowledgeFirst(owner, skill, item.itemid, (proto->Name1 + " gathered").c_str());

        GatherStats s = StatsFor(owner, skill);
        if (s.finesse > 0)
            for (LootItem& item : loot->items)
            {
                if (item.is_looted || item.needs_quest || !roll_chance_i(s.finesse))
                    continue;
                ItemTemplate const* proto = sObjectMgr->GetItemTemplate(item.itemid);
                uint32 max = proto && proto->GetMaxStackSize() > 0 ? proto->GetMaxStackSize() : item.count;
                item.count = std::min<uint32>(max, item.count + std::max<uint32>(1, item.count * sSet.finesseBonus / 100));
            }

        if (s.perception > 0 && roll_chance_i(s.perception) && loot->items.size() + loot->quest_items.size() < 18)
        {
            uint32 total = 0;
            for (Rare const& r : sRares)
                if (r.skill == skill && node >= r.minNode && node <= r.maxNode)
                    total += r.weight;
            if (total)
            {
                uint32 pick = urand(1, total);
                for (Rare const& r : sRares)
                {
                    if (r.skill != skill || node < r.minNode || node > r.maxNode)
                        continue;
                    if (pick <= r.weight)
                    {
                        loot->AddItem(LootStoreItem(r.item, 0, 100.0f, false, LOOT_MODE_DEFAULT, 0, 1, 1));
                        break;
                    }
                    pick -= r.weight;
                }
            }
        }
    }
};

class TemucraftGathering_Global : public GlobalScript
{
public:
    TemucraftGathering_Global() : GlobalScript("TemucraftGathering_Global", { GLOBALHOOK_ON_IS_AFFECTED_BY_SPELL_MOD_CHECK }) { }

    // the deftness aura's cast-time modifier only touches gathering spells
    bool OnIsAffectedBySpellModCheck(SpellInfo const* affectSpell, SpellInfo const* checkSpell, SpellModifier const* /*mod*/) override
    {
        if (affectSpell && affectSpell->Id == SPELL_DEFTNESS && checkSpell && IsGatheringSpell(checkSpell))
            return false;   // false = affected
        return true;
    }
};

class TemucraftGathering_Player : public PlayerScript
{
public:
    TemucraftGathering_Player() : PlayerScript("TemucraftGathering_Player", { PLAYERHOOK_ON_UPDATE, PLAYERHOOK_ON_LOGOUT }) { }

    void OnPlayerUpdate(Player* player, uint32 diff) override
    {
        {
            std::lock_guard lock(sTimersLock);
            uint32& t = sTimers[player->GetGUID().GetCounter()];
            if (t > diff) { t -= diff; return; }
            t = 5000;
        }
        UpdateDeftness(player);
    }

    void OnPlayerLogout(Player* player) override
    {
        std::lock_guard lock(sTimersLock);
        sTimers.erase(player->GetGUID().GetCounter());
    }
};

class TemucraftGathering_World : public WorldScript
{
public:
    TemucraftGathering_World() : WorldScript("TemucraftGathering_World", { WORLDHOOK_ON_AFTER_CONFIG_LOAD, WORLDHOOK_ON_STARTUP }) { }
    void OnAfterConfigLoad(bool /*reload*/) override { LoadConfig(); }
    void OnStartup() override { LoadData(); }
};

void TemucraftGatheringStats(Player* player, uint32 skill, int32& finesse, int32& perception, int32& deftness)
{
    GatherStats s = StatsFor(player, skill);
    finesse = s.finesse;
    perception = s.perception;
    deftness = s.deftness;
}

void AddTemucraftGatheringScripts()
{
    new TemucraftGathering_Misc();
    new TemucraftGathering_Global();
    new TemucraftGathering_Player();
    new TemucraftGathering_World();
}
