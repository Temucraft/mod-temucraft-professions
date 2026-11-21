-- mod-temucraft-professions: extra primary profession slots each character has unlocked (on top of
-- Temucraft.ProfessionSlots.Base). Total is capped by MaxPrimaryTradeSkill in worldserver.conf.
CREATE TABLE IF NOT EXISTS `mod_temucraft_profession_slots` (
  `guid` INT UNSIGNED NOT NULL,
  `unlocked` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Temucraft profession slots';
