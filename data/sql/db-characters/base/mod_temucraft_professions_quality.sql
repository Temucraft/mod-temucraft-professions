-- mod-temucraft-professions: quality rank of crafted gear (for recrafting)
CREATE TABLE IF NOT EXISTS `mod_temucraft_crafted_item` (
  `item` int unsigned NOT NULL COMMENT 'item_instance.guid', `rank` tinyint unsigned NOT NULL DEFAULT 1,
  `recipe` int unsigned NOT NULL DEFAULT 0 COMMENT 'spell that crafted it', `crafter` int unsigned NOT NULL DEFAULT 0 COMMENT 'characters.guid',
  PRIMARY KEY (`item`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: crafted quality ranks';
