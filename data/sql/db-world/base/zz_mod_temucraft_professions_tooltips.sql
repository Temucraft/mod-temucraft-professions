-- mod-temucraft-professions: how to use profession tools and equipment, in their tooltips.
-- Runs after the other files of this module (name starts with zz_), so the tool and equipment tables are filled.
-- Re-runnable: a line is only added where it isn't yet. Players see it after the game's item cache is cleared.

-- profession equipment (the Professions tab slots)
UPDATE `item_template` SET `description` = LEFT(TRIM(CONCAT(`description`, ' |cff00ff00Changed:|r Profession equipment: alt-right-click it in your bags to wear it in the Professions tab of the character window.')), 255)
WHERE `entry` IN (SELECT `ItemID` FROM `mod_temucraft_profgear_item`) AND `description` NOT LIKE '%Professions tab%';

-- tools that give their stats while they are in your bags
UPDATE `item_template` SET `description` = LEFT(TRIM(CONCAT(`description`, ' |cff00ff00Changed:|r Profession tool: works while it is in your bags. Its stats show in the Professions tab of the character window.')), 255)
WHERE (`entry` IN (SELECT `ItemID` FROM `mod_temucraft_gathering_tool`) OR `entry` IN (SELECT `ItemID` FROM `mod_temucraft_crafting_tool`))
  AND `entry` NOT IN (SELECT `ItemID` FROM `mod_temucraft_profgear_item`) AND `description` NOT LIKE '%Professions tab%';
