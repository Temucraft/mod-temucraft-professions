/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

// Profession perks: something for every profession from the first skill points on, growing with the skill.
//
// - Alchemy, Mixology: an alchemist's elixirs and flasks are stronger and last twice as long, all of them (not only
//   the Northrend recipes the alchemist knows) and from skill 1.
// - Blacksmithing, Repair All: .repairall mends all your gear for free; the wait shrinks as the skill climbs.
// - Mining, Toughness: +1% maximum health per 75 skill.
// - Skinning, Beasts of the Wild: +1% damage done to beasts per 75 skill.
// - Tailoring, Cloth Scavenging: when cloth drops from a creature, a 25% chance for one more piece.
// Each perk only works while the profession is known, and each can be turned off in the config.

#include "Chat.h"
#include "CommandScript.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "GameTime.h"
#include "Item.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "Random.h"
#include "ScriptMgr.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "TemucraftModuleText.h"
#include <algorithm>
#include <sstream>
#include <unordered_map>
#include <vector>

using namespace Acore::ChatCommands;

namespace
{
    constexpr char const* MODULE = "mod-temucraft-profession-perks";
    constexpr uint32 SPELL_MIXOLOGY = 53042;

    enum Text : uint32
    {
        T_NO_SKILL = 1, T_WAIT, T_REPAIRED, T_DISABLED
    };
    char const* Say(Player* player, uint32 id, char const* fallback) { return TemucraftModuleText(MODULE, player, id, fallback); }

    struct Settings
    {
        bool enable = true;
        bool mixology = true;
        uint32 mixologyMinSkill = 1;
        float mixologyDuration = 2.0f;
        bool repair = true;
        uint32 repairMinSkill = 75;
        std::vector<std::pair<uint32, uint32>> repairCooldown;   // from skill -> cooldown in seconds
        bool toughness = true;
        float toughnessPct = 1.0f;
        uint32 toughnessStep = 75;
        bool beasts = true;
        float beastsPct = 1.0f;
        uint32 beastsStep = 75;
        bool scavenging = true;
        float scavengingChance = 25.0f;
    } settings;

    std::unordered_map<uint32, uint32> repairUsed;   // character -> unix time of the last Repair All

    // "skill-step" ranks: 1 per full step of skill, as many as the skill allows
    float Ranks(Player* player, uint32 skill, uint32 step)
    {
        if (!step || !player->HasSkill(skill))
            return 0.0f;
        return float(player->GetSkillValue(skill) / step);
    }

