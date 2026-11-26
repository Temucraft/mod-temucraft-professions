// mod-temucraft-professions: script loader (was: mod-temucraft-professions, mod-temucraft-profession-perks)
void AddTemucraftGatheringScripts();
void AddTemucraftCraftingScripts();
void AddTemucraftKnowledgeScripts();
void AddTemucraftQualityScripts();
void AddTemucraftProfGearScripts();
void AddTemucraftReagentBagScripts();
void AddTemucraftProfessionPerksScripts();
void AddTemucraftTreasuresScripts();
void AddTemucraftProfessionSlotsScripts();
void AddTemucraftRacialStatsScripts();

void Addmod_temucraft_professionsScripts()
{
    AddTemucraftGatheringScripts();
    AddTemucraftCraftingScripts();
    AddTemucraftKnowledgeScripts();
    AddTemucraftQualityScripts();
    AddTemucraftProfGearScripts();
    AddTemucraftReagentBagScripts();
    AddTemucraftProfessionPerksScripts();
    AddTemucraftProfessionSlotsScripts();   // 2 primary professions, more unlocked by spell up to MaxPrimaryTradeSkill
    AddTemucraftRacialStatsScripts();   // profession stats from racials (mod_temucraft_profession_racial)
    AddTemucraftTreasuresScripts();   // instant chests, minimap and sparkle for herbs/ore/treasure, dwarves
}
