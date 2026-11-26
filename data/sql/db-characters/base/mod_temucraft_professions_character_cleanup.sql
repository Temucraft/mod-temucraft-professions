-- mod-temucraft-professions (2026-11-26): one-off cleanup of rows left by characters deleted before the character-delete hook
-- existed (rows whose character is no longer in `characters`). Re-runnable and strict-mode safe: a table that
-- isn't there (yet) is skipped. A character only unlinked (CharDelete.Method = 1) is still in `characters` and keeps
-- its rows, as with the hook.
SET @t := (SELECT COUNT(*) FROM information_schema.TABLES WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_temucraft_profession_slots');
SET @sql := IF(@t > 0, 'DELETE x FROM `mod_temucraft_profession_slots` x LEFT JOIN `characters` c ON c.`guid` = x.`guid` WHERE c.`guid` IS NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @t := (SELECT COUNT(*) FROM information_schema.TABLES WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_temucraft_character_setting');
SET @sql := IF(@t > 0, 'DELETE x FROM `mod_temucraft_character_setting` x LEFT JOIN `characters` c ON c.`guid` = x.`guid` WHERE c.`guid` IS NULL AND x.`setting` IN (''reagentbag'', ''reagentbagnotice'', ''reagenttabs'')', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
