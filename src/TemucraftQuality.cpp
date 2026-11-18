/*
 * mod-temucraft-professions: crafted quality ranks (1 to 5) and recrafting.
 *
 * Gear you craft gets a quality rank. The rank comes from how far your skill is past the recipe's yellow rank (at its
 * grey rank you're likely to reach 3), a little luck, and concentration (always rank 5). The client has nothing to
 * show quality on items, so the rank works through the random enchantment: the item's enchantment ("of the Bear",
 * "of the Owl"...) is rolled as many times as its rank and the strongest is kept. Gear without a random enchantment
 * pool still records its rank (for recrafting later), without a bonus.
 *
 * .recraft <item link>  crafts a piece you made again for Temucraft.Quality.RecraftReagentPct percent of its
 *                       reagents, with your current skill: you keep the better of the old and new results.
 */

#include "TemucraftKnowledge.h"
#include "TemucraftModuleText.h"
#include "TemucraftQuality.h"

#include "Chat.h"
#include "ChatCommand.h"
#include "Config.h"
#include "DBCStores.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "WorldScript.h"

#include <cmath>

using namespace Acore::ChatCommands;

namespace
{
    struct QualitySettings { bool enable = true; uint32 recraftPct = 50; bool announce = true; } qcfg;

    char const* const RANK_NAMES[6] = { "", "1 (Rough)", "2 (Fine)", "3 (Superior)", "4 (Exceptional)", "5 (Masterwork)" };

    // How strong a random enchantment is: stat points (properties) or allocation (suffixes, scaled by the item later)
    uint32 Strength(int32 randomId)
    {
        uint32 total = 0;
        if (randomId > 0)
        {
            if (ItemRandomPropertiesEntry const* e = sItemRandomPropertiesStore.LookupEntry(randomId))
                for (uint32 id : e->Enchantment)
                    if (SpellItemEnchantmentEntry const* ench = id ? sSpellItemEnchantmentStore.LookupEntry(id) : nullptr)
                        for (uint8 i = 0; i < MAX_SPELL_ITEM_ENCHANTMENT_EFFECTS; ++i)
                            total += ench->amount[i];
        }
        else if (randomId < 0)
        {
            if (ItemRandomSuffixEntry const* e = sItemRandomSuffixStore.LookupEntry(-randomId))
                for (uint32 pct : e->AllocationPct)
                    total += pct;
        }
        return total;
    }

    uint32 RollRank(Player* player, SkillLineAbilityEntry const* ability, bool concentrated)
    {
        if (concentrated)
            return 5;
        uint32 skill = player->GetSkillValue(ability->SkillLine);
        uint32 yellow = ability->TrivialSkillLineRankLow, grey = ability->TrivialSkillLineRankHigh;
        float mastery = grey > yellow && skill > yellow ? std::min(1.0f, float(skill - yellow) / float(grey - yellow)) : 0.0f;
        // 1 + up to 2 from mastery, then luck: 25% for one rank more, 5% for two
        uint32 rank = 1 + uint32(std::floor(mastery * 2.0f + 0.25f));
        uint32 luck = urand(1, 100);
        rank += luck <= 5 ? 2 : luck <= 30 ? 1 : 0;
        return std::min<uint32>(rank, 5);
    }

    // Rolls the item's random enchantment `rank` times and keeps the strongest (and the current one, if better)
    bool ImproveEnchant(Item* item, uint32 rank, int32 keep)
    {
        ItemTemplate const* proto = item->GetTemplate();
        if (!proto->RandomProperty && !proto->RandomSuffix)
            return false;
        int32 best = keep;
        for (uint32 i = 0; i < rank; ++i)
        {
            int32 id = Item::GenerateItemRandomPropertyId(proto->ItemId);
            if (id && (!best || Strength(id) > Strength(best)))
                best = id;
        }
        if (best && best != item->GetItemRandomPropertyId())
            item->SetItemRandomProperties(best);
        return true;
    }

    // Gear: anything you equip, uncommon or better
    bool IsGear(ItemTemplate const* proto)
    {
        return proto->InventoryType != INVTYPE_NON_EQUIP && proto->InventoryType != INVTYPE_BAG && proto->InventoryType != INVTYPE_QUIVER
            && proto->Quality >= ITEM_QUALITY_UNCOMMON;
    }

