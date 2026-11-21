/*
 * mod-temucraft-professions: knowledge, specializations and concentration (phase 3).
 *
 * Knowledge points, per profession:
 *   - the first time you craft each recipe (+1),
 *   - the first time you gather each kind of item with a gathering skill (+1),
 *   - each 75 skill points (+3, also counted for skill you already have).
 * Spent with .temucraft knowledge (a menu) on three specializations per profession, up to Temucraft.Knowledge.Ranks ranks:
 *   gathering: Fine Touch (Finesse), Keen Eye (Perception), Swift Hands (Deftness)
 *   crafting:  Mass Production (Multicraft), Thrift (Resourcefulness), Deep Focus (cheaper concentration, bigger pool)
 * Taking the points back is free (Temucraft.Knowledge.ResetCost copper).
 *
 * Concentration: a pool per crafting profession that fills over time. Switched on in the menu, each craft spends
 * some and its Multicraft (stackable goods) and Resourcefulness rolls all succeed.
 */

#include "TemucraftKnowledge.h"

#include "TemucraftModuleText.h"
#include "Chat.h"
#include "ChatCommand.h"
#include "Config.h"
#include "DBCStores.h"
#include "DatabaseEnv.h"
#include "GameTime.h"
#include "Player.h"
#include "PlayerScript.h"
#include "ScriptMgr.h"
#include "ScriptedGossip.h"
#include "WorldScript.h"

#include <algorithm>
#include <map>
#include <set>
#include <unordered_map>

using namespace Acore::ChatCommands;

namespace
{
    constexpr uint32 KNOWLEDGE_MENU = 608300;
    constexpr uint32 MILESTONE_KEY = 0x80000000;

    enum Sender : uint32
    {
        SENDER_MAIN = 1,
        SENDER_SKILL,
        SENDER_LEARN,
        SENDER_RESET,
        SENDER_CONCENTRATE,
    };

    struct ProfessionInfo { uint32 skill; char const* name; bool gathering; };
    ProfessionInfo const PROFESSIONS[] =
    {
        { 182, "Herbalism", true }, { 186, "Mining", true }, { 393, "Skinning", true }, { 356, "Fishing", true },
        { 164, "Blacksmithing", false }, { 165, "Leatherworking", false }, { 171, "Alchemy", false },
        { 197, "Tailoring", false }, { 202, "Engineering", false }, { 333, "Enchanting", false },
        { 755, "Jewelcrafting", false }, { 773, "Inscription", false }, { 185, "Cooking", false }, { 129, "First Aid", false },
    };

    struct NodeInfo { char const* name; char const* effect; };
    NodeInfo const GATHER_NODES[3] = { { "Fine Touch", "Finesse" }, { "Keen Eye", "Perception" }, { "Swift Hands", "Deftness" } };
    NodeInfo const CRAFT_NODES[3] = { { "Mass Production", "Multicraft" }, { "Thrift", "Resourcefulness" },
                                      { "Deep Focus", "cheaper concentration, bigger pool" } };

    struct KnowledgeSettings
    {
        bool enable = true;
        uint32 ranks = 10;
        int32 perRank = 2;
        uint32 milestone = 3;
        uint32 milestoneStep = 75, milestoneMax = 450;
        uint32 resetCost = 0;
        bool announce = true;
        float concentrationMax = 1000.0f;
        float concentrationPerHour = 20.0f;
        float concentrationCost = 50.0f;
        uint32 focusPerRank = 5;          // Deep Focus: cost -%, pool +% per rank
    } kcfg;

    struct PlayerKnowledge
    {
        std::map<uint32, uint32> earned;                    // skill -> points
        std::map<std::pair<uint32, uint8>, uint32> ranks;   // (skill, node) -> rank
        std::set<std::pair<uint32, uint32>> firsts;         // (skill, key)
        std::map<uint32, std::pair<float, time_t>> concentration;   // skill -> (amount, when)
        bool concentrate = false;
    };

    std::unordered_map<ObjectGuid::LowType, PlayerKnowledge> knowledge;

