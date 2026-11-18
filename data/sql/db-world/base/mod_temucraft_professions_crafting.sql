-- mod-temucraft-professions: crafting stats (Multicraft, Resourcefulness) from tools. Re-runnable.
-- Skill: 164 Blacksmithing, 165 Leatherworking, 171 Alchemy, 197 Tailoring, 202 Engineering, 333 Enchanting,
-- 755 Jewelcrafting, 773 Inscription, 185 Cooking, 129 First Aid, 0 = all crafting. Values are percent.
CREATE TABLE IF NOT EXISTS `mod_temucraft_crafting_tool` (
  `ItemID` int unsigned NOT NULL, `Skill` smallint unsigned NOT NULL DEFAULT 0,
  `Multicraft` tinyint NOT NULL DEFAULT 0, `Resourcefulness` tinyint NOT NULL DEFAULT 0,
  `Comment` varchar(100) NOT NULL DEFAULT '', PRIMARY KEY (`ItemID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELETE FROM `mod_temucraft_crafting_tool`;
INSERT INTO `mod_temucraft_crafting_tool` (`ItemID`, `Skill`, `Multicraft`, `Resourcefulness`, `Comment`) VALUES
(5956,   164, 0,  5,  'Blacksmith Hammer'),
(40772,  0,   0,  5,  'Gnomish Army Knife (all crafting)'),
(40892,  164, 0,  5,  'Hammer Pick'),
(40893,  164, 0,  5,  'Bladed Pickaxe'),
(6219,   202, 0,  5,  'Arclight Spanner'),
(10498,  202, 5,  5,  'Gyromatic Micro-Adjustor'),
(9149,   171, 10, 5,  'Philosopher''s Stone'),
(13503,  171, 15, 10, 'Alchemist''s Stone'),
(20815,  755, 5,  5,  'Jeweler''s Kit'),
(39505,  773, 5,  5,  'Virtuoso Inking Set'),
(6218,   333, 0,  2,  'Runed Copper Rod'),
(6339,   333, 0,  3,  'Runed Silver Rod'),
(11130,  333, 0,  4,  'Runed Golden Rod'),
(11145,  333, 0,  5,  'Runed Truesilver Rod'),
(16207,  333, 5,  6,  'Runed Arcanite Rod'),
(22461,  333, 5,  7,  'Runed Fel Iron Rod'),
(22462,  333, 5,  8,  'Runed Adamantite Rod'),
(22463,  333, 10, 9,  'Runed Eternium Rod'),
(44452,  333, 10, 10, 'Runed Titanium Rod'),
(608103, 197, 5,  10, 'Tailor''s Needle Set'),
(608104, 165, 5,  10, 'Leatherworker''s Awl'),
(608105, 185, 10, 5,  'Chef''s Spice Pouch');

-- three new tools for the crafts that had none, sold wherever Coarse Thread is (trade supplies)
DELETE FROM `item_template` WHERE `entry` IN (608103, 608104, 608105);
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `ItemLevel`, `RequiredSkill`, `RequiredSkillRank`, `maxcount`, `stackable`, `bonding`, `description`, `Material`, `VerifiedBuild`) VALUES
(608103, 15, 0, -1, 'Tailor''s Needle Set', 25048, 2, 1, 5000, 1250, 0, 20, 197, 1, 1, 1, 0, 'Carry it while tailoring: Multicraft +5%, Resourcefulness +10%.', 7, 0),
(608104, 15, 0, -1, 'Leatherworker''s Awl', 6440, 2, 1, 5000, 1250, 0, 20, 165, 1, 1, 1, 0, 'Carry it while leatherworking: Multicraft +5%, Resourcefulness +10%.', 1, 0),
(608105, 15, 0, -1, 'Chef''s Spice Pouch', 1443, 2, 1, 2500, 625, 0, 10, 185, 1, 1, 1, 0, 'Carry it while cooking: Multicraft +10%, Resourcefulness +5%.', 8, 0);
DELETE FROM `npc_vendor` WHERE `item` IN (608103, 608104, 608105);
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT DISTINCT `entry`, 0, i.`item`, 0, 0, 0, 0 FROM `npc_vendor` v JOIN (SELECT 608103 AS `item` UNION SELECT 608104 UNION SELECT 608105) i
WHERE v.`item` = 2320;