    Item* FindCrafted(Player* player, uint32 entry, uint32& rank, uint32& recipe)
    {
        auto check = [&](Item* item) -> bool
        {
            if (!item || item->GetEntry() != entry)
                return false;
            if (QueryResult r = CharacterDatabase.Query("SELECT `rank`, `recipe` FROM `mod_temucraft_crafted_item` WHERE `item` = {} AND `crafter` = {}",
                                                        item->GetGUID().GetCounter(), player->GetGUID().GetCounter()))
            {
                rank = r->Fetch()[0].Get<uint32>();
                recipe = r->Fetch()[1].Get<uint32>();
                return true;
            }
            return false;
        };
        for (uint8 slot = EQUIPMENT_SLOT_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
            if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
                if (check(item))
                    return item;
        for (uint8 bag = INVENTORY_SLOT_BAG_START; bag < INVENTORY_SLOT_BAG_END; ++bag)
            if (Bag* container = player->GetBagByPos(bag))
                for (uint32 slot = 0; slot < container->GetBagSize(); ++slot)
                    if (Item* item = container->GetItemByPos(uint8(slot)))
                        if (check(item))
                            return item;
        return nullptr;
    }
}

void TemucraftCraftQuality(Player* player, Item* item, SpellInfo const* recipe, SkillLineAbilityEntry const* ability, bool concentrated)
{
    if (!qcfg.enable || !item || !IsGear(item->GetTemplate()))
        return;
    uint32 rank = RollRank(player, ability, concentrated);
    bool improved = ImproveEnchant(item, rank, item->GetItemRandomPropertyId());
    CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_crafted_item` (`item`, `rank`, `recipe`, `crafter`) VALUES ({}, {}, {}, {})",
                              item->GetGUID().GetCounter(), rank, recipe->Id, player->GetGUID().GetCounter());
    if (qcfg.announce)
        ChatHandler(player->GetSession()).PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", player->GetSession(), 15, "|cff66ccff[Quality]|r {} crafted at quality {}{}."), item->GetTemplate()->Name1,
                                                          RANK_NAMES[rank], improved ? "" : " (no random enchantment to improve)");
}

class TemucraftQuality_World : public WorldScript
{
public:
    TemucraftQuality_World() : WorldScript("TemucraftQuality_World") { }

    void OnAfterConfigLoad(bool /*reload*/) override
    {
        qcfg.enable = sConfigMgr->GetOption<bool>("Temucraft.Quality.Enable", true);
        qcfg.recraftPct = std::min<uint32>(sConfigMgr->GetOption<uint32>("Temucraft.Quality.RecraftReagentPct", 50), 100);
        qcfg.announce = sConfigMgr->GetOption<bool>("Temucraft.Quality.Announce", true);
    }
};

class TemucraftQuality_Commands : public CommandScript
{
public:
    TemucraftQuality_Commands() : CommandScript("TemucraftQuality_Commands") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "recraft", HandleRecraft, SEC_PLAYER, Console::No },
        };
        return commandTable;
    }

    static bool HandleRecraft(ChatHandler* handler, Variant<Hyperlink<item>, uint32> itemArg)
    {
        if (!qcfg.enable)
            return true;
        Player* player = handler->GetPlayer();
        uint32 entry = itemArg.holds_alternative<Hyperlink<item>>() ? itemArg.get<Hyperlink<item>>()->Item->ItemId : itemArg.get<uint32>();
        uint32 oldRank = 0, recipeId = 0;
        Item* item = FindCrafted(player, entry, oldRank, recipeId);
        SpellInfo const* recipe = recipeId ? sSpellMgr->GetSpellInfo(recipeId) : nullptr;
        if (!item || !recipe)
        {
            handler->SendSysMessage(TemucraftModuleText("mod-temucraft-professions", handler, 16, "Recraft needs a piece you crafted yourself, in your bags or equipped: .recraft <shift-click the item>"));
            return true;
        }
        SkillLineAbilityEntry const* ability = nullptr;
        SkillLineAbilityMapBounds bounds = sSpellMgr->GetSkillLineAbilityMapBounds(recipe->Id);
        for (auto itr = bounds.first; itr != bounds.second && !ability; ++itr)
            ability = itr->second;
        if (!ability || !player->HasSpell(recipe->Id))
        {
            handler->SendSysMessage(TemucraftModuleText("mod-temucraft-professions", handler, 17, "You need to know the recipe to recraft it."));
            return true;
        }

        // A share of each reagent
        std::vector<std::pair<uint32, uint32>> cost;
        for (uint8 i = 0; i < MAX_SPELL_REAGENTS; ++i)
            if (recipe->Reagent[i] > 0 && recipe->ReagentCount[i])
            {
                uint32 count = std::max<uint32>(1, uint32(std::ceil(recipe->ReagentCount[i] * qcfg.recraftPct / 100.0f)));
                if (!player->HasItemCount(uint32(recipe->Reagent[i]), count, false))
                {
                    ItemTemplate const* reagent = sObjectMgr->GetItemTemplate(recipe->Reagent[i]);
                    handler->PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", handler, 18, "Recrafting needs {} {}."), count, reagent ? reagent->Name1 : "?");
                    return true;
                }
                cost.emplace_back(uint32(recipe->Reagent[i]), count);
            }
        for (auto const& [reagent, count] : cost)
            player->DestroyItemCount(reagent, count, true);

        bool concentrated = TemucraftUseConcentration(player, ability->SkillLine);
        uint32 rank = std::max(oldRank, RollRank(player, ability, concentrated));
        bool equipped = item->IsEquipped();
        if (equipped)
            player->_ApplyItemMods(item, item->GetSlot(), false);
        ImproveEnchant(item, rank, item->GetItemRandomPropertyId());
        item->SetState(ITEM_CHANGED, player);
        if (equipped)
            player->_ApplyItemMods(item, item->GetSlot(), true);
        CharacterDatabase.Execute("UPDATE `mod_temucraft_crafted_item` SET `rank` = {} WHERE `item` = {}", rank, item->GetGUID().GetCounter());
        handler->PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", handler, 19, "|cff66ccff[Quality]|r {} recrafted: quality {} (was {})."), item->GetTemplate()->Name1, RANK_NAMES[rank], RANK_NAMES[oldRank]);
        return true;
    }
};

void AddTemucraftQualityScripts()
{
    new TemucraftQuality_World();
    new TemucraftQuality_Commands();
}
