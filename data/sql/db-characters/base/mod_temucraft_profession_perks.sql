-- mod-temucraft-profession-perks: when each character last used Repair All (unix time).
CREATE TABLE IF NOT EXISTS `mod_temucraft_profession_perks` (
    `guid`     INT UNSIGNED NOT NULL,
    `repaired` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
