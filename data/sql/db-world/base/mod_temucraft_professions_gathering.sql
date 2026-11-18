-- mod-temucraft-professions: gathering stats from tools. Re-runnable.
-- Skill: 182 Herbalism, 186 Mining, 393 Skinning, 356 Fishing, 0 = all gathering. Values are percent.
CREATE TABLE IF NOT EXISTS `mod_temucraft_gathering_tool` (
  `ItemID` int unsigned NOT NULL, `Skill` smallint unsigned NOT NULL DEFAULT 0,
  `Finesse` tinyint NOT NULL DEFAULT 0, `Perception` tinyint NOT NULL DEFAULT 0, `Deftness` tinyint NOT NULL DEFAULT 0,
  `Comment` varchar(100) NOT NULL DEFAULT '', PRIMARY KEY (`ItemID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELETE FROM `mod_temucraft_gathering_tool`;
INSERT INTO `mod_temucraft_gathering_tool` (`ItemID`, `Skill`, `Finesse`, `Perception`, `Deftness`, `Comment`) VALUES
(2901,   186, 5,  0,  0,  'Mining Pick'),
(7005,   393, 5,  0,  0,  'Skinning Knife'),
(40772,  0,   5,  0,  10, 'Gnomish Army Knife'),
(15138,  393, 10, 5,  10, 'Finkle''s Skinner'),
(19901,  393, 10, 5,  10, 'Zulian Slicer'),
(6365,   356, 5,  0,  0,  'Strong Fishing Pole'),
(6367,   356, 10, 0,  0,  'Big Iron Fishing Pole'),
(19022,  356, 10, 5,  0,  'Nat Pagle''s Extreme Angler FC-5000'),
(19970,  356, 15, 5,  0,  'Arcanite Fishing Pole'),
(25978,  356, 10, 5,  0,  'Seth''s Graphite Fishing Pole'),
(44050,  356, 15, 10, 0,  'Mastercraft Kalu''ak Fishing Pole'),
(45991,  356, 15, 5,  0,  'Bone Fishing Pole'),
(45992,  356, 15, 5,  0,  'Jeweled Fishing Pole'),
(608100, 182, 5,  0,  10, 'Herbalist''s Sickle'),
(608101, 186, 10, 5,  10, 'Prospector''s Pick'),
(608102, 393, 10, 5,  10, 'Keen Skinning Knife');

-- rare reagents found with Perception, by skill and node level (skinning and fishing: your skill)
CREATE TABLE IF NOT EXISTS `mod_temucraft_gathering_rare` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT, `Skill` smallint unsigned NOT NULL, `MinNode` smallint unsigned NOT NULL DEFAULT 0,
  `MaxNode` smallint unsigned NOT NULL DEFAULT 450, `ItemID` int unsigned NOT NULL, `Weight` int unsigned NOT NULL DEFAULT 10,
  `Comment` varchar(100) NOT NULL DEFAULT '', PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELETE FROM `mod_temucraft_gathering_rare`;
INSERT INTO `mod_temucraft_gathering_rare` (`Skill`, `MinNode`, `MaxNode`, `ItemID`, `Weight`, `Comment`) VALUES
(186, 0, 74, 818, 10, 'Tigerseye'), (186, 0, 74, 774, 10, 'Malachite'), (186, 0, 74, 1210, 6, 'Shadowgem'),
(186, 65, 174, 1206, 10, 'Moss Agate'), (186, 65, 174, 1705, 8, 'Lesser Moonstone'), (186, 65, 174, 1529, 6, 'Jade'),
(186, 155, 249, 3864, 10, 'Citrine'), (186, 155, 249, 7909, 8, 'Aquamarine'), (186, 155, 249, 7910, 6, 'Star Ruby'),
(186, 230, 324, 12799, 8, 'Large Opal'), (186, 230, 324, 12800, 6, 'Azerothian Diamond'), (186, 230, 324, 12361, 8, 'Blue Sapphire'),
(186, 230, 324, 12364, 6, 'Huge Emerald'), (186, 230, 324, 12363, 3, 'Arcane Crystal'),
(186, 275, 374, 23077, 10, 'Blood Garnet'), (186, 275, 374, 23112, 10, 'Golden Draenite'), (186, 275, 374, 23079, 10, 'Deep Peridot'),
(186, 275, 374, 23117, 10, 'Azure Moonstone'), (186, 275, 374, 23107, 10, 'Shadow Draenite'), (186, 275, 374, 21929, 10, 'Flame Spessarite'),
(186, 300, 374, 23436, 2, 'Living Ruby'), (186, 300, 374, 23439, 2, 'Noble Topaz'), (186, 300, 374, 23440, 2, 'Dawnstone'),
(186, 300, 374, 23438, 2, 'Star of Elune'), (186, 300, 374, 23437, 2, 'Talasite'), (186, 300, 374, 23441, 2, 'Nightseye'),
(186, 350, 450, 36917, 10, 'Bloodstone'), (186, 350, 450, 36923, 10, 'Chalcedony'), (186, 350, 450, 36926, 10, 'Shadow Crystal'),
(186, 350, 450, 36932, 10, 'Dark Jade'), (186, 350, 450, 36929, 10, 'Huge Citrine'), (186, 350, 450, 36920, 10, 'Sun Crystal'),
(186, 400, 450, 36918, 2, 'Scarlet Ruby'), (186, 400, 450, 36921, 2, 'Autumn''s Glow'), (186, 400, 450, 36924, 2, 'Sky Sapphire'),
(186, 400, 450, 36927, 2, 'Twilight Opal'), (186, 400, 450, 36930, 2, 'Monarch Topaz'), (186, 400, 450, 36933, 2, 'Forest Emerald'),
(182, 0, 299, 8153, 10, 'Wildvine'), (182, 285, 300, 13468, 1, 'Black Lotus'),
(182, 300, 374, 22794, 5, 'Fel Lotus'), (182, 350, 450, 36908, 5, 'Frost Lotus'),
(393, 1, 124, 2319, 10, 'Medium Leather'), (393, 125, 249, 4304, 10, 'Thick Leather'), (393, 150, 249, 8167, 6, 'Turtle Scale'),
(393, 250, 299, 8171, 8, 'Rugged Hide'), (393, 250, 300, 15417, 1, 'Devilsaur Leather'),
(393, 300, 374, 25700, 10, 'Fel Scales'), (393, 300, 374, 29539, 6, 'Cobra Scales'), (393, 300, 374, 29548, 6, 'Nether Dragonscales'),
(393, 375, 450, 44128, 6, 'Arctic Fur'), (393, 375, 450, 38557, 6, 'Icy Dragonscale'), (393, 375, 450, 38558, 6, 'Nerubian Chitin');

-- three new tools, sold wherever Mining Picks are sold
DELETE FROM `item_template` WHERE `entry` IN (608100, 608101, 608102);
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `ItemLevel`, `RequiredSkill`, `RequiredSkillRank`, `maxcount`, `stackable`, `bonding`, `description`, `Material`, `VerifiedBuild`) VALUES
(608100, 15, 0, -1, 'Herbalist''s Sickle', 7393, 2, 1, 2500, 625, 0, 10, 182, 1, 1, 1, 0, 'Carry it while gathering herbs: Finesse +5%, Deftness +10%.', 1, 0),
(608101, 15, 0, -1, 'Prospector''s Pick', 6795, 2, 1, 5000, 1250, 0, 20, 186, 1, 1, 1, 0, 'Carry it while mining: Finesse +10%, Perception +5%, Deftness +10%.', 1, 0),
(608102, 15, 0, -1, 'Keen Skinning Knife', 6623, 2, 1, 5000, 1250, 0, 20, 393, 1, 1, 1, 0, 'Carry it while skinning: Finesse +10%, Perception +5%, Deftness +10%.', 1, 0);
DELETE FROM `npc_vendor` WHERE `item` IN (608100, 608101, 608102);
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT DISTINCT `entry`, 0, i.`item`, 0, 0, 0, 0 FROM `npc_vendor` v JOIN (SELECT 608100 AS `item` UNION SELECT 608101 UNION SELECT 608102) i
WHERE v.`item` = 2901;

-- the hidden Deftness aura: cast-time modifier for a spell family no real spell uses; the module points it at the
-- gathering spells only (its amount is the player's Deftness)
DELETE FROM `spell_dbc` WHERE `ID` = 95420;
INSERT INTO `spell_dbc` (`ID`, `Attributes`, `CastingTimeIndex`, `DurationIndex`, `RangeIndex`, `EquippedItemClass`, `Effect_1`, `EffectAura_1`, `EffectMiscValue_1`, `EffectBasePoints_1`, `ImplicitTargetA_1`, `EffectSpellClassMaskA_1`, `SpellClassSet`, `SpellIconID`, `SchoolMask`, `Name_Lang_enUS`) VALUES
(95420, 0x000000C0, 1, 21, 1, -1, 6, 108, 10, -1, 1, 1, 12, 1, 1, 'Deftness');
