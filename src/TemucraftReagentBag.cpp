/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

// Reagent bag: an extra bag for crafting reagents, kept by the server next to the profession equipment (the 3.3.5
// client can't show a sixth bag slot). It holds Temucraft.ReagentBag.Slots stacks of trade goods and reagents.
//   - "Send reagents here" (per character, on by default): reagents you loot or craft go straight into it
//   - the profession equipment window (TemucraftProfGear addon) shows it as a bag grid: click to take a stack out,
//     shift-click to take all of it; "Deposit reagents" moves every reagent from your bags
//   - the trade skill window gets a "Reagent bag" button: it takes what the selected recipe needs (times the number
//     in the box) out of the reagent bag into your bags, so Create works as usual
//   - without the addon: .temucraft profgear -> Reagent bag (gossip pages)
// What fits: stackable trade goods (class 7), reagents (class 5) and misc reagents (15/1), not limited (max count) or
// timed items. Addon messages use the profession equipment prefix TPG (R* commands).

#include "TemucraftReagentBag.h"

#include "Bag.h"
#include "Chat.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedGossip.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "TemucraftModuleText.h"
#include "WorldPacket.h"
#include "WorldSession.h"
#include <map>
#include <unordered_map>
#include <vector>

namespace
{
    char const* const MODULE = "mod-temucraft-professions";
    constexpr uint32 MENU = 608601;
    constexpr uint32 PAGE_SIZE = 18;
    enum Action : uint32 { A_PAGE = 1, A_TOGGLE = 2, A_DEPOSIT = 3, A_TAKE = 100000 };

    struct Settings { bool enable = true; uint32 slots = 28; bool autoDefault = true; } cfg;

    struct ReagentStore
    {
        std::map<uint32, uint32> items;   // entry -> count
        bool autoDeposit = true;
    };
    std::unordered_map<ObjectGuid::LowType, ReagentStore> bags;
    struct PendingMove { uint32 entry; uint32 count; };
    std::unordered_map<ObjectGuid::LowType, std::vector<PendingMove>> pending;   // moved on the next update (the core
                                                                                 // still uses the new item after the hook)

    char const* T(Player* p, uint32 id, char const* fb) { return TemucraftModuleText(MODULE, p, id, fb); }

    bool Fits(ItemTemplate const* proto)
    {
        if (!proto || proto->GetMaxStackSize() <= 1 || proto->MaxCount > 0 || proto->Duration)
            return false;
        return proto->Class == ITEM_CLASS_TRADE_GOODS || proto->Class == ITEM_CLASS_REAGENT
            || (proto->Class == ITEM_CLASS_MISC && proto->SubClass == ITEM_SUBCLASS_JUNK_REAGENT);
    }

    uint32 StacksOf(uint32 entry, uint32 count)
    {
        ItemTemplate const* proto = sObjectMgr->GetItemTemplate(entry);
        uint32 stack = proto ? std::max<uint32>(1, proto->GetMaxStackSize()) : 1;
        return (count + stack - 1) / stack;
    }

    uint32 UsedSlots(ReagentStore const& bag)
    {
        uint32 used = 0;
        for (auto const& [entry, count] : bag.items)
            used += StacksOf(entry, count);
        return used;
    }

    // how many of this item still fit
    uint32 Room(ReagentStore const& bag, uint32 entry)
    {
        ItemTemplate const* proto = sObjectMgr->GetItemTemplate(entry);
        if (!Fits(proto))
            return 0;
        uint32 stack = proto->GetMaxStackSize();
        auto it = bag.items.find(entry);
        uint32 have = it == bag.items.end() ? 0 : it->second;
        uint32 usedOthers = UsedSlots(bag) - StacksOf(entry, have);
        if (usedOthers >= cfg.slots)
            return 0;
        return (cfg.slots - usedOthers) * stack - have;
    }

    ReagentStore& BagOf(Player* player) { return bags[player->GetGUID().GetCounter()]; }

