// mod-temucraft-professions: crafted quality ranks and recrafting (phase 3)
#ifndef TEMUCRAFT_QUALITY_H
#define TEMUCRAFT_QUALITY_H

class Item;
class Player;
class SpellInfo;
struct SkillLineAbilityEntry;

// Rolls the quality rank of a crafted piece of gear and makes its random enchantment as strong as the rank allows
void TemucraftCraftQuality(Player* player, Item* item, SpellInfo const* recipe, SkillLineAbilityEntry const* ability, bool concentrated);

#endif