    void LoadSettings()
    {
        settings.enable = sConfigMgr->GetOption<bool>("Temucraft.ProfessionPerks.Enable", true);
        settings.mixology = sConfigMgr->GetOption<bool>("Temucraft.ProfessionPerks.Mixology", true);
        settings.mixologyMinSkill = sConfigMgr->GetOption<uint32>("Temucraft.ProfessionPerks.Mixology.MinSkill", 1);
        settings.mixologyDuration = std::max(1.0f, sConfigMgr->GetOption<float>("Temucraft.ProfessionPerks.Mixology.Duration", 2.0f));
        settings.repair = sConfigMgr->GetOption<bool>("Temucraft.ProfessionPerks.RepairAll", true);
        settings.repairMinSkill = sConfigMgr->GetOption<uint32>("Temucraft.ProfessionPerks.RepairAll.MinSkill", 75);
        settings.toughness = sConfigMgr->GetOption<bool>("Temucraft.ProfessionPerks.Toughness", true);
        settings.toughnessPct = sConfigMgr->GetOption<float>("Temucraft.ProfessionPerks.Toughness.Percent", 1.0f);
        settings.toughnessStep = sConfigMgr->GetOption<uint32>("Temucraft.ProfessionPerks.Toughness.SkillStep", 75);
        settings.beasts = sConfigMgr->GetOption<bool>("Temucraft.ProfessionPerks.BeastsOfTheWild", true);
        settings.beastsPct = sConfigMgr->GetOption<float>("Temucraft.ProfessionPerks.BeastsOfTheWild.Percent", 1.0f);
        settings.beastsStep = sConfigMgr->GetOption<uint32>("Temucraft.ProfessionPerks.BeastsOfTheWild.SkillStep", 75);
        settings.scavenging = sConfigMgr->GetOption<bool>("Temucraft.ProfessionPerks.Scavenging", true);
        settings.scavengingChance = std::clamp(sConfigMgr->GetOption<float>("Temucraft.ProfessionPerks.Scavenging.Chance", 25.0f), 0.0f, 100.0f);

        // "75:28800 225:14400 375:7200": from that Blacksmithing skill, that many seconds between repairs
        settings.repairCooldown.clear();
        std::string steps = sConfigMgr->GetOption<std::string>("Temucraft.ProfessionPerks.RepairAll.Cooldown", "75:28800 225:14400 375:7200");
        std::replace(steps.begin(), steps.end(), ',', ' ');
        std::istringstream in(steps);
        std::string pair;
        while (in >> pair)
        {
            std::size_t colon = pair.find(':');
            if (colon == std::string::npos)
                continue;
            settings.repairCooldown.emplace_back(uint32(std::strtoul(pair.substr(0, colon).c_str(), nullptr, 10)),
                uint32(std::strtoul(pair.substr(colon + 1).c_str(), nullptr, 10)));
        }
        std::sort(settings.repairCooldown.begin(), settings.repairCooldown.end());
    }

    uint32 RepairCooldown(Player* player)
    {
        uint32 const skill = player->GetSkillValue(SKILL_BLACKSMITHING);
        uint32 cooldown = settings.repairCooldown.empty() ? 8 * HOUR : settings.repairCooldown.front().second;
        for (auto const& [from, seconds] : settings.repairCooldown)
            if (skill >= from)
                cooldown = seconds;
        return cooldown;
    }

    // Does the core's own Mixology already apply to this aura? (Mixology aura and the elixir's recipe known)
    bool CoreMixology(Player* player, SpellInfo const* info)
    {
        return player->HasAura(SPELL_MIXOLOGY) && player->HasSpell(info->Effects[EFFECT_0].TriggerSpell);
    }

    bool IsElixirOrFlask(SpellInfo const* info)
    {
        return info->SpellFamilyName == SPELLFAMILY_POTION &&
            (sSpellMgr->IsSpellMemberOfSpellGroup(info->Id, SPELL_GROUP_ELIXIR_BATTLE) ||
             sSpellMgr->IsSpellMemberOfSpellGroup(info->Id, SPELL_GROUP_ELIXIR_GUARDIAN));
    }
}

class TemucraftProfessionPerksWorld : public WorldScript
{
public:
    TemucraftProfessionPerksWorld() : WorldScript("TemucraftProfessionPerksWorld", { WORLDHOOK_ON_AFTER_CONFIG_LOAD }) { }

    void OnAfterConfigLoad(bool /*reload*/) override { LoadSettings(); }
};

class TemucraftProfessionPerksUnit : public UnitScript
{
public:
    TemucraftProfessionPerksUnit() : UnitScript("TemucraftProfessionPerksUnit", true,
        { UNITHOOK_ON_AURA_APPLY, UNITHOOK_MODIFY_MELEE_DAMAGE, UNITHOOK_MODIFY_SPELL_DAMAGE_TAKEN, UNITHOOK_MODIFY_PERIODIC_DAMAGE_AURAS_TICK }) { }