    void SaveItem(Player* player, uint32 entry, uint32 count)
    {
        uint32 guid = player->GetGUID().GetCounter();
        if (count)
            CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_reagent_bag` (`guid`, `item`, `count`) VALUES ({}, {}, {})", guid, entry, count);
        else
            CharacterDatabase.Execute("DELETE FROM `mod_temucraft_reagent_bag` WHERE `guid` = {} AND `item` = {}", guid, entry);
    }

    void SendAddon(Player* player, std::string const& text)
    {
        WorldPacket data;
        ChatHandler::BuildChatPacket(data, CHAT_MSG_WHISPER, LANG_ADDON, player, player, "TPG\t" + text);
        player->SendDirectMessage(&data);
    }

    // RS <auto> <slots> <used>, then RI <entry>:<count>;... in pieces, then RE
    void SendBag(Player* player)
    {
        if (!cfg.enable)
            return;
        ReagentStore& bag = BagOf(player);
        SendAddon(player, Acore::StringFormat("RS {} {} {}", bag.autoDeposit ? 1 : 0, cfg.slots, UsedSlots(bag)));
        std::string chunk;
        for (auto const& [entry, count] : bag.items)
        {
            std::string part = Acore::StringFormat("{}:{};", entry, count);
            if (chunk.size() + part.size() > 200)
            {
                SendAddon(player, "RI " + chunk);
                chunk.clear();
            }
            chunk += part;
        }
        if (!chunk.empty())
            SendAddon(player, "RI " + chunk);
        SendAddon(player, "RE");
    }

    // moves up to `count` of an item from the bags into the reagent bag; returns how many moved
    uint32 Deposit(Player* player, uint32 entry, uint32 count)
    {
        ReagentStore& bag = BagOf(player);
        count = std::min({ count, Room(bag, entry), player->GetItemCount(entry, false) });
        if (!count)
            return 0;
        player->DestroyItemCount(entry, count, true);
        bag.items[entry] += count;
        SaveItem(player, entry, bag.items[entry]);
        return count;
    }

    // every reagent in the backpack and bags
    uint32 DepositAll(Player* player)
    {
        std::map<uint32, uint32> found;
        auto look = [&](Item* item)
        {
            if (item && Fits(item->GetTemplate()) && !item->IsInTrade())
                found[item->GetEntry()] += item->GetCount();
        };
        for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
            look(player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot));
        for (uint8 b = INVENTORY_SLOT_BAG_START; b < INVENTORY_SLOT_BAG_END; ++b)
            if (::Bag* container = player->GetBagByPos(b))
                for (uint32 slot = 0; slot < container->GetBagSize(); ++slot)
                    look(container->GetItemByPos(uint8(slot)));
        uint32 moved = 0;
        for (auto const& [entry, count] : found)
            moved += Deposit(player, entry, count);
        return moved;
    }

    // takes up to `count` out into the bags; returns how many came out
    uint32 Withdraw(Player* player, uint32 entry, uint32 count)
    {
        ReagentStore& bag = BagOf(player);
        auto it = bag.items.find(entry);
        if (it == bag.items.end())
            return 0;
        count = std::min(count, it->second);
        uint32 noSpace = 0;
        ItemPosCountVec dest;
        if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, entry, count, &noSpace) != EQUIP_ERR_OK)
            count -= noSpace;
        if (!count || dest.empty())
            return 0;
        if (Item* item = player->StoreNewItem(dest, entry, true))
            player->SendNewItem(item, count, true, false);
        it->second -= count;
        SaveItem(player, entry, it->second);
        if (!it->second)
            bag.items.erase(it);
        return count;
    }

    // what a recipe needs, times `times`, minus what is already in the bags
    uint32 PullFor(Player* player, uint32 spellId, uint32 times)
    {
        SpellInfo const* info = sSpellMgr->GetSpellInfo(spellId);
        if (!info || !player->HasSpell(spellId))
            return 0;
        times = std::clamp<uint32>(times, 1, 200);
        uint32 moved = 0;
        for (uint8 i = 0; i < MAX_SPELL_REAGENTS; ++i)
        {
            if (info->Reagent[i] <= 0 || !info->ReagentCount[i])
                continue;
            uint32 entry = uint32(info->Reagent[i]);
            uint32 need = info->ReagentCount[i] * times, have = player->GetItemCount(entry, false);
            if (need > have)
                moved += Withdraw(player, entry, need - have);
        }
        return moved;
    }

    std::string ItemName(uint32 entry)
    {
        ItemTemplate const* proto = sObjectMgr->GetItemTemplate(entry);
        return proto ? proto->Name1 : "?";
    }

    void SendMenu(Player* player, uint32 page)
    {
        ReagentStore& bag = BagOf(player);
        ClearGossipMenuFor(player);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, Acore::StringFormat(bag.autoDeposit
            ? T(player, 40, "Send reagents here: on ({}/{} slots used)") : T(player, 41, "Send reagents here: off ({}/{} slots used)"), UsedSlots(bag), cfg.slots),
            GOSSIP_SENDER_MAIN, A_TOGGLE);
        AddGossipItemFor(player, GOSSIP_ICON_MONEY_BAG, T(player, 42, "Deposit every reagent from my bags"), GOSSIP_SENDER_MAIN, A_DEPOSIT);
        uint32 i = 0, shown = 0;
        for (auto const& [entry, count] : bag.items)
        {
            if (i++ < page * PAGE_SIZE)
                continue;
            if (shown++ >= PAGE_SIZE)
            {
                AddGossipItemFor(player, GOSSIP_ICON_CHAT, T(player, 43, "Next page"), GOSSIP_SENDER_MAIN, A_PAGE + (page + 1) * 10);
                break;
            }
            uint32 stack = sObjectMgr->GetItemTemplate(entry) ? sObjectMgr->GetItemTemplate(entry)->GetMaxStackSize() : 1;
            AddGossipItemFor(player, GOSSIP_ICON_VENDOR, Acore::StringFormat(T(player, 44, "Take {} x{} (of {})"), ItemName(entry), std::min(count, stack), count),
                             entry, A_TAKE);
        }
        if (page)
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, T(player, 45, "First page"), GOSSIP_SENDER_MAIN, A_PAGE);
        player->PlayerTalkClass->GetGossipMenu().SetMenuId(MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, player->GetGUID());
    }
}

void TemucraftReagentBagMenu(Player* player)
{
    if (cfg.enable)
        SendMenu(player, 0);
}

bool TemucraftReagentBagMessage(Player* player, std::vector<std::string_view> const& args)
{
    if (args.empty() || args[0].size() != 2 || args[0][0] != 'R')
        return false;
    if (!cfg.enable)
        return true;
    auto num = [&](size_t i) -> uint32 { return i < args.size() ? uint32(std::strtoul(std::string(args[i]).c_str(), nullptr, 10)) : 0; };
    ChatHandler handler(player->GetSession());
    char c = args[0][1];
    if (c == 'G') { }                                               // RG: just the state
    else if (c == 'T')                                              // RT 0|1: send reagents here
    {
        ReagentStore& bag = BagOf(player);
        bag.autoDeposit = num(1) != 0;
        CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_character_setting` (`guid`, `setting`, `value`) VALUES ({}, 'reagentbag', {})", player->GetGUID().GetCounter(), bag.autoDeposit ? 1 : 0);
    }
    else if (c == 'W')                                              // RW entry count: take out
    {
        if (!Withdraw(player, num(1), num(2)))
            SendAddon(player, std::string("ER ") + T(player, 46, "Your bags are full."));
    }
    else if (c == 'D')                                              // RD bag slot: put one stack in
    {
        Item* item = player->GetItemByPos(uint8(num(1)), uint8(num(2)));
        if (!item || !Player::IsInventoryPos(uint8(num(1)), uint8(num(2))) || !Fits(item->GetTemplate()))
            SendAddon(player, std::string("ER ") + T(player, 47, "That isn't a reagent."));
        else if (!Deposit(player, item->GetEntry(), item->GetCount()))
            SendAddon(player, std::string("ER ") + T(player, 48, "Your reagent bag is full."));
    }
    else if (c == 'A')                                              // RA: deposit everything
        DepositAll(player);
    else if (c == 'P')                                              // RP spell times: what a recipe needs
    {
        if (!PullFor(player, num(1), num(2)))
            SendAddon(player, std::string("ER ") + T(player, 49, "Nothing for this recipe in your reagent bag."));
    }
    SendBag(player);
    return true;
}

