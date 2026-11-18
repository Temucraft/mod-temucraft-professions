-- mod-temucraft-professions: player-facing texts. Translations go in module_string_locale (same module and id, plus the locale).
DELETE FROM `module_string` WHERE `module` = 'mod-temucraft-professions';
INSERT INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-temucraft-professions', 1, '|cff66ccff[Concentration]|r Spent on this craft.'),
('mod-temucraft-professions', 2, '|cff66ccff[Multicraft]|r You made {} more {}.'),
('mod-temucraft-professions', 3, '|cff66ccff[Resourcefulness]|r You saved {}.'),
('mod-temucraft-professions', 4, '|cff66ccff[Knowledge]|r +{} {} knowledge: {}. (.knowledge)'),
('mod-temucraft-professions', 5, 'Concentration: |cff00aa00on|r (click to switch off)'),
('mod-temucraft-professions', 6, 'Concentration: off (click to switch on)'),
('mod-temucraft-professions', 7, '|cff8a4b00{}: {} knowledge to spend.|r'),
('mod-temucraft-professions', 8, 'Take back all my points'),
('mod-temucraft-professions', 9, 'Take back every point spent in '),
('mod-temucraft-professions', 10, 'Back'),
('mod-temucraft-professions', 11, '|cff66ccff[Concentration]|r Not enough concentration ({:.0f}, need {:.0f}).'),
('mod-temucraft-professions', 12, '{}: {} (take off)'),
('mod-temucraft-professions', 13, '{}: empty (choose from your bags)'),
('mod-temucraft-professions', 14, 'Nothing in your bags fits this slot.'),
('mod-temucraft-professions', 15, '|cff66ccff[Quality]|r {} crafted at quality {}{}.'),
('mod-temucraft-professions', 16, 'Recraft needs a piece you crafted yourself, in your bags or equipped: .recraft <shift-click the item>'),
('mod-temucraft-professions', 17, 'You need to know the recipe to recraft it.'),
('mod-temucraft-professions', 18, 'Recrafting needs {} {}.'),
('mod-temucraft-professions', 19, '|cff66ccff[Quality]|r {} recrafted: quality {} (was {}).');
