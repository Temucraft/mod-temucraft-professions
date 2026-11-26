/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

// Profession slots: every character can learn Temucraft.ProfessionSlots.Base primary professions (2) and unlocks more,
// one at a time, up to MaxPrimaryTradeSkill in worldserver.conf (set it to 11 = every profession).
//
// How a slot is unlocked is up to the server: put the spell script `spell_temucraft_profession_slot` on any spell
// (spell_script_names), e.g. the spell of an item, a quest reward spell or a trainer spell. Each cast gives the caster's
// target (or the caster) one more slot. GMs: .temucraft profslots [add|remove|set <n>] on the selected player.
//
// The core counts free slots from MaxPrimaryTradeSkill; this file lowers that to base + unlocked at login and after
// every change, and the core keeps adding or removing one as professions are learned or dropped.

#include "Chat.h"
#include "ChatCommand.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "DBCStores.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellMgr.h"
#include "SpellScript.h"
#include "SpellScriptLoader.h"
#include "TemucraftModuleText.h"
#include "World.h"

#include <mutex>
#include <unordered_map>

using namespace Acore::ChatCommands;

namespace
{
    char const* const MODULE = "mod-temucraft-professions";

    struct SlotSettings
    {
        bool enable = true;
        uint32 base = 2;
    } slots;

    std::mutex sLock;
    std::unordered_map<uint32, uint32> sUnlocked;   // character guid -> extra slots unlocked

    uint32 Max() { return sWorld->getIntConfig(CONFIG_MAX_PRIMARY_TRADE_SKILL); }

    uint32 Unlocked(Player const* player)
    {
        std::lock_guard lock(sLock);
        auto it = sUnlocked.find(player->GetGUID().GetCounter());
        return it == sUnlocked.end() ? 0 : it->second;
    }

    uint32 Allowed(Player const* player)
    {
        return std::min(Max(), slots.base + Unlocked(player));
    }

    uint32 Learned(Player const* player)
    {
        uint32 count = 0;
        for (SkillLineEntry const* skill : sSkillLineStore)
            if (skill && IsPrimaryProfessionSkill(skill->id) && player->HasSkill(skill->id))
                ++count;
        return count;
    }

    // Free slots = allowed - learned (never below 0; a character over the limit keeps what he has).
    void Refresh(Player* player)
    {
        if (!slots.enable)
            return;
        uint32 allowed = Allowed(player), learned = Learned(player);
        player->SetFreePrimaryProfessions(uint16(allowed > learned ? allowed - learned : 0));
    }