    ProfessionInfo const* Profession(uint32 skill)
    {
        for (ProfessionInfo const& p : PROFESSIONS)
            if (p.skill == skill)
                return &p;
        return nullptr;
    }

    uint32 Spent(PlayerKnowledge const& k, uint32 skill)
    {
        uint32 total = 0;
        for (uint8 n = 0; n < 3; ++n)
        {
            auto itr = k.ranks.find({ skill, n });
            total += itr == k.ranks.end() ? 0 : itr->second;
        }
        return total;
    }

    uint32 Rank(PlayerKnowledge const& k, uint32 skill, uint8 node)
    {
        auto itr = k.ranks.find({ skill, node });
        return itr == k.ranks.end() ? 0 : itr->second;
    }

    float PoolMax(PlayerKnowledge const& k, uint32 skill)
    {
        return kcfg.concentrationMax * (1.0f + Rank(k, skill, 2) * kcfg.focusPerRank / 100.0f);
    }

    // The concentration pool now, filled for the time since it was last looked at
    float Concentration(PlayerKnowledge& k, uint32 skill)
    {
        time_t now = GameTime::GetGameTime().count();
        auto& [amount, when] = k.concentration.try_emplace(skill, PoolMax(k, skill), now).first->second;
        amount = std::min(PoolMax(k, skill), amount + float(now - when) / 3600.0f * kcfg.concentrationPerHour);
        when = now;
        return amount;
    }

