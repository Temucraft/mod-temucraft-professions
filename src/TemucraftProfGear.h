// mod-temucraft-professions: profession equipment (a tool and two accessories per profession, kept by the server)
#ifndef TEMUCRAFT_PROFGEAR_H
#define TEMUCRAFT_PROFGEAR_H

#include "Define.h"

class Player;

enum TemucraftGearStat : uint8 { GEAR_FINESSE = 0, GEAR_PERCEPTION, GEAR_DEFTNESS, GEAR_MULTICRAFT, GEAR_RESOURCEFULNESS, GEAR_STAT_COUNT };

// Percent the profession equipment a player wears for this skill adds to a stat
int32 TemucraftProfGearStat(Player* player, uint32 skill, TemucraftGearStat stat);

#endif
