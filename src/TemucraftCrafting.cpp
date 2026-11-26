/*
 * mod-temucraft-professions: crafting stats (phase 2), from tools you carry and from how well you know the recipe.
 *
 *   Multicraft       chance for a craft of stackable goods (potions, bandages, food, gems, thread, ammo...) to make
 *                    extra (up to Temucraft.Crafting.MulticraftMaxExtra percent more)
 *   Resourcefulness  chance, for each kind of reagent, to get part of it back (Temucraft.Crafting.RefundPct)
 *
 * The stats come from tools in your bags or equipped (mod_temucraft_crafting_tool, per crafting skill or all) and
 * from mastery: as your skill climbs from a recipe's yellow rank to its grey rank you gain up to
 * Temucraft.Crafting.MasteryMulticraft / MasteryResourcefulness, so old recipes you've outgrown pay back.
 */
#include "TemucraftKnowledge.h"
#include "TemucraftModuleText.h"
#include "TemucraftProfGear.h"
#include "TemucraftQuality.h"
#include "TemucraftRacialStats.h"

#include "Chat.h"
#include "Config.h"
#include "DBCStores.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "Log.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "PlayerScript.h"
#include "ScriptMgr.h"
#include "Spell.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "WorldScript.h"
#include <algorithm>
#include <cmath>
#include <unordered_set>
#include <vector>

namespace
{
    // Blacksmithing, Leatherworking, Alchemy, Tailoring, Engineering, Enchanting, Jewelcrafting, Inscription,
    // Cooking, First Aid
    std::unordered_set<uint32> const CRAFT_SKILLS = { 164, 165, 171, 197, 202, 333, 755, 773, 185, 129 };

    struct CraftTool { uint32 item; uint32 skill; int32 multicraft; int32 resourcefulness; };

    struct CraftSettings
    {
        bool enable = true;
        int32 maxMulticraft = 50, maxResourcefulness = 50;
        int32 masteryMulticraft = 10, masteryResourcefulness = 10;
        uint32 maxExtra = 100;
        uint32 refundPct = 30;
        bool announce = true;
    } sCraft;

    std::vector<CraftTool> sCraftTools;

    void LoadCraftConfig()
    {
        sCraft.enable = sConfigMgr->GetOption<bool>("Temucraft.Crafting.Enable", true);
        sCraft.maxMulticraft = sConfigMgr->GetOption<int32>("Temucraft.Crafting.MaxMulticraft", 50);
        sCraft.maxResourcefulness = sConfigMgr->GetOption<int32>("Temucraft.Crafting.MaxResourcefulness", 50);
        sCraft.masteryMulticraft = sConfigMgr->GetOption<int32>("Temucraft.Crafting.MasteryMulticraft", 10);
        sCraft.masteryResourcefulness = sConfigMgr->GetOption<int32>("Temucraft.Crafting.MasteryResourcefulness", 10);
        sCraft.maxExtra = sConfigMgr->GetOption<uint32>("Temucraft.Crafting.MulticraftMaxExtra", 100);
        sCraft.refundPct = std::min<uint32>(sConfigMgr->GetOption<uint32>("Temucraft.Crafting.RefundPct", 30), 100);
        sCraft.announce = sConfigMgr->GetOption<bool>("Temucraft.Crafting.Announce", true);
    }

    void LoadCraftTools()
    {
        sCraftTools.clear();
        if (QueryResult result = WorldDatabase.Query("SELECT `ItemID`, `Skill`, `Multicraft`, `Resourcefulness` FROM `mod_temucraft_crafting_tool`"))
        {
            do
            {
                Field* f = result->Fetch();
                sCraftTools.push_back({ f[0].Get<uint32>(), f[1].Get<uint32>(), f[2].Get<int32>(), f[3].Get<int32>() });
            } while (result->NextRow());
        }
    }

    // The crafting skill line of a recipe, with its yellow and grey ranks
    SkillLineAbilityEntry const* CraftAbility(uint32 spellId)
    {
        SkillLineAbilityMapBounds bounds = sSpellMgr->GetSkillLineAbilityMapBounds(spellId);
        for (auto itr = bounds.first; itr != bounds.second; ++itr)
            if (CRAFT_SKILLS.count(itr->second->SkillLine))
                return itr->second;
        return nullptr;
    }

    void StatsFor(Player* player, SkillLineAbilityEntry const* ability, int32& multicraft, int32& resourcefulness)
    {
        multicraft = 0;
        resourcefulness = 0;
        for (CraftTool const& t : sCraftTools)
            if ((t.skill == 0 || t.skill == ability->SkillLine) && player->HasItemCount(t.item, 1, false))
            {
                multicraft += t.multicraft;
                resourcefulness += t.resourcefulness;
            }

        // Mastery: from the recipe's yellow rank (no bonus) to its grey rank (full bonus)
        uint32 skill = player->GetSkillValue(ability->SkillLine);
        uint32 yellow = ability->TrivialSkillLineRankLow, grey = ability->TrivialSkillLineRankHigh;
        if (grey > yellow && skill > yellow)
        {
            float mastery = std::min(1.0f, float(skill - yellow) / float(grey - yellow));
            multicraft += int32(std::lround(mastery * sCraft.masteryMulticraft));
            resourcefulness += int32(std::lround(mastery * sCraft.masteryResourcefulness));
        }
        multicraft += TemucraftProfGearStat(player, ability->SkillLine, GEAR_MULTICRAFT);
        resourcefulness += TemucraftProfGearStat(player, ability->SkillLine, GEAR_RESOURCEFULNESS);
        multicraft += TemucraftRacialProfStat(player, ability->SkillLine, GEAR_MULTICRAFT);
        resourcefulness += TemucraftRacialProfStat(player, ability->SkillLine, GEAR_RESOURCEFULNESS);
        multicraft += TemucraftSpecBonus(player, ability->SkillLine, PROF_STAT_MULTICRAFT);
        resourcefulness += TemucraftSpecBonus(player, ability->SkillLine, PROF_STAT_RESOURCEFULNESS);
        multicraft = std::clamp(multicraft, 0, sCraft.maxMulticraft);
        resourcefulness = std::clamp(resourcefulness, 0, sCraft.maxResourcefulness);
    }
}

