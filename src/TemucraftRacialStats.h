// mod-temucraft-professions: profession stats from racials (mod_temucraft_profession_racial)
#ifndef TEMUCRAFT_RACIAL_STATS_H
#define TEMUCRAFT_RACIAL_STATS_H

#include "TemucraftProfGear.h"

class Player;

// Percent the racials a player knows add to a stat of a profession (Temucraft.Professions.RacialStats)
int32 TemucraftRacialProfStat(Player* player, uint32 skill, TemucraftGearStat stat);

#endif