    // Mixology for every alchemist: the elixir's effects grow by its Mixology bonus and it lasts longer.
    void OnAuraApply(Unit* unit, Aura* aura) override
    {
        if (!settings.enable || !settings.mixology || !unit || !aura)
            return;
        Player* player = unit->ToPlayer();
        if (!player || aura->GetCasterGUID() != player->GetGUID() || player->GetSession()->PlayerLoading())
            return;
        SpellInfo const* info = aura->GetSpellInfo();
        if (!IsElixirOrFlask(info) || !player->HasSkill(SKILL_ALCHEMY) || player->GetSkillValue(SKILL_ALCHEMY) < settings.mixologyMinSkill)
            return;
        if (CoreMixology(player, info))
            return;
        int32 const baseDuration = player->CalcSpellDuration(info);
        if (aura->GetMaxDuration() != baseDuration)   // already longer: boosted before (refresh)
            return;
        float const bonus = sSpellMgr->GetSpellMixologyBonus(info->Id);
        for (uint8 i = 0; i < MAX_SPELL_EFFECTS; ++i)
            if (AuraEffect* effect = aura->GetEffect(i))
                if (effect->GetAmount())
                    effect->ChangeAmount(CalculatePct(effect->GetAmount(), 100.0f + bonus));
        aura->SetMaxDuration(int32(baseDuration * settings.mixologyDuration));
        aura->SetDuration(aura->GetMaxDuration());
    }

    // Beasts of the Wild: skinners hit beasts harder (their pets too).
    static float BeastBonus(Unit* target, Unit* attacker)
    {
        if (!settings.enable || !settings.beasts || !target || !attacker || target->GetCreatureType() != CREATURE_TYPE_BEAST || target->IsPlayer())
            return 0.0f;
        Player* player = attacker->GetCharmerOrOwnerPlayerOrPlayerItself();
        if (!player)
            return 0.0f;
        return Ranks(player, SKILL_SKINNING, settings.beastsStep) * settings.beastsPct;
    }

    void ModifyMeleeDamage(Unit* target, Unit* attacker, uint32& damage) override
    {
        if (float pct = BeastBonus(target, attacker))
            damage = uint32(damage * (1.0f + pct / 100.0f));
    }

    void ModifySpellDamageTaken(Unit* target, Unit* attacker, int32& damage, SpellInfo const* /*spellInfo*/) override
    {
        if (damage > 0)
            if (float pct = BeastBonus(target, attacker))
                damage = int32(damage * (1.0f + pct / 100.0f));
    }

    void ModifyPeriodicDamageAurasTick(Unit* target, Unit* attacker, uint32& damage, SpellInfo const* /*spellInfo*/) override
    {
        if (float pct = BeastBonus(target, attacker))
            damage = uint32(damage * (1.0f + pct / 100.0f));
    }
};

class TemucraftProfessionPerksPlayer : public PlayerScript
{
public:
    TemucraftProfessionPerksPlayer() : PlayerScript("TemucraftProfessionPerksPlayer",
        { PLAYERHOOK_ON_LOGIN, PLAYERHOOK_ON_LOGOUT, PLAYERHOOK_ON_AFTER_UPDATE_MAX_HEALTH, PLAYERHOOK_ON_UPDATE_SKILL,
          PLAYERHOOK_ON_LOOT_ITEM, PLAYERHOOK_ON_DELETE }) { }

    void OnPlayerLogin(Player* player) override
    {
        uint32 const guid = player->GetGUID().GetCounter();
        repairUsed.erase(guid);
        if (QueryResult r = CharacterDatabase.Query("SELECT `repaired` FROM `mod_temucraft_profession_perks` WHERE `guid` = {}", guid))
            repairUsed[guid] = r->Fetch()[0].Get<uint32>();
        if (settings.enable && settings.toughness && player->HasSkill(SKILL_MINING))
            player->UpdateMaxHealth();
    }

    void OnPlayerLogout(Player* player) override { repairUsed.erase(player->GetGUID().GetCounter()); }

    void OnPlayerDelete(ObjectGuid guid, uint32 /*accountId*/) override
    {
        CharacterDatabase.Execute("DELETE FROM `mod_temucraft_profession_perks` WHERE `guid` = {}", guid.GetCounter());
    }