    void Award(Player* player, uint32 skill, uint32 key, uint32 points, std::string const& why)
    {
        PlayerKnowledge& k = knowledge[player->GetGUID().GetCounter()];
        if (!k.firsts.insert({ skill, key }).second)
            return;
        k.earned[skill] += points;
        uint32 guid = player->GetGUID().GetCounter();
        CharacterDatabase.Execute("INSERT IGNORE INTO `mod_temucraft_knowledge_first` (`guid`, `skill`, `entry`) VALUES ({}, {}, {})", guid, skill, key);
        CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_knowledge` (`guid`, `skill`, `earned`) VALUES ({}, {}, {})", guid, skill, k.earned[skill]);
        if (kcfg.announce)
            if (ProfessionInfo const* p = Profession(skill))
                ChatHandler(player->GetSession()).PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", player->GetSession(), 4, "|cff66ccff[Knowledge]|r +{} {} knowledge: {}. (.temucraft knowledge)"), points, p->name, why);
    }

    void CheckMilestones(Player* player, uint32 skill, uint32 value)
    {
        if (!Profession(skill))
            return;
        for (uint32 tier = kcfg.milestoneStep; tier <= value && tier <= kcfg.milestoneMax; tier += kcfg.milestoneStep)
            Award(player, skill, MILESTONE_KEY + tier, kcfg.milestone, "reached " + std::to_string(tier) + " skill");
    }

    void Load(Player* player)
    {
        uint32 guid = player->GetGUID().GetCounter();
        PlayerKnowledge& k = knowledge[guid];
        k = PlayerKnowledge();
        if (QueryResult r = CharacterDatabase.Query("SELECT `skill`, `earned` FROM `mod_temucraft_knowledge` WHERE `guid` = {}", guid))
            do { k.earned[r->Fetch()[0].Get<uint32>()] = r->Fetch()[1].Get<uint32>(); } while (r->NextRow());
        if (QueryResult r = CharacterDatabase.Query("SELECT `skill`, `node`, `rank` FROM `mod_temucraft_knowledge_spec` WHERE `guid` = {}", guid))
            do { Field* f = r->Fetch(); k.ranks[{ f[0].Get<uint32>(), f[1].Get<uint8>() }] = f[2].Get<uint32>(); } while (r->NextRow());
        if (QueryResult r = CharacterDatabase.Query("SELECT `skill`, `entry` FROM `mod_temucraft_knowledge_first` WHERE `guid` = {}", guid))
            do { k.firsts.insert({ r->Fetch()[0].Get<uint32>(), r->Fetch()[1].Get<uint32>() }); } while (r->NextRow());
        if (QueryResult r = CharacterDatabase.Query("SELECT `skill`, `amount`, `updated`, `active` FROM `mod_temucraft_concentration` WHERE `guid` = {}", guid))
            do
            {
                Field* f = r->Fetch();
                k.concentration[f[0].Get<uint32>()] = { f[1].Get<float>(), time_t(f[2].Get<uint32>()) };
                k.concentrate = k.concentrate || f[3].Get<bool>();
            } while (r->NextRow());
        for (ProfessionInfo const& p : PROFESSIONS)
            if (uint32 value = player->GetSkillValue(p.skill))
                CheckMilestones(player, p.skill, value);
    }

    void SaveConcentration(Player* player)
    {
        auto itr = knowledge.find(player->GetGUID().GetCounter());
        if (itr == knowledge.end())
            return;
        for (auto const& [skill, pool] : itr->second.concentration)
            CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_concentration` (`guid`, `skill`, `amount`, `updated`, `active`) VALUES ({}, {}, {}, {}, {})",
                                      itr->first, skill, pool.first, uint32(pool.second), itr->second.concentrate ? 1 : 0);
    }

    // Menus
    void SendMain(Player* player)
    {
        PlayerKnowledge& k = knowledge[player->GetGUID().GetCounter()];
        ClearGossipMenuFor(player);
        AddGossipItemFor(player, GOSSIP_ICON_INTERACT_1, k.concentrate ? TemucraftModuleText("mod-temucraft-professions", player, 5, "Concentration: |cff00aa00on|r (click to switch off)"
                                                                       ) : TemucraftModuleText("mod-temucraft-professions", player, 6, "Concentration: off (click to switch on)"), SENDER_CONCENTRATE, 0);
        for (ProfessionInfo const& p : PROFESSIONS)
        {
            if (!player->GetSkillValue(p.skill))
                continue;
            uint32 earned = k.earned.count(p.skill) ? k.earned[p.skill] : 0;
            uint32 left = earned - std::min(earned, Spent(k, p.skill));
            std::string line = Acore::StringFormat("{}: {} to spend ({} earned)", p.name, left, earned);
            if (!p.gathering)
                line += Acore::StringFormat(", concentration {:.0f}/{:.0f}", Concentration(k, p.skill), PoolMax(k, p.skill));
            AddGossipItemFor(player, left ? GOSSIP_ICON_TRAINER : GOSSIP_ICON_TALK, line, SENDER_SKILL, p.skill);
        }
        player->PlayerTalkClass->GetGossipMenu().SetMenuId(KNOWLEDGE_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, player->GetGUID());
    }

    void SendSkill(Player* player, uint32 skill)
    {
        ProfessionInfo const* p = Profession(skill);
        if (!p)
            return SendMain(player);
        PlayerKnowledge& k = knowledge[player->GetGUID().GetCounter()];
        uint32 earned = k.earned.count(skill) ? k.earned[skill] : 0;
        uint32 left = earned - std::min(earned, Spent(k, skill));
        ClearGossipMenuFor(player);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, Acore::StringFormat(TemucraftModuleText("mod-temucraft-professions", player, 7, "|cff8a4b00{}: {} knowledge to spend.|r"), p->name, left), SENDER_SKILL, skill);
        NodeInfo const* nodes = p->gathering ? GATHER_NODES : CRAFT_NODES;
        for (uint8 n = 0; n < 3; ++n)
        {
            uint32 rank = Rank(k, skill, n);
            std::string bonus = p->gathering || n < 2 ? Acore::StringFormat("+{}% {}", rank * kcfg.perRank, nodes[n].effect)
                                                       : Acore::StringFormat("-{}% cost, +{}% pool", rank * kcfg.focusPerRank, rank * kcfg.focusPerRank);
            std::string line = Acore::StringFormat("{}: rank {}/{} ({})", nodes[n].name, rank, kcfg.ranks, bonus);
            if (rank < kcfg.ranks && left)
                line += " - learn a rank";
            AddGossipItemFor(player, rank < kcfg.ranks && left ? GOSSIP_ICON_TRAINER : GOSSIP_ICON_TALK, line, SENDER_LEARN, skill * 10 + n);
        }
        if (Spent(k, skill))
            AddGossipItemFor(player, GOSSIP_ICON_INTERACT_2, TemucraftModuleText("mod-temucraft-professions", player, 8, "Take back all my points"), SENDER_RESET, skill,
                             TemucraftModuleText("mod-temucraft-professions", player, 9, "Take back every point spent in " ) + std::string(p->name) + "?", kcfg.resetCost, false);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, TemucraftModuleText("mod-temucraft-professions", player, 10, "Back"), SENDER_MAIN, 0);
        player->PlayerTalkClass->GetGossipMenu().SetMenuId(KNOWLEDGE_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, player->GetGUID());
    }
}