class TemucraftCrafting_Player : public PlayerScript
{
public:
    TemucraftCrafting_Player() : PlayerScript("TemucraftCrafting_Player") { }

    // Runs once per created stack, just after the reagents were taken
    void OnPlayerCreateItem(Player* player, Item* item, uint32 count) override
    {
        if (!sCraft.enable || !item)
            return;
        Spell const* spell = player->GetCurrentSpell(CURRENT_GENERIC_SPELL);
        if (!spell)
            return;
        SpellInfo const* info = spell->GetSpellInfo();
        SkillLineAbilityEntry const* ability = CraftAbility(info->Id);
        if (!ability)
            return;

        TemucraftKnowledgeFirst(player, ability->SkillLine, info->Id, (std::string("craft of ") + item->GetTemplate()->Name1).c_str());

        int32 multicraft = 0, resourcefulness = 0;
        StatsFor(player, ability, multicraft, resourcefulness);
        // Concentration switched on: every roll of this craft succeeds
        bool concentrated = TemucraftUseConcentration(player, ability->SkillLine);
        TemucraftCraftQuality(player, item, info, ability, concentrated);
        if (concentrated)
        {
            multicraft = 100;
            resourcefulness = 100;
            ChatHandler(player->GetSession()).PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", player->GetSession(), 1, "|cff66ccff[Concentration]|r Spent on this craft."));
        }
        ChatHandler chat(player->GetSession());

        // Multicraft: stackable goods only
        ItemTemplate const* proto = item->GetTemplate();
        if (multicraft > 0 && proto->GetMaxStackSize() > 1 && roll_chance_i(multicraft))
        {
            uint32 most = std::max<uint32>(1, count * sCraft.maxExtra / 100);
            uint32 extra = std::min<uint32>(urand(1, most), proto->GetMaxStackSize());
            if (player->AddItem(proto->ItemId, extra) && sCraft.announce)
                chat.PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", chat, 2, "|cff66ccff[Multicraft]|r You made {} more {}."), extra, proto->Name1);
        }

        // Resourcefulness: each kind of reagent rolls on its own
        if (resourcefulness > 0)
        {
            std::string refunded;
            for (uint8 i = 0; i < MAX_SPELL_REAGENTS; ++i)
            {
                if (info->Reagent[i] <= 0 || info->ReagentCount[i] == 0 || !roll_chance_i(resourcefulness))
                    continue;
                uint32 back = std::max<uint32>(1, uint32(std::lround(info->ReagentCount[i] * sCraft.refundPct / 100.0f)));
                back = std::min<uint32>(back, info->ReagentCount[i]);
                if (!player->AddItem(uint32(info->Reagent[i]), back))
                    continue;
                if (ItemTemplate const* reagent = sObjectMgr->GetItemTemplate(info->Reagent[i]))
                    refunded += (refunded.empty() ? "" : ", ") + std::to_string(back) + " " + reagent->Name1;
            }
            if (!refunded.empty() && sCraft.announce)
                chat.PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", chat, 3, "|cff66ccff[Resourcefulness]|r You saved {}."), refunded);
        }
    }
};

class TemucraftCrafting_World : public WorldScript
{
public:
    TemucraftCrafting_World() : WorldScript("TemucraftCrafting_World") { }

    void OnAfterConfigLoad(bool /*reload*/) override { LoadCraftConfig(); }

    void OnStartup() override
    {
        LoadCraftTools();
        LOG_INFO("server.loading", ">> mod-temucraft-professions: {} crafting tools", sCraftTools.size());
    }
};

// A crafting profession's stats without a recipe (Mastery depends on the recipe, so it isn't in this number)
void TemucraftCraftingStats(Player* player, uint32 skill, int32& multicraft, int32& resourcefulness)
{
    multicraft = 0;
    resourcefulness = 0;
    for (CraftTool const& t : sCraftTools)
        if ((t.skill == 0 || t.skill == skill) && player->HasItemCount(t.item, 1, false))
        {
            multicraft += t.multicraft;
            resourcefulness += t.resourcefulness;
        }
    multicraft += TemucraftProfGearStat(player, skill, GEAR_MULTICRAFT);
    resourcefulness += TemucraftProfGearStat(player, skill, GEAR_RESOURCEFULNESS);
    multicraft += TemucraftRacialProfStat(player, skill, GEAR_MULTICRAFT);
    resourcefulness += TemucraftRacialProfStat(player, skill, GEAR_RESOURCEFULNESS);
    multicraft += TemucraftSpecBonus(player, skill, PROF_STAT_MULTICRAFT);
    resourcefulness += TemucraftSpecBonus(player, skill, PROF_STAT_RESOURCEFULNESS);
    multicraft = std::clamp(multicraft, 0, sCraft.maxMulticraft);
    resourcefulness = std::clamp(resourcefulness, 0, sCraft.maxResourcefulness);
}

void AddTemucraftCraftingScripts()
{
    new TemucraftCrafting_Player();
    new TemucraftCrafting_World();
}
