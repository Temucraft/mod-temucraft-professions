/*
 * mod-temucraft-professions: profession stats from racials (mod_temucraft_profession_racial).
 *
 * A row gives a racial spell's owner Finesse, Perception, Deftness, Multicraft or Resourcefulness for one profession
 * (Skill 0: every gathering or crafting profession). The racial spells come from mod-temucraft-classes
 * (Temucraft.Racials.BestBonuses): Cultivation (Tauren), Flayer (Worgen) and Pride of Ironhorn (Highmountain Tauren)
 * gather faster, Hyper Productive (Earthen) and One With Nature (Haranir) bring more, Discerning Eye (Dracthyr) finds
 * more rare reagents. Only spells the character knows count, so heritage and the module's switch follow by themselves.
 */

#include "TemucraftRacialStats.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Log.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "WorldScript.h"
#include <vector>

namespace
{
    struct RacialStat { uint32 spell; uint32 skill; int32 stat[GEAR_STAT_COUNT]; };
    std::vector<RacialStat> sRacialStats;
    bool sRacialEnable = true;
}

int32 TemucraftRacialProfStat(Player* player, uint32 skill, TemucraftGearStat stat)
{
    if (!sRacialEnable || !player || stat >= GEAR_STAT_COUNT)
        return 0;
    int32 total = 0;
    for (RacialStat const& r : sRacialStats)
        if ((r.skill == 0 || r.skill == skill) && r.stat[stat] && player->HasSpell(r.spell))
            total += r.stat[stat];
    return total;
}

class TemucraftRacialStats_World : public WorldScript
{
public:
    TemucraftRacialStats_World() : WorldScript("TemucraftRacialStats_World", { WORLDHOOK_ON_AFTER_CONFIG_LOAD, WORLDHOOK_ON_STARTUP }) { }

    void OnAfterConfigLoad(bool /*reload*/) override
    {
        sRacialEnable = sConfigMgr->GetOption<bool>("Temucraft.Professions.RacialStats", true);
    }

    void OnStartup() override
    {
        sRacialStats.clear();
        if (QueryResult r = WorldDatabase.Query("SELECT `SpellID`, `Skill`, `Finesse`, `Perception`, `Deftness`, `Multicraft`, "
            "`Resourcefulness` FROM `mod_temucraft_profession_racial`"))
            do
            {
                Field* f = r->Fetch();
                RacialStat s{ f[0].Get<uint32>(), f[1].Get<uint32>(), {} };
                for (uint8 i = 0; i < GEAR_STAT_COUNT; ++i)
                    s.stat[i] = f[2 + i].Get<int32>();
                sRacialStats.push_back(s);
            } while (r->NextRow());
        LOG_INFO("server.loading", ">> mod-temucraft-professions: {} racial profession stats", sRacialStats.size());
    }
};

void AddTemucraftRacialStatsScripts()
{
    new TemucraftRacialStats_World();
}