int32 TemucraftSpecBonus(Player* player, uint32 skill, TemucraftProfessionStat stat)
{
    if (!kcfg.enable || !player)
        return 0;
    auto itr = knowledge.find(player->GetGUID().GetCounter());
    if (itr == knowledge.end())
        return 0;
    uint8 node = 0;
    switch (stat)
    {
        case PROF_STAT_FINESSE: case PROF_STAT_MULTICRAFT: node = 0; break;
        case PROF_STAT_PERCEPTION: case PROF_STAT_RESOURCEFULNESS: node = 1; break;
        case PROF_STAT_DEFTNESS: node = 2; break;
    }
    return int32(Rank(itr->second, skill, node)) * kcfg.perRank;
}

void TemucraftKnowledgeFirst(Player* player, uint32 skill, uint32 key, char const* what)
{
    if (!kcfg.enable || !player || !Profession(skill))
        return;
    Award(player, skill, key, 1, std::string("first ") + what);
}

bool TemucraftUseConcentration(Player* player, uint32 skill)
{
    if (!kcfg.enable || !player)
        return false;
    auto itr = knowledge.find(player->GetGUID().GetCounter());
    if (itr == knowledge.end() || !itr->second.concentrate)
        return false;
    PlayerKnowledge& k = itr->second;
    float cost = kcfg.concentrationCost * (1.0f - std::min<uint32>(Rank(k, skill, 2) * kcfg.focusPerRank, 90) / 100.0f);
    float& amount = k.concentration[skill].first;
    if (Concentration(k, skill) < cost)
    {
        ChatHandler(player->GetSession()).PSendSysMessage(TemucraftModuleText("mod-temucraft-professions", player->GetSession(), 11, "|cff66ccff[Concentration]|r Not enough concentration ({:.0f}, need {:.0f})."), amount, cost);
        return false;
    }
    amount -= cost;
    return true;
}

class TemucraftKnowledge_Player : public PlayerScript
{
public:
    TemucraftKnowledge_Player() : PlayerScript("TemucraftKnowledge_Player") { }

    void OnPlayerLogin(Player* player) override { if (kcfg.enable) Load(player); }

    void OnPlayerLogout(Player* player) override
    {
        SaveConcentration(player);
        knowledge.erase(player->GetGUID().GetCounter());
    }

    void OnPlayerSave(Player* player) override { SaveConcentration(player); }

    void OnPlayerUpdateSkill(Player* player, uint32 skillId, uint32 /*value*/, uint32 /*max*/, uint32 /*step*/, uint32 newValue) override
    {
        if (kcfg.enable)
            CheckMilestones(player, skillId, newValue);
    }

    void OnPlayerDelete(ObjectGuid guid, uint32 /*accountId*/) override
    {
        uint32 low = guid.GetCounter();
        for (char const* table : { "mod_temucraft_knowledge", "mod_temucraft_knowledge_first", "mod_temucraft_knowledge_spec", "mod_temucraft_concentration" })
            CharacterDatabase.Execute("DELETE FROM `{}` WHERE `guid` = {}", table, low);
    }

