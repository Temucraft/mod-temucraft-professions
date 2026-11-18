// mod-temucraft-professions: knowledge, specializations and concentration (phase 3)
#ifndef TEMUCRAFT_KNOWLEDGE_H
#define TEMUCRAFT_KNOWLEDGE_H

#include "Define.h"

class Player;

enum TemucraftProfessionStat : uint8
{
    PROF_STAT_FINESSE = 0,
    PROF_STAT_PERCEPTION,
    PROF_STAT_DEFTNESS,
    PROF_STAT_MULTICRAFT,
    PROF_STAT_RESOURCEFULNESS,
};

// Percent a player's specializations add to a stat of a profession
int32 TemucraftSpecBonus(Player* player, uint32 skill, TemucraftProfessionStat stat);
// Knowledge for doing something the first time (key: the item gathered, or the recipe's spell)
void TemucraftKnowledgeFirst(Player* player, uint32 skill, uint32 key, char const* what);
// With concentration switched on and enough of it, spends it and returns true: the craft's procs are guaranteed
bool TemucraftUseConcentration(Player* player, uint32 skill);

#endif