    // Toughness: miners have more health.
    void OnPlayerAfterUpdateMaxHealth(Player* player, float& value) override
    {
        if (settings.enable && settings.toughness)
            if (float pct = Ranks(player, SKILL_MINING, settings.toughnessStep) * settings.toughnessPct)
                value *= 1.0f + pct / 100.0f;
    }

    // a new Toughness rank as the mining skill climbs
    void OnPlayerUpdateSkill(Player* player, uint32 skillId, uint32 value, uint32 /*max*/, uint32 /*step*/, uint32 newValue) override
    {
        if (settings.enable && settings.toughness && skillId == SKILL_MINING && settings.toughnessStep &&
            value / settings.toughnessStep != newValue / settings.toughnessStep)
            player->m_Events.AddEventAtOffset([player]() { player->UpdateMaxHealth(); }, 100ms);
    }

    // Cloth Scavenging: tailors sometimes find one more piece of cloth on a creature.
    void OnPlayerLootItem(Player* player, Item* item, uint32 /*count*/, ObjectGuid lootguid) override
    {
        if (!settings.enable || !settings.scavenging || !item || !lootguid.IsAnyTypeCreature() || !player->HasSkill(SKILL_TAILORING))
            return;
        ItemTemplate const* proto = item->GetTemplate();
        if (proto->Class != ITEM_CLASS_TRADE_GOODS || proto->SubClass != ITEM_SUBCLASS_CLOTH || !roll_chance_f(settings.scavengingChance))
            return;
        uint32 const entry = proto->ItemId;
        // after the loot window has handed over the item
        player->m_Events.AddEventAtOffset([player, entry]()
        {
            ItemPosCountVec dest;
            if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, entry, 1) == EQUIP_ERR_OK)
                if (Item* extra = player->StoreNewItem(dest, entry, true))
                    player->SendNewItem(extra, 1, true, false);
        }, 200ms);
    }
};

class TemucraftProfessionPerksCommands : public CommandScript
{
public:
    TemucraftProfessionPerksCommands() : CommandScript("TemucraftProfessionPerksCommands") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable table =
        {
            { "repairall", HandleRepairAll, SEC_PLAYER, Console::No },
        };
        return table;
    }

    // Repair All: a blacksmith mends all of their gear, free of charge, every few hours.
    static bool HandleRepairAll(ChatHandler* handler)
    {
        Player* player = handler->GetPlayer();
        if (!player)
            return false;
        if (!settings.enable || !settings.repair)
        {
            handler->SendSysMessage(Say(player, T_DISABLED, "Repair All isn't available on this server."));
            return true;
        }
        if (!player->HasSkill(SKILL_BLACKSMITHING) || player->GetSkillValue(SKILL_BLACKSMITHING) < settings.repairMinSkill)
        {
            handler->PSendSysMessage(Say(player, T_NO_SKILL, "Repair All needs Blacksmithing {}."), settings.repairMinSkill);
            return true;
        }
        uint32 const guid = player->GetGUID().GetCounter();
        uint32 const now = uint32(GameTime::GetGameTime().count());
        uint32 const ready = repairUsed[guid] + RepairCooldown(player);
        if (now < ready)
        {
            uint32 const left = ready - now;
            handler->PSendSysMessage(Say(player, T_WAIT, "Repair All is ready again in {} h {} min."), left / HOUR, (left % HOUR) / MINUTE);
            return true;
        }
        player->DurabilityRepairAll(false, 0.0f, false);
        repairUsed[guid] = now;
        CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_profession_perks` (`guid`, `repaired`) VALUES ({}, {})", guid, now);
        handler->SendSysMessage(Say(player, T_REPAIRED, "|cffe6cc80Repair All:|r your gear is mended."));
        return true;
    }
};

void AddTemucraftProfessionPerksScripts()
{
    new TemucraftProfessionPerksWorld();
    new TemucraftProfessionPerksUnit();
    new TemucraftProfessionPerksPlayer();
    new TemucraftProfessionPerksCommands();
}
