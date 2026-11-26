-- mod-temucraft-professions: profession stats from racials. A character who knows the spell gets the stats (percent)
-- for the profession (Skill 0: every gathering or crafting profession). The spells are mod-temucraft-classes' best
-- racial bonuses (Temucraft.Racials.BestBonuses); Temucraft.Professions.RacialStats = 0 turns the table off.
-- Re-runnable.
CREATE TABLE IF NOT EXISTS `mod_temucraft_profession_racial` (
  `SpellID` int unsigned NOT NULL,
  `Skill` int unsigned NOT NULL DEFAULT '0' COMMENT '0 = every profession',
  `Finesse` int NOT NULL DEFAULT '0',
  `Perception` int NOT NULL DEFAULT '0',
  `Deftness` int NOT NULL DEFAULT '0',
  `Multicraft` int NOT NULL DEFAULT '0',
  `Resourcefulness` int NOT NULL DEFAULT '0',
  `Comment` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`SpellID`, `Skill`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='mod-temucraft-professions: profession stats from racials';

DELETE FROM `mod_temucraft_profession_racial` WHERE `SpellID` IN (20552, 68978, 81109, 95823, 95827, 95829);
INSERT INTO `mod_temucraft_profession_racial` (`SpellID`, `Skill`, `Finesse`, `Perception`, `Deftness`, `Multicraft`, `Resourcefulness`, `Comment`) VALUES
(20552, 182, 0, 0, 25, 0, 0, 'Cultivation (Tauren): gather herbs faster'),
(68978, 393, 0, 0, 25, 0, 0, 'Flayer (Worgen): skin faster'),
(81109, 186, 0, 0, 25, 0, 0, 'Pride of Ironhorn (Highmountain Tauren): mine faster'),
(95823, 0, 25, 0, 0, 0, 0, 'Hyper Productive (Earthen): more bonus materials'),
(95827, 182, 10, 0, 0, 0, 0, 'One With Nature (Haranir): more herbs'),
(95829, 0, 0, 2, 0, 0, 0, 'Discerning Eye (Dracthyr): more rare reagents');
