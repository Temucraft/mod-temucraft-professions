/*
 * mod-temucraft-professions: profession equipment. Each profession has three slots kept by the server, apart from
 * bags and gear: a tool and two accessories. Equipping takes the item out of your bags (its random enchantment,
 * enchant, creator, durability and crafted quality are kept); taking it off puts the same item back.
 *
 * What may go in: mod_temucraft_profgear_item (world): item, profession (0 = any), tool or accessory, and what it
 * gives: profession skill, Finesse, Perception, Deftness, Multicraft, Resourcefulness. Worn equipment counts for the
 * gathering and crafting stats; the skill bonus raises the profession's skill while worn.
 *
 *   .temucraft profgear                 menu: your professions, their slots, equip from your bags, take off
 *   TemucraftProfGear addon   a panel on the character window (/profgear); alt-right-click an item in your bags
 *                             to wear it. It talks to the server with hidden addon messages (prefix TPG).
 */

#include "TemucraftProfGear.h"
#include "TemucraftReagentBag.h"

#include "TemucraftModuleText.h"
#include "Bag.h"
#include "Chat.h"
#include "ChatCommand.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedGossip.h"
#include "Tokenize.h"
#include "WorldPacket.h"
#include "WorldSession.h"

#include <array>
#include <map>
#include <unordered_map>

using namespace Acore::ChatCommands;

namespace
{
    constexpr uint32 PROFGEAR_MENU = 608600;
    constexpr uint8 SLOT_COUNT = 3;                 // 0 tool, 1-2 accessories
    constexpr char const* PREFIX = "TPG";
    enum Sender : uint32 { SENDER_MAIN = 1, SENDER_SKILL, SENDER_SLOT, SENDER_EQUIP, SENDER_UNEQUIP, SENDER_REAGENTS };

    struct GearDef { uint32 item; uint32 skill; uint8 kind; int32 skillBonus; std::array<int32, GEAR_STAT_COUNT> stats; };
    struct Worn { uint32 entry = 0; int32 randomProp = 0; uint32 suffix = 0; uint32 creator = 0; uint32 enchant = 0; uint32 durability = 0; uint32 oldGuid = 0; };

    struct ProfessionName { uint32 skill; char const* name; };
    ProfessionName const PROFESSIONS[] =
    {
        { 182, "Herbalism" }, { 186, "Mining" }, { 393, "Skinning" }, { 356, "Fishing" }, { 164, "Blacksmithing" },
        { 165, "Leatherworking" }, { 171, "Alchemy" }, { 197, "Tailoring" }, { 202, "Engineering" }, { 333, "Enchanting" },
        { 755, "Jewelcrafting" }, { 773, "Inscription" }, { 185, "Cooking" }, { 129, "First Aid" },
    };
    char const* const SLOT_NAMES[SLOT_COUNT] = { "Tool", "Accessory", "Accessory" };

    bool enabled = true;
    std::unordered_map<uint32, GearDef> defs;                                              // item entry
    std::unordered_map<ObjectGuid::LowType, std::map<std::pair<uint32, uint8>, Worn>> worn; // guid -> (skill, slot)

    char const* ProfName(uint32 skill)
    {
        for (auto const& p : PROFESSIONS)
            if (p.skill == skill)
                return p.name;
        return nullptr;
    }

    GearDef const* Def(uint32 entry)
    {
        auto itr = defs.find(entry);
        return itr == defs.end() ? nullptr : &itr->second;
    }

    bool Fits(GearDef const& def, uint32 skill, uint8 slot)
    {
        return (def.skill == 0 || def.skill == skill) && (slot == 0 ? def.kind == 0 : def.kind == 1);
    }

    int32 SkillBonusOf(ObjectGuid::LowType guid, uint32 skill)
    {
        int32 total = 0;
        for (auto const& [key, w] : worn[guid])
            if (key.first == skill)
                if (GearDef const* d = Def(w.entry))
                    total += d->skillBonus;
        return total;
    }

