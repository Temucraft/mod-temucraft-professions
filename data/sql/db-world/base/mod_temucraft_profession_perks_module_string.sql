-- mod-temucraft-profession-perks: player-facing texts. Translations go in module_string_locale (same module and id, plus the locale).
DELETE FROM `module_string` WHERE `module` = 'mod-temucraft-profession-perks';
INSERT INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-temucraft-profession-perks', 1, 'Repair All needs Blacksmithing {}.'),
('mod-temucraft-profession-perks', 2, 'Repair All is ready again in {} h {} min.'),
('mod-temucraft-profession-perks', 3, '|cffe6cc80Repair All:|r your gear is mended.'),
('mod-temucraft-profession-perks', 4, 'Repair All isn''t available on this server.');
