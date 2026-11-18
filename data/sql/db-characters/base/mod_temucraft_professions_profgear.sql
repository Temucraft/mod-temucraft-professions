-- mod-temucraft-professions: profession equipment each character wears (the item is kept here while worn)
CREATE TABLE IF NOT EXISTS `mod_temucraft_profgear` (
  `guid` int unsigned NOT NULL COMMENT 'characters.guid', `skill` smallint unsigned NOT NULL, `slot` tinyint unsigned NOT NULL COMMENT '0 tool, 1-2 accessories',
  `entry` int unsigned NOT NULL, `random_prop` int NOT NULL DEFAULT 0, `suffix` int unsigned NOT NULL DEFAULT 0, `creator` int unsigned NOT NULL DEFAULT 0,
  `enchant` int unsigned NOT NULL DEFAULT 0, `durability` int unsigned NOT NULL DEFAULT 0, `old_item` int unsigned NOT NULL DEFAULT 0 COMMENT 'item guid before it was worn',
  PRIMARY KEY (`guid`, `skill`, `slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: profession equipment worn';