    void ApplySkillBonus(Player* player, uint32 skill, int32 amount)
    {
        if (amount && player->HasSkill(skill))
            player->ModifySkillBonus(skill, amount, false);
    }

    // Addon messages: a whisper to yourself in the addon language
    void SendAddon(Player* player, std::string const& text)
    {
        WorldPacket data;
        ChatHandler::BuildChatPacket(data, CHAT_MSG_WHISPER, LANG_ADDON, player, player, std::string(PREFIX) + "\t" + text);
        player->SendDirectMessage(&data);
    }

    void SendState(Player* player)
    {
        std::string profs, gear;
        for (auto const& p : PROFESSIONS)
            if (player->HasSkill(p.skill))
                profs += Acore::StringFormat("{}:{}:{};", p.skill, player->GetSkillValue(p.skill), player->GetMaxSkillValue(p.skill));
        for (auto const& [key, w] : worn[player->GetGUID().GetCounter()])
            gear += Acore::StringFormat("{}:{}:{}:{};", key.first, uint32(key.second), w.entry, w.randomProp);
        SendAddon(player, "PR " + profs);
        SendAddon(player, "ST " + gear);
    }

    Item* ItemAt(Player* player, uint8 bag, uint8 slot) { return player->GetItemByPos(bag, slot); }