    void OnPlayerGossipSelect(Player* player, uint32 menuId, uint32 sender, uint32 action) override
    {
        if (menuId != KNOWLEDGE_MENU || !kcfg.enable)
            return;
        PlayerKnowledge& k = knowledge[player->GetGUID().GetCounter()];
        uint32 guid = player->GetGUID().GetCounter();
        switch (sender)
        {
            case SENDER_MAIN:
                return SendMain(player);
            case SENDER_SKILL:
                return SendSkill(player, action);
            case SENDER_LEARN:
            {
                uint32 skill = action / 10;
                uint8 node = uint8(action % 10);
                uint32 earned = k.earned.count(skill) ? k.earned[skill] : 0;
                if (node < 3 && Profession(skill) && Rank(k, skill, node) < kcfg.ranks && Spent(k, skill) < earned)
                {
                    uint32 rank = ++k.ranks[{ skill, node }];
                    CharacterDatabase.Execute("REPLACE INTO `mod_temucraft_knowledge_spec` (`guid`, `skill`, `node`, `rank`) VALUES ({}, {}, {}, {})",
                                              guid, skill, node, rank);
                }
                return SendSkill(player, skill);
            }
            case SENDER_RESET:
                if (kcfg.resetCost && !player->HasEnoughMoney(kcfg.resetCost))
                    return SendSkill(player, action);
                if (kcfg.resetCost)
                    player->ModifyMoney(-int32(kcfg.resetCost));
                for (uint8 n = 0; n < 3; ++n)
                    k.ranks.erase({ action, n });
                CharacterDatabase.Execute("DELETE FROM `mod_temucraft_knowledge_spec` WHERE `guid` = {} AND `skill` = {}", guid, action);
                return SendSkill(player, action);
            case SENDER_CONCENTRATE:
                k.concentrate = !k.concentrate;
                SaveConcentration(player);
                return SendMain(player);
        }
    }
};

class TemucraftKnowledge_World : public WorldScript
{
public:
    TemucraftKnowledge_World() : WorldScript("TemucraftKnowledge_World") { }

    void OnAfterConfigLoad(bool /*reload*/) override
    {
        kcfg.enable = sConfigMgr->GetOption<bool>("Temucraft.Knowledge.Enable", true);
        kcfg.ranks = sConfigMgr->GetOption<uint32>("Temucraft.Knowledge.Ranks", 10);
        kcfg.perRank = sConfigMgr->GetOption<int32>("Temucraft.Knowledge.PercentPerRank", 2);
        kcfg.milestone = sConfigMgr->GetOption<uint32>("Temucraft.Knowledge.SkillMilestonePoints", 3);
        kcfg.milestoneStep = std::max<uint32>(1, sConfigMgr->GetOption<uint32>("Temucraft.Knowledge.SkillMilestoneStep", 75));
        kcfg.milestoneMax = sConfigMgr->GetOption<uint32>("Temucraft.Knowledge.SkillMilestoneMax", 450);
        kcfg.resetCost = sConfigMgr->GetOption<uint32>("Temucraft.Knowledge.ResetCost", 0);
        kcfg.announce = sConfigMgr->GetOption<bool>("Temucraft.Knowledge.Announce", true);
        kcfg.concentrationMax = sConfigMgr->GetOption<float>("Temucraft.Concentration.Max", 1000.0f);
        kcfg.concentrationPerHour = sConfigMgr->GetOption<float>("Temucraft.Concentration.PerHour", 20.0f);
        kcfg.concentrationCost = sConfigMgr->GetOption<float>("Temucraft.Concentration.CostPerCraft", 50.0f);
        kcfg.focusPerRank = sConfigMgr->GetOption<uint32>("Temucraft.Concentration.DeepFocusPercentPerRank", 5);
    }
};

class TemucraftKnowledge_Commands : public CommandScript
{
public:
    TemucraftKnowledge_Commands() : CommandScript("TemucraftKnowledge_Commands") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "temucraft knowledge", HandleKnowledge, 102750, Console::No },
        };
        return commandTable;
    }

    static bool HandleKnowledge(ChatHandler* handler)
    {
        if (kcfg.enable)
            SendMain(handler->GetPlayer());
        return true;
    }
};

void AddTemucraftKnowledgeScripts()
{
    new TemucraftKnowledge_Player();
    new TemucraftKnowledge_World();
    new TemucraftKnowledge_Commands();
}