class TemucraftReagentBag_Player : public PlayerScript
{
public:
    TemucraftReagentBag_Player() : PlayerScript("TemucraftReagentBag_Player") { }

    void OnPlayerLogin(Player* player) override
    {
        if (!cfg.enable)
            return;
        uint32 guid = player->GetGUID().GetCounter();
        ReagentStore& bag = bags[guid];
        bag.items.clear();
        bag.autoDeposit = cfg.autoDefault;
        if (QueryResult r = CharacterDatabase.Query("SELECT `item`, `count` FROM `mod_temucraft_reagent_bag` WHERE `guid` = {}", guid))
            do bag.items[(*r)[0].Get<uint32>()] = (*r)[1].Get<uint32>(); while (r->NextRow());
        if (QueryResult r = CharacterDatabase.Query("SELECT `value` FROM `mod_temucraft_character_setting` WHERE `guid` = {} AND `setting` = 'reagentbag'", guid))
            bag.autoDeposit = (*r)[0].Get<int32>() != 0;
    }

    void OnPlayerLogout(Player* player) override
    {
        bags.erase(player->GetGUID().GetCounter());
        pending.erase(player->GetGUID().GetCounter());
    }

    void OnPlayerDelete(ObjectGuid guid, uint32 /*account*/) override
    {
        CharacterDatabase.Execute("DELETE FROM `mod_temucraft_reagent_bag` WHERE `guid` = {}", guid.GetCounter());
        CharacterDatabase.Execute("DELETE FROM `mod_temucraft_character_setting` WHERE `guid` = {} AND `setting` = 'reagentbag'", guid.GetCounter());
    }

