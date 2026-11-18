-- mod-temucraft-professions: knowledge, specializations and concentration per character
CREATE TABLE IF NOT EXISTS `mod_temucraft_knowledge` (
  `guid` int unsigned NOT NULL, `skill` smallint unsigned NOT NULL, `earned` int unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`, `skill`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: knowledge earned per profession';
CREATE TABLE IF NOT EXISTS `mod_temucraft_knowledge_first` (
  `guid` int unsigned NOT NULL, `skill` smallint unsigned NOT NULL, `entry` int unsigned NOT NULL COMMENT 'item gathered, recipe spell, or 0x80000000 + skill milestone',
  PRIMARY KEY (`guid`, `skill`, `entry`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: firsts that gave knowledge';
CREATE TABLE IF NOT EXISTS `mod_temucraft_knowledge_spec` (
  `guid` int unsigned NOT NULL, `skill` smallint unsigned NOT NULL, `node` tinyint unsigned NOT NULL, `rank` tinyint unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`, `skill`, `node`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: specialization ranks';
CREATE TABLE IF NOT EXISTS `mod_temucraft_concentration` (
  `guid` int unsigned NOT NULL, `skill` smallint unsigned NOT NULL, `amount` float NOT NULL DEFAULT 0,
  `updated` int unsigned NOT NULL DEFAULT 0, `active` tinyint unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`, `skill`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: concentration pools';