    // Takes the item out of the bags into a profession slot. Returns an error, or empty on success.
    std::string Equip(Player* player, uint8 bag, uint8 slot, uint32 skill, uint8 pslot)
    {
        Item* item = ItemAt(player, bag, slot);
        if (!item || !Player::IsInventoryPos(bag, slot))
            return "That item isn't in your bags.";
        GearDef const* def = Def(item->GetEntry());
        if (!def)
            return "That isn't profession equipment.";
        if (!skill)
            skill = def->skill;
        if (!ProfName(skill) || !player->HasSkill(skill))
            return "You don't have that profession.";
        if (pslot >= SLOT_COUNT)
            pslot = def->kind == 0 ? 0 : (worn[player->GetGUID().GetCounter()].count({ skill, 1 }) ? 2 : 1);
        if (!Fits(*def, skill, pslot))
            return Acore::StringFormat("That goes in a {} slot.", def->kind == 0 ? "tool" : "accessory");
        if (ItemTemplate const* proto = item->GetTemplate(); proto->RequiredSkill && player->GetSkillValue(proto->RequiredSkill) < proto->RequiredSkillRank)
            return "Your skill is too low for it.";

        ObjectGuid::LowType guid = player->GetGUID().GetCounter();
        auto& mine = worn[guid];
        if (mine.count({ skill, pslot }))
            return "Take off what is in that slot first.";

        Worn w;
        w.entry = item->GetEntry();
        w.randomProp = item->GetItemRandomPropertyId();
        w.suffix = item->GetItemSuffixFactor();
        w.creator = item->GetGuidValue(ITEM_FIELD_CREATOR).GetCounter();
        w.enchant = item->GetEnchantmentId(PERM_ENCHANTMENT_SLOT);
        w.durability = item->GetUInt32Value(ITEM_FIELD_DURABILITY);
        w.oldGuid = item->GetGUID().GetCounter();
        player->DestroyItem(bag, slot, true);
        mine[{ skill, pslot }] = w;
        CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_profgear` (`guid`, `skill`, `slot`, `entry`, `random_prop`, `suffix`, `creator`, `enchant`, "
                                  "`durability`, `old_item`) VALUES ({}, {}, {}, {}, {}, {}, {}, {}, {}, {})", guid, skill, uint32(pslot), w.entry,
                                  w.randomProp, w.suffix, w.creator, w.enchant, w.durability, w.oldGuid);
        ApplySkillBonus(player, skill, def->skillBonus);
        return "";
    }

    std::string Unequip(Player* player, uint32 skill, uint8 pslot)
    {
        ObjectGuid::LowType guid = player->GetGUID().GetCounter();
        auto& mine = worn[guid];
        auto itr = mine.find({ skill, pslot });
        if (itr == mine.end())
            return "Nothing is in that slot.";
        Worn w = itr->second;
        ItemPosCountVec dest;
        if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, w.entry, 1) != EQUIP_ERR_OK)
            return "Your bags are full.";
        Item* item = player->StoreNewItem(dest, w.entry, true, w.randomProp);
        if (!item)
            return "Your bags are full.";
        if (w.randomProp < 0 && w.suffix)
        {
            item->SetUInt32Value(ITEM_FIELD_PROPERTY_SEED, w.suffix);
            item->SetItemRandomProperties(w.randomProp);
        }
        if (w.creator)
            item->SetGuidValue(ITEM_FIELD_CREATOR, ObjectGuid::Create<HighGuid::Player>(w.creator));
        if (w.enchant)
            item->SetEnchantment(PERM_ENCHANTMENT_SLOT, w.enchant, 0, 0);
        if (item->GetUInt32Value(ITEM_FIELD_MAXDURABILITY))
            item->SetUInt32Value(ITEM_FIELD_DURABILITY, w.durability);
        item->SetState(ITEM_CHANGED, player);
        player->SendNewItem(item, 1, true, false);
        // the crafted quality follows the item to its new guid
        CharacterDatabase.Execute("UPDATE `mod_temucraft_crafted_item` SET `item` = {} WHERE `item` = {}", item->GetGUID().GetCounter(), w.oldGuid);
        CharacterDatabase.Execute("DELETE FROM `mod_temucraft_profgear` WHERE `guid` = {} AND `skill` = {} AND `slot` = {}", guid, skill, uint32(pslot));
        if (GearDef const* def = Def(w.entry))
            ApplySkillBonus(player, skill, -def->skillBonus);
        mine.erase(itr);
        return "";
    }

    std::string ItemName(uint32 entry)
    {
        ItemTemplate const* proto = sObjectMgr->GetItemTemplate(entry);
        return proto ? proto->Name1 : "?";
    }

    // Menus (.temucraft profgear)
    void SendMain(Player* player)
    {
        ClearGossipMenuFor(player);
        for (auto const& p : PROFESSIONS)
            if (player->HasSkill(p.skill))
                AddGossipItemFor(player, GOSSIP_ICON_TRAINER, Acore::StringFormat("{} ({})", p.name, player->GetSkillValue(p.skill)), SENDER_SKILL, p.skill);
        AddGossipItemFor(player, GOSSIP_ICON_MONEY_BAG, TemucraftModuleText("mod-temucraft-professions", player, 50, "Reagent bag"), SENDER_REAGENTS, 0);
        player->PlayerTalkClass->GetGossipMenu().SetMenuId(PROFGEAR_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, player->GetGUID());
    }

    void SendSkill(Player* player, uint32 skill)
    {
        ClearGossipMenuFor(player);
        auto& mine = worn[player->GetGUID().GetCounter()];
        for (uint8 s = 0; s < SLOT_COUNT; ++s)
        {
            auto itr = mine.find({ skill, s });
            if (itr != mine.end())
                AddGossipItemFor(player, GOSSIP_ICON_INTERACT_2, Acore::StringFormat(TemucraftModuleText("mod-temucraft-professions", player, 12, "{}: {} (take off)"), SLOT_NAMES[s], ItemName(itr->second.entry)),
                                 SENDER_UNEQUIP, skill * 10 + s);
            else
                AddGossipItemFor(player, GOSSIP_ICON_INTERACT_1, Acore::StringFormat(TemucraftModuleText("mod-temucraft-professions", player, 13, "{}: empty (choose from your bags)"), SLOT_NAMES[s]), SENDER_SLOT, skill * 10 + s);
        }
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, TemucraftModuleText("mod-temucraft-professions", player, 10, "Back"), SENDER_MAIN, 0);
        player->PlayerTalkClass->GetGossipMenu().SetMenuId(PROFGEAR_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, player->GetGUID());
    }

    // What in the bags fits a slot (backpack and bags); action = bag * 256 + slot, sender carries skill/slot
    void SendSlot(Player* player, uint32 skill, uint8 pslot)
    {
        ClearGossipMenuFor(player);
        uint32 shown = 0;
        auto offer = [&](Item* item, uint8 bag, uint8 slot)
        {
            GearDef const* def = item ? Def(item->GetEntry()) : nullptr;
            if (!def || !Fits(*def, skill, pslot) || shown >= 20)
                return;
            ++shown;
            player->PlayerTalkClass->GetGossipMenu().AddMenuItem(-1, GOSSIP_ICON_VENDOR, "Wear " + ItemName(item->GetEntry()), SENDER_EQUIP,
                                                                  (skill * 10 + pslot) * 65536 + bag * 256 + slot, "", 0);
        };
        for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
            offer(player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot), INVENTORY_SLOT_BAG_0, slot);
        for (uint8 bag = INVENTORY_SLOT_BAG_START; bag < INVENTORY_SLOT_BAG_END; ++bag)
            if (Bag* container = player->GetBagByPos(bag))
                for (uint32 slot = 0; slot < container->GetBagSize(); ++slot)
                    offer(container->GetItemByPos(uint8(slot)), bag, uint8(slot));
        if (!shown)
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, TemucraftModuleText("mod-temucraft-professions", player, 14, "Nothing in your bags fits this slot."), SENDER_SKILL, skill);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, TemucraftModuleText("mod-temucraft-professions", player, 10, "Back"), SENDER_SKILL, skill);
        player->PlayerTalkClass->GetGossipMenu().SetMenuId(PROFGEAR_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, player->GetGUID());
    }

    void LoadPlayer(Player* player)
    {
        ObjectGuid::LowType guid = player->GetGUID().GetCounter();
        auto& mine = worn[guid];
        mine.clear();
        if (QueryResult r = CharacterDatabase.Query("SELECT `skill`, `slot`, `entry`, `random_prop`, `suffix`, `creator`, `enchant`, `durability`, `old_item` "
                                                    "FROM `mod_temucraft_profgear` WHERE `guid` = {}", guid))
            do
            {
                Field* f = r->Fetch();
                Worn w{ f[2].Get<uint32>(), f[3].Get<int32>(), f[4].Get<uint32>(), f[5].Get<uint32>(), f[6].Get<uint32>(), f[7].Get<uint32>(), f[8].Get<uint32>() };
                mine[{ f[0].Get<uint32>(), f[1].Get<uint8>() }] = w;
            } while (r->NextRow());
        std::map<uint32, int32> bonus;
        for (auto const& [key, w] : mine)
            if (GearDef const* d = Def(w.entry))
                bonus[key.first] += d->skillBonus;
        for (auto const& [skill, amount] : bonus)
            ApplySkillBonus(player, skill, amount);
    }
}

int32 TemucraftProfGearStat(Player* player, uint32 skill, TemucraftGearStat stat)
{
    if (!enabled || !player || stat >= GEAR_STAT_COUNT)
        return 0;
    auto itr = worn.find(player->GetGUID().GetCounter());
    if (itr == worn.end())
        return 0;
    int32 total = 0;
    for (auto const& [key, w] : itr->second)
        if (!skill || key.first == skill)
            if (GearDef const* d = Def(w.entry))
                total += d->stats[stat];
    return total;
}

class TemucraftProfGear_Player : public PlayerScript
{
public:
    TemucraftProfGear_Player() : PlayerScript("TemucraftProfGear_Player") { }

    void OnPlayerLogin(Player* player) override { if (enabled) LoadPlayer(player); }
    void OnPlayerLogout(Player* player) override { worn.erase(player->GetGUID().GetCounter()); }

    void OnPlayerDelete(ObjectGuid guid, uint32 /*accountId*/) override
    {
        CharacterDatabase.Execute("DELETE FROM `mod_temucraft_profgear` WHERE `guid` = {}", guid.GetCounter());
    }

    // The addon's messages: "TPG\t<command>" whispered to yourself in the addon language
    bool OnPlayerCanUseChat(Player* player, uint32 type, uint32 lang, std::string& msg, Player* receiver) override
    {
        if (!enabled || type != CHAT_MSG_WHISPER || lang != LANG_ADDON || receiver != player || msg.rfind("TPG\t", 0) != 0)
            return true;
        std::vector<std::string_view> args = Acore::Tokenize(std::string_view(msg).substr(4), ' ', false);
        if (TemucraftReagentBagMessage(player, args))
            return false;
        if (!args.empty() && args[0] == "GET")
        {
            std::vector<std::string_view> get = { "RG" };
            TemucraftReagentBagMessage(player, get);
        }
        std::string error;
        try
        {
        if (!args.empty() && args[0] == "EQ" && args.size() >= 4)
            error = Equip(player, uint8(std::stoul(std::string(args[1]))), uint8(std::stoul(std::string(args[2]))), 0, uint8(std::stoul(std::string(args[3]))));
        else if (!args.empty() && args[0] == "UN" && args.size() >= 3)
            error = Unequip(player, uint32(std::stoul(std::string(args[1]))), uint8(std::stoul(std::string(args[2]))));
        }
        catch (...) { error = "Bad request."; }
        if (!error.empty())
            SendAddon(player, "ER " + error);
        SendState(player);
        return false;
    }

    void OnPlayerGossipSelect(Player* player, uint32 menuId, uint32 sender, uint32 action) override
    {
        if (menuId != PROFGEAR_MENU || !enabled)
            return;
        std::string error;
        switch (sender)
        {
            case SENDER_MAIN: return SendMain(player);
            case SENDER_REAGENTS: return TemucraftReagentBagMenu(player);
            case SENDER_SKILL: return SendSkill(player, action);
            case SENDER_SLOT: return SendSlot(player, action / 10, uint8(action % 10));
            case SENDER_EQUIP:
            {
                uint32 key = action / 65536;
                error = Equip(player, uint8((action / 256) % 256), uint8(action % 256), key / 10, uint8(key % 10));
                if (!error.empty())
                    ChatHandler(player->GetSession()).SendSysMessage(error);
                return SendSkill(player, key / 10);
            }
            case SENDER_UNEQUIP:
                error = Unequip(player, action / 10, uint8(action % 10));
                if (!error.empty())
                    ChatHandler(player->GetSession()).SendSysMessage(error);
                return SendSkill(player, action / 10);
        }
    }
};

class TemucraftProfGear_World : public WorldScript
{
public:
    TemucraftProfGear_World() : WorldScript("TemucraftProfGear_World") { }

    void OnAfterConfigLoad(bool /*reload*/) override { enabled = sConfigMgr->GetOption<bool>("Temucraft.ProfGear.Enable", true); }

    void OnStartup() override
    {
        defs.clear();
        if (QueryResult r = WorldDatabase.Query("SELECT `ItemID`, `Skill`, `Kind`, `SkillBonus`, `Finesse`, `Perception`, `Deftness`, `Multicraft`, "
                                                "`Resourcefulness` FROM `mod_temucraft_profgear_item`"))
            do
            {
                Field* f = r->Fetch();
                defs[f[0].Get<uint32>()] = { f[0].Get<uint32>(), f[1].Get<uint32>(), f[2].Get<uint8>(), f[3].Get<int32>(),
                                             { f[4].Get<int32>(), f[5].Get<int32>(), f[6].Get<int32>(), f[7].Get<int32>(), f[8].Get<int32>() } };
            } while (r->NextRow());
        LOG_INFO("server.loading", ">> mod-temucraft-professions: {} kinds of profession equipment", defs.size());
    }
};

class TemucraftProfGear_Commands : public CommandScript
{
public:
    TemucraftProfGear_Commands() : CommandScript("TemucraftProfGear_Commands") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "temucraft profgear", HandleProfGear, 102751, Console::No },
        };
        return commandTable;
    }

    static bool HandleProfGear(ChatHandler* handler)
    {
        if (enabled)
            SendMain(handler->GetPlayer());
        return true;
    }
};

void AddTemucraftProfGearScripts()
{
    new TemucraftProfGear_Player();
    new TemucraftProfGear_World();
    new TemucraftProfGear_Commands();
}