    void Queue(Player* player, Item* item, uint32 count)
    {
        if (!cfg.enable || !item || !Fits(item->GetTemplate()))
            return;
        auto it = bags.find(player->GetGUID().GetCounter());
        if (it == bags.end() || !it->second.autoDeposit)
            return;
        pending[player->GetGUID().GetCounter()].push_back({ item->GetEntry(), count });
    }

    void OnPlayerLootItem(Player* player, Item* item, uint32 count, ObjectGuid /*lootguid*/) override { Queue(player, item, count); }
    void OnPlayerCreateItem(Player* player, Item* item, uint32 count) override { Queue(player, item, count); }

    void OnPlayerUpdate(Player* player, uint32 /*diff*/) override
    {
        auto it = pending.find(player->GetGUID().GetCounter());
        if (it == pending.end())
            return;
        std::vector<PendingMove> moves;
        moves.swap(it->second);
        pending.erase(it);
        bool any = false, full = false;
        for (PendingMove const& m : moves)
        {
            uint32 moved = Deposit(player, m.entry, m.count);
            any |= moved > 0;
            full |= moved < m.count;
        }
        if (any)
            SendBag(player);
        if (full)
            ChatHandler(player->GetSession()).SendSysMessage(T(player, 48, "Your reagent bag is full."));
    }

    void OnPlayerGossipSelect(Player* player, uint32 menu, uint32 sender, uint32 action) override
    {
        if (menu != MENU || !cfg.enable)
            return;
        if (action == A_TAKE)
        {
            ItemTemplate const* proto = sObjectMgr->GetItemTemplate(sender);
            if (!Withdraw(player, sender, proto ? proto->GetMaxStackSize() : 1))
                ChatHandler(player->GetSession()).SendSysMessage(T(player, 46, "Your bags are full."));
            return SendMenu(player, 0);
        }
        if (action == A_TOGGLE)
        {
            std::vector<std::string_view> args = { "RT", BagOf(player).autoDeposit ? "0" : "1" };
            TemucraftReagentBagMessage(player, args);
            return SendMenu(player, 0);
        }
        if (action == A_DEPOSIT)
        {
            DepositAll(player);
            SendBag(player);
            return SendMenu(player, 0);
        }
        if (action % 10 == A_PAGE)
            return SendMenu(player, action / 10);
    }
};

class TemucraftReagentBag_World : public WorldScript
{
public:
    TemucraftReagentBag_World() : WorldScript("TemucraftReagentBag_World") { }

    void OnAfterConfigLoad(bool /*reload*/) override
    {
        cfg.enable = sConfigMgr->GetOption<bool>("Temucraft.ReagentBag.Enable", true);
        cfg.slots = std::max<uint32>(1, sConfigMgr->GetOption<uint32>("Temucraft.ReagentBag.Slots", 28));
        cfg.autoDefault = sConfigMgr->GetOption<bool>("Temucraft.ReagentBag.AutoDeposit", true);
    }
};

void AddTemucraftReagentBagScripts()
{
    new TemucraftReagentBag_Player();
    new TemucraftReagentBag_World();
}
