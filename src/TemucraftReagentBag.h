// mod-temucraft-professions: the reagent bag (server-kept storage shown in the profession equipment window)
#ifndef TEMUCRAFT_REAGENTBAG_H
#define TEMUCRAFT_REAGENTBAG_H

#include <string_view>
#include <vector>

class Player;

// handles an addon command starting with R (RG, RT, RW, RD, RA, RP); false when it isn't one
bool TemucraftReagentBagMessage(Player* player, std::vector<std::string_view> const& args);
// the gossip pages (from .temucraft profgear)
void TemucraftReagentBagMenu(Player* player);

#endif
