-- mod-temucraft-professions: profession equipment each character wears (the item is kept here while worn)
CREATE TABLE IF NOT EXISTS `mod_temucraft_profgear` (
  `guid` int unsigned NOT NULL COMMENT 'characters.guid', `skill` smallint unsigned NOT NULL, `slot` tinyint unsigned NOT NULL COMMENT '0 tool, 1-2 accessories',
  `entry` int unsigned NOT NULL, `random_prop` int NOT NULL DEFAULT 0, `suffix` int unsigned NOT NULL DEFAULT 0, `creator` int unsigned NOT NULL DEFAULT 0,
  `enchant` int unsigned NOT NULL DEFAULT 0, `durability` int unsigned NOT NULL DEFAULT 0, `old_item` int unsigned NOT NULL DEFAULT 0 COMMENT 'item guid before it was worn',
  PRIMARY KEY (`guid`, `skill`, `slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: profession equipment worn';

-- the reagent bag: what each character keeps in it, and whether loot and crafts go there by themselves
CREATE TABLE IF NOT EXISTS `mod_temucraft_reagent_bag` (
  `guid` INT UNSIGNED NOT NULL,
  `item` INT UNSIGNED NOT NULL,
  `count` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`guid`, `item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `mod_temucraft_character_setting` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
  `setting` VARCHAR(32) NOT NULL COMMENT 'which choice (auras, autolearn, reagents, reagentbag, hearthstone, tankmode, shopmaxlevel)',
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`, `setting`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Temucraft: small per-character choices of many modules (one row per choice)';
-- rows from the old `mod_temucraft_reagent_bag_settings` table, if this server still has it, then it goes
SET @old := (SELECT COUNT(*) FROM information_schema.TABLES WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_temucraft_reagent_bag_settings');
SET @sql := IF(@old > 0, 'INSERT IGNORE INTO `mod_temucraft_character_setting` (`guid`, `setting`, `value`) SELECT `guid`, ''reagentbag'', `auto` FROM `mod_temucraft_reagent_bag_settings`', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
DROP TABLE IF EXISTS `mod_temucraft_reagent_bag_settings`;