    void SetUnlocked(Player* player, uint32 extra)
    {
        uint32 room = Max() > slots.base ? Max() - slots.base : 0;
        extra = std::min(extra, room);
        {
            std::lock_guard lock(sLock);
            sUnlocked[player->GetGUID().GetCounter()] = extra;
        }
        CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_profession_slots` (`guid`, `unlocked`) VALUES ({}, {})", player->GetGUID().GetCounter(), extra);
        Refresh(player);
    }

    // +1 slot. Returns false when the character already has every slot.
    bool Unlock(Player* player)
    {
        if (Allowed(player) >= Max())
            return false;
        SetUnlocked(player, Unlocked(player) + 1);
        ChatHandler(player->GetSession()).PSendSysMessage(TemucraftModuleText(MODULE, player, 300, "You can now learn {} primary professions."), Allowed(player));
        return true;
    }
}

class spell_temucraft_profession_slot : public SpellScript
{
    PrepareSpellScript(spell_temucraft_profession_slot);

    Player* Target()
    {
        if (Unit* target = GetExplTargetUnit())
            if (Player* player = target->ToPlayer())
                return player;
        return GetCaster() ? GetCaster()->ToPlayer() : nullptr;
    }

    SpellCastResult CheckCast()
    {
        Player* player = Target();
        if (!player || !slots.enable)
            return SPELL_FAILED_BAD_TARGETS;
        if (Allowed(player) >= Max())
        {
            SetCustomCastResultMessage(SPELL_CUSTOM_ERROR_NONE);
            ChatHandler(player->GetSession()).SendSysMessage(TemucraftModuleText(MODULE, player, 301, "You already have every profession slot."));
            return SPELL_FAILED_DONT_REPORT;
        }
        return SPELL_CAST_OK;
    }

    void HandleAfterCast()
    {
        if (Player* player = Target())
            Unlock(player);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_temucraft_profession_slot::CheckCast);
        AfterCast += SpellCastFn(spell_temucraft_profession_slot::HandleAfterCast);
    }
};

class TemucraftProfessionSlots_Player : public PlayerScript
{
public:
    TemucraftProfessionSlots_Player() : PlayerScript("TemucraftProfessionSlots_Player", { PLAYERHOOK_ON_LOGIN, PLAYERHOOK_ON_LOGOUT }) { }

    void OnPlayerLogin(Player* player) override
    {
        uint32 extra = 0;
        if (QueryResult result = CharacterDatabase.Query("SELECT `unlocked` FROM `mod_temucraft_profession_slots` WHERE `guid` = {}", player->GetGUID().GetCounter()))
            extra = result->Fetch()[0].Get<uint32>();
        {
            std::lock_guard lock(sLock);
            sUnlocked[player->GetGUID().GetCounter()] = extra;
        }
        Refresh(player);
    }

    void OnPlayerLogout(Player* player) override
    {
        std::lock_guard lock(sLock);
        sUnlocked.erase(player->GetGUID().GetCounter());
    }
};

class TemucraftProfessionSlots_Command : public CommandScript
{
public:
    TemucraftProfessionSlots_Command() : CommandScript("TemucraftProfessionSlots_Command") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "temucraft profslots", HandleSlots, 102754, Console::No },
        };
        return commandTable;
    }

    // .temucraft profslots                show; add / remove / set <n> change the unlocked extra slots
    static bool HandleSlots(ChatHandler* handler, Optional<std::string> action, Optional<uint32> amount)
    {
        Player* target = handler->getSelectedPlayerOrSelf();
        if (!target)
            return false;
        if (action)
        {
            uint32 now = Unlocked(target);
            if (*action == "add")
                SetUnlocked(target, now + 1);
            else if (*action == "remove")
                SetUnlocked(target, now ? now - 1 : 0);
            else if (*action == "set" && amount)
                SetUnlocked(target, *amount);
            else
            {
                handler->SendSysMessage("Usage: .temucraft profslots [add | remove | set <extra slots>]");
                return true;
            }
        }
        handler->PSendSysMessage("{}: {} of {} primary professions allowed ({} base + {} unlocked), {} learned, {} free.",
            target->GetName(), Allowed(target), Max(), slots.base, Unlocked(target), Learned(target), target->GetFreePrimaryProfessionPoints());
        return true;
    }
};

class TemucraftProfessionSlots_World : public WorldScript
{
public:
    TemucraftProfessionSlots_World() : WorldScript("TemucraftProfessionSlots_World", { WORLDHOOK_ON_AFTER_CONFIG_LOAD }) { }

    void OnAfterConfigLoad(bool /*reload*/) override
    {
        slots.enable = sConfigMgr->GetOption<bool>("Temucraft.ProfessionSlots.Enable", true);
        slots.base = sConfigMgr->GetOption<uint32>("Temucraft.ProfessionSlots.Base", 2);
    }
};

// a deleted character's unlocked profession slots go with it
// OnPlayerDeleteFromDB: only when the character is really removed (not a CharDelete.Method = 1 unlink, which can be
// restored), and in the same transaction as the core's own deletes.
class TemucraftProfessionSlots_Delete : public PlayerScript
{
public:
    TemucraftProfessionSlots_Delete() : PlayerScript("TemucraftProfessionSlots_Delete", { PLAYERHOOK_ON_DELETE_FROM_DB }) { }

    void OnPlayerDeleteFromDB(CharacterDatabaseTransaction trans, uint32 guid) override
    {
        trans->Append("DELETE FROM `mod_temucraft_profession_slots` WHERE `guid` = {}", guid);
    }
};

void AddTemucraftProfessionSlotsScripts()
{
    RegisterSpellScript(spell_temucraft_profession_slot);
    new TemucraftProfessionSlots_Player();
    new TemucraftProfessionSlots_Command();
    new TemucraftProfessionSlots_World();
    new TemucraftProfessionSlots_Delete();
}
