-- mod-temucraft-professions: profession equipment (tools/generate_profgear.py). Re-runnable.
-- Kind: 0 tool, 1 accessory. Skill 0 = any profession. Stats in percent; SkillBonus raises the profession while worn.
SET @ProfGear := 608700;
CREATE TABLE IF NOT EXISTS `mod_temucraft_profgear_item` (
  `ItemID` int unsigned NOT NULL, `Skill` smallint unsigned NOT NULL DEFAULT 0, `Kind` tinyint unsigned NOT NULL DEFAULT 0,
  `SkillBonus` smallint NOT NULL DEFAULT 0, `Finesse` tinyint NOT NULL DEFAULT 0, `Perception` tinyint NOT NULL DEFAULT 0,
  `Deftness` tinyint NOT NULL DEFAULT 0, `Multicraft` tinyint NOT NULL DEFAULT 0, `Resourcefulness` tinyint NOT NULL DEFAULT 0,
  `Comment` varchar(100) NOT NULL DEFAULT '', PRIMARY KEY (`ItemID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: profession equipment';
DELETE FROM `mod_temucraft_profgear_item`;
INSERT INTO `mod_temucraft_profgear_item` (`ItemID`, `Skill`, `Kind`, `SkillBonus`, `Finesse`, `Perception`, `Deftness`, `Multicraft`, `Resourcefulness`, `Comment`) VALUES
(2901, 186, 0, 0, 5, 0, 0, 0, 0, 'existing tool'),
(7005, 393, 0, 0, 5, 0, 0, 0, 0, 'existing tool'),
(40772, 0, 0, 0, 5, 0, 10, 0, 5, 'existing tool'),
(15138, 393, 0, 0, 10, 5, 10, 0, 0, 'existing tool'),
(19901, 393, 0, 0, 10, 5, 10, 0, 0, 'existing tool'),
(608100, 182, 0, 0, 5, 0, 10, 0, 0, 'existing tool'),
(608101, 186, 0, 0, 10, 5, 10, 0, 0, 'existing tool'),
(608102, 393, 0, 0, 10, 5, 10, 0, 0, 'existing tool'),
(5956, 164, 0, 0, 0, 0, 0, 0, 5, 'existing tool'),
(40892, 164, 0, 0, 0, 0, 0, 0, 5, 'existing tool'),
(40893, 164, 0, 0, 0, 0, 0, 0, 5, 'existing tool'),
(6219, 202, 0, 0, 0, 0, 0, 0, 5, 'existing tool'),
(10498, 202, 0, 0, 0, 0, 0, 5, 5, 'existing tool'),
(20815, 755, 0, 0, 0, 0, 0, 5, 5, 'existing tool'),
(39505, 773, 0, 0, 0, 0, 0, 5, 5, 'existing tool'),
(6218, 333, 0, 0, 0, 0, 0, 0, 2, 'existing tool'),
(6339, 333, 0, 0, 0, 0, 0, 0, 3, 'existing tool'),
(11130, 333, 0, 0, 0, 0, 0, 0, 4, 'existing tool'),
(11145, 333, 0, 0, 0, 0, 0, 0, 5, 'existing tool'),
(16207, 333, 0, 0, 0, 0, 0, 5, 6, 'existing tool'),
(22461, 333, 0, 0, 0, 0, 0, 5, 7, 'existing tool'),
(22462, 333, 0, 0, 0, 0, 0, 5, 8, 'existing tool'),
(22463, 333, 0, 0, 0, 0, 0, 10, 9, 'existing tool'),
(44452, 333, 0, 0, 0, 0, 0, 10, 10, 'existing tool'),
(608103, 197, 0, 0, 0, 0, 0, 5, 10, 'existing tool'),
(608104, 165, 0, 0, 0, 0, 0, 5, 10, 'existing tool'),
(608105, 185, 0, 0, 0, 0, 0, 10, 5, 'existing tool'),
(@ProfGear, 182, 0, 5, 3, 1, 3, 0, 0, 'Proficient Herbalist''s Sickle'),
(@ProfGear+1, 182, 1, 3, 1, 0, 1, 0, 0, 'Proficient Herbalist''s Gloves'),
(@ProfGear+2, 182, 0, 10, 5, 2, 5, 0, 0, 'Expert Herbalist''s Sickle'),
(@ProfGear+3, 182, 1, 6, 2, 1, 2, 0, 0, 'Expert Herbalist''s Gloves'),
(@ProfGear+4, 182, 0, 15, 8, 4, 8, 0, 0, 'Master Herbalist''s Sickle'),
(@ProfGear+5, 182, 1, 8, 4, 2, 4, 0, 0, 'Master Herbalist''s Gloves'),
(@ProfGear+6, 186, 0, 5, 3, 1, 3, 0, 0, 'Proficient Pickaxe'),
(@ProfGear+7, 186, 1, 3, 1, 0, 1, 0, 0, 'Proficient Miner''s Helmet'),
(@ProfGear+8, 186, 0, 10, 5, 2, 5, 0, 0, 'Expert Pickaxe'),
(@ProfGear+9, 186, 1, 6, 2, 1, 2, 0, 0, 'Expert Miner''s Helmet'),
(@ProfGear+10, 186, 0, 15, 8, 4, 8, 0, 0, 'Master Pickaxe'),
(@ProfGear+11, 186, 1, 8, 4, 2, 4, 0, 0, 'Master Miner''s Helmet'),
(@ProfGear+12, 393, 0, 5, 3, 1, 3, 0, 0, 'Proficient Skinning Knife'),
(@ProfGear+13, 393, 1, 3, 1, 0, 1, 0, 0, 'Proficient Skinner''s Gloves'),
(@ProfGear+14, 393, 0, 10, 5, 2, 5, 0, 0, 'Expert Skinning Knife'),
(@ProfGear+15, 393, 1, 6, 2, 1, 2, 0, 0, 'Expert Skinner''s Gloves'),
(@ProfGear+16, 393, 0, 15, 8, 4, 8, 0, 0, 'Master Skinning Knife'),
(@ProfGear+17, 393, 1, 8, 4, 2, 4, 0, 0, 'Master Skinner''s Gloves'),
(@ProfGear+18, 356, 0, 5, 3, 1, 3, 0, 0, 'Proficient Tackle Box'),
(@ProfGear+19, 356, 1, 3, 1, 0, 1, 0, 0, 'Proficient Angler''s Hat'),
(@ProfGear+20, 356, 0, 10, 5, 2, 5, 0, 0, 'Expert Tackle Box'),
(@ProfGear+21, 356, 1, 6, 2, 1, 2, 0, 0, 'Expert Angler''s Hat'),
(@ProfGear+22, 356, 0, 15, 8, 4, 8, 0, 0, 'Master Tackle Box'),
(@ProfGear+23, 356, 1, 8, 4, 2, 4, 0, 0, 'Master Angler''s Hat'),
(@ProfGear+24, 164, 0, 5, 0, 0, 0, 3, 3, 'Proficient Smithing Hammer'),
(@ProfGear+25, 164, 1, 3, 0, 0, 0, 1, 1, 'Proficient Smithing Apron'),
(@ProfGear+26, 164, 0, 10, 0, 0, 0, 5, 5, 'Expert Smithing Hammer'),
(@ProfGear+27, 164, 1, 6, 0, 0, 0, 2, 2, 'Expert Smithing Apron'),
(@ProfGear+28, 164, 0, 15, 0, 0, 0, 8, 8, 'Master Smithing Hammer'),
(@ProfGear+29, 164, 1, 8, 0, 0, 0, 4, 4, 'Master Smithing Apron'),
(@ProfGear+30, 165, 0, 5, 0, 0, 0, 3, 3, 'Proficient Leatherworker''s Awl'),
(@ProfGear+31, 165, 1, 3, 0, 0, 0, 1, 1, 'Proficient Leatherworking Apron'),
(@ProfGear+32, 165, 0, 10, 0, 0, 0, 5, 5, 'Expert Leatherworker''s Awl'),
(@ProfGear+33, 165, 1, 6, 0, 0, 0, 2, 2, 'Expert Leatherworking Apron'),
(@ProfGear+34, 165, 0, 15, 0, 0, 0, 8, 8, 'Master Leatherworker''s Awl'),
(@ProfGear+35, 165, 1, 8, 0, 0, 0, 4, 4, 'Master Leatherworking Apron'),
(@ProfGear+36, 171, 0, 5, 0, 0, 0, 3, 3, 'Proficient Alchemist''s Alembic'),
(@ProfGear+37, 171, 1, 3, 0, 0, 0, 1, 1, 'Proficient Alchemist''s Goggles'),
(@ProfGear+38, 171, 0, 10, 0, 0, 0, 5, 5, 'Expert Alchemist''s Alembic'),
(@ProfGear+39, 171, 1, 6, 0, 0, 0, 2, 2, 'Expert Alchemist''s Goggles'),
(@ProfGear+40, 171, 0, 15, 0, 0, 0, 8, 8, 'Master Alchemist''s Alembic'),
(@ProfGear+41, 171, 1, 8, 0, 0, 0, 4, 4, 'Master Alchemist''s Goggles'),
(@ProfGear+42, 197, 0, 5, 0, 0, 0, 3, 3, 'Proficient Tailor''s Needle Set'),
(@ProfGear+43, 197, 1, 3, 0, 0, 0, 1, 1, 'Proficient Tailor''s Thimble'),
(@ProfGear+44, 197, 0, 10, 0, 0, 0, 5, 5, 'Expert Tailor''s Needle Set'),
(@ProfGear+45, 197, 1, 6, 0, 0, 0, 2, 2, 'Expert Tailor''s Thimble'),
(@ProfGear+46, 197, 0, 15, 0, 0, 0, 8, 8, 'Master Tailor''s Needle Set'),
(@ProfGear+47, 197, 1, 8, 0, 0, 0, 4, 4, 'Master Tailor''s Thimble'),
(@ProfGear+48, 202, 0, 5, 0, 0, 0, 3, 3, 'Proficient Multitool'),
(@ProfGear+49, 202, 1, 3, 0, 0, 0, 1, 1, 'Proficient Engineer''s Goggles'),
(@ProfGear+50, 202, 0, 10, 0, 0, 0, 5, 5, 'Expert Multitool'),
(@ProfGear+51, 202, 1, 6, 0, 0, 0, 2, 2, 'Expert Engineer''s Goggles'),
(@ProfGear+52, 202, 0, 15, 0, 0, 0, 8, 8, 'Master Multitool'),
(@ProfGear+53, 202, 1, 8, 0, 0, 0, 4, 4, 'Master Engineer''s Goggles'),
(@ProfGear+54, 333, 0, 5, 0, 0, 0, 3, 3, 'Proficient Enchanter''s Rod'),
(@ProfGear+55, 333, 1, 3, 0, 0, 0, 1, 1, 'Proficient Enchanter''s Focus'),
(@ProfGear+56, 333, 0, 10, 0, 0, 0, 5, 5, 'Expert Enchanter''s Rod'),
(@ProfGear+57, 333, 1, 6, 0, 0, 0, 2, 2, 'Expert Enchanter''s Focus'),
(@ProfGear+58, 333, 0, 15, 0, 0, 0, 8, 8, 'Master Enchanter''s Rod'),
(@ProfGear+59, 333, 1, 8, 0, 0, 0, 4, 4, 'Master Enchanter''s Focus'),
(@ProfGear+60, 755, 0, 5, 0, 0, 0, 3, 3, 'Proficient Jeweler''s Loupe'),
(@ProfGear+61, 755, 1, 3, 0, 0, 0, 1, 1, 'Proficient Jeweler''s Goggles'),
(@ProfGear+62, 755, 0, 10, 0, 0, 0, 5, 5, 'Expert Jeweler''s Loupe'),
(@ProfGear+63, 755, 1, 6, 0, 0, 0, 2, 2, 'Expert Jeweler''s Goggles'),
(@ProfGear+64, 755, 0, 15, 0, 0, 0, 8, 8, 'Master Jeweler''s Loupe'),
(@ProfGear+65, 755, 1, 8, 0, 0, 0, 4, 4, 'Master Jeweler''s Goggles'),
(@ProfGear+66, 773, 0, 5, 0, 0, 0, 3, 3, 'Proficient Scribe''s Quill'),
(@ProfGear+67, 773, 1, 3, 0, 0, 0, 1, 1, 'Proficient Scribe''s Spectacles'),
(@ProfGear+68, 773, 0, 10, 0, 0, 0, 5, 5, 'Expert Scribe''s Quill'),
(@ProfGear+69, 773, 1, 6, 0, 0, 0, 2, 2, 'Expert Scribe''s Spectacles'),
(@ProfGear+70, 773, 0, 15, 0, 0, 0, 8, 8, 'Master Scribe''s Quill'),
(@ProfGear+71, 773, 1, 8, 0, 0, 0, 4, 4, 'Master Scribe''s Spectacles'),
(@ProfGear+72, 185, 0, 5, 0, 0, 0, 3, 3, 'Proficient Chef''s Cleaver'),
(@ProfGear+73, 185, 1, 3, 0, 0, 0, 1, 1, 'Proficient Chef''s Hat'),
(@ProfGear+74, 185, 0, 10, 0, 0, 0, 5, 5, 'Expert Chef''s Cleaver'),
(@ProfGear+75, 185, 1, 6, 0, 0, 0, 2, 2, 'Expert Chef''s Hat'),
(@ProfGear+76, 185, 0, 15, 0, 0, 0, 8, 8, 'Master Chef''s Cleaver'),
(@ProfGear+77, 185, 1, 8, 0, 0, 0, 4, 4, 'Master Chef''s Hat'),
(@ProfGear+78, 129, 0, 5, 0, 0, 0, 3, 3, 'Proficient Field Surgeon''s Kit'),
(@ProfGear+79, 129, 1, 3, 0, 0, 0, 1, 1, 'Proficient Surgeon''s Gloves'),
(@ProfGear+80, 129, 0, 10, 0, 0, 0, 5, 5, 'Expert Field Surgeon''s Kit'),
(@ProfGear+81, 129, 1, 6, 0, 0, 0, 2, 2, 'Expert Surgeon''s Gloves'),
(@ProfGear+82, 129, 0, 15, 0, 0, 0, 8, 8, 'Master Field Surgeon''s Kit'),
(@ProfGear+83, 129, 1, 8, 0, 0, 0, 4, 4, 'Master Surgeon''s Gloves');

DELETE FROM `item_template` WHERE `entry` BETWEEN @ProfGear AND @ProfGear+83;
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `ItemLevel`, `RequiredSkill`, `RequiredSkillRank`, `maxcount`, `stackable`, `bonding`, `description`, `Material`, `VerifiedBuild`) VALUES
(@ProfGear, 15, 0, -1, 'Proficient Herbalist''s Sickle', 7393, 2, 1, 5000, 1250, 0, 10, 182, 1, 1, 1, 1, 'Profession equipment (Herbalism): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+1, 15, 0, -1, 'Proficient Herbalist''s Gloves', 7348, 2, 1, 2500, 625, 0, 10, 182, 1, 1, 1, 1, 'Profession equipment (Herbalism): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+2, 15, 0, -1, 'Expert Herbalist''s Sickle', 7393, 3, 1, 100000, 25000, 0, 60, 182, 300, 1, 1, 1, 'Profession equipment (Herbalism): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+3, 15, 0, -1, 'Expert Herbalist''s Gloves', 7348, 3, 1, 50000, 12500, 0, 60, 182, 300, 1, 1, 1, 'Profession equipment (Herbalism): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+4, 15, 0, -1, 'Master Herbalist''s Sickle', 7393, 4, 1, 500000, 125000, 0, 70, 182, 375, 1, 1, 1, 'Profession equipment (Herbalism): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+5, 15, 0, -1, 'Master Herbalist''s Gloves', 7348, 4, 1, 250000, 62500, 0, 70, 182, 375, 1, 1, 1, 'Profession equipment (Herbalism): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+6, 15, 0, -1, 'Proficient Pickaxe', 6568, 2, 1, 5000, 1250, 0, 10, 186, 1, 1, 1, 1, 'Profession equipment (Mining): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+7, 15, 0, -1, 'Proficient Miner''s Helmet', 23161, 2, 1, 2500, 625, 0, 10, 186, 1, 1, 1, 1, 'Profession equipment (Mining): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+8, 15, 0, -1, 'Expert Pickaxe', 6568, 3, 1, 100000, 25000, 0, 60, 186, 300, 1, 1, 1, 'Profession equipment (Mining): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+9, 15, 0, -1, 'Expert Miner''s Helmet', 23161, 3, 1, 50000, 12500, 0, 60, 186, 300, 1, 1, 1, 'Profession equipment (Mining): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+10, 15, 0, -1, 'Master Pickaxe', 6568, 4, 1, 500000, 125000, 0, 70, 186, 375, 1, 1, 1, 'Profession equipment (Mining): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+11, 15, 0, -1, 'Master Miner''s Helmet', 23161, 4, 1, 250000, 62500, 0, 70, 186, 375, 1, 1, 1, 'Profession equipment (Mining): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+12, 15, 0, -1, 'Proficient Skinning Knife', 6440, 2, 1, 5000, 1250, 0, 10, 393, 1, 1, 1, 1, 'Profession equipment (Skinning): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+13, 15, 0, -1, 'Proficient Skinner''s Gloves', 17176, 2, 1, 2500, 625, 0, 10, 393, 1, 1, 1, 1, 'Profession equipment (Skinning): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+14, 15, 0, -1, 'Expert Skinning Knife', 6440, 3, 1, 100000, 25000, 0, 60, 393, 300, 1, 1, 1, 'Profession equipment (Skinning): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+15, 15, 0, -1, 'Expert Skinner''s Gloves', 17176, 3, 1, 50000, 12500, 0, 60, 393, 300, 1, 1, 1, 'Profession equipment (Skinning): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+16, 15, 0, -1, 'Master Skinning Knife', 6440, 4, 1, 500000, 125000, 0, 70, 393, 375, 1, 1, 1, 'Profession equipment (Skinning): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+17, 15, 0, -1, 'Master Skinner''s Gloves', 17176, 4, 1, 250000, 62500, 0, 70, 393, 375, 1, 1, 1, 'Profession equipment (Skinning): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+18, 15, 0, -1, 'Proficient Tackle Box', 4720, 2, 1, 5000, 1250, 0, 10, 356, 1, 1, 1, 1, 'Profession equipment (Fishing): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+19, 15, 0, -1, 'Proficient Angler''s Hat', 13236, 2, 1, 2500, 625, 0, 10, 356, 1, 1, 1, 1, 'Profession equipment (Fishing): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+20, 15, 0, -1, 'Expert Tackle Box', 4720, 3, 1, 100000, 25000, 0, 60, 356, 300, 1, 1, 1, 'Profession equipment (Fishing): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+21, 15, 0, -1, 'Expert Angler''s Hat', 13236, 3, 1, 50000, 12500, 0, 60, 356, 300, 1, 1, 1, 'Profession equipment (Fishing): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+22, 15, 0, -1, 'Master Tackle Box', 4720, 4, 1, 500000, 125000, 0, 70, 356, 375, 1, 1, 1, 'Profession equipment (Fishing): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+23, 15, 0, -1, 'Master Angler''s Hat', 13236, 4, 1, 250000, 62500, 0, 70, 356, 375, 1, 1, 1, 'Profession equipment (Fishing): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+24, 15, 0, -1, 'Proficient Smithing Hammer', 8568, 2, 1, 5000, 1250, 0, 10, 164, 1, 1, 1, 1, 'Profession equipment (Blacksmithing): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+25, 15, 0, -1, 'Proficient Smithing Apron', 13117, 2, 1, 2500, 625, 0, 10, 164, 1, 1, 1, 1, 'Profession equipment (Blacksmithing): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+26, 15, 0, -1, 'Expert Smithing Hammer', 8568, 3, 1, 100000, 25000, 0, 60, 164, 300, 1, 1, 1, 'Profession equipment (Blacksmithing): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+27, 15, 0, -1, 'Expert Smithing Apron', 13117, 3, 1, 50000, 12500, 0, 60, 164, 300, 1, 1, 1, 'Profession equipment (Blacksmithing): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+28, 15, 0, -1, 'Master Smithing Hammer', 8568, 4, 1, 500000, 125000, 0, 70, 164, 375, 1, 1, 1, 'Profession equipment (Blacksmithing): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+29, 15, 0, -1, 'Master Smithing Apron', 13117, 4, 1, 250000, 62500, 0, 70, 164, 375, 1, 1, 1, 'Profession equipment (Blacksmithing): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+30, 15, 0, -1, 'Proficient Leatherworker''s Awl', 6440, 2, 1, 5000, 1250, 0, 10, 165, 1, 1, 1, 1, 'Profession equipment (Leatherworking): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+31, 15, 0, -1, 'Proficient Leatherworking Apron', 13117, 2, 1, 2500, 625, 0, 10, 165, 1, 1, 1, 1, 'Profession equipment (Leatherworking): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+32, 15, 0, -1, 'Expert Leatherworker''s Awl', 6440, 3, 1, 100000, 25000, 0, 60, 165, 300, 1, 1, 1, 'Profession equipment (Leatherworking): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+33, 15, 0, -1, 'Expert Leatherworking Apron', 13117, 3, 1, 50000, 12500, 0, 60, 165, 300, 1, 1, 1, 'Profession equipment (Leatherworking): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+34, 15, 0, -1, 'Master Leatherworker''s Awl', 6440, 4, 1, 500000, 125000, 0, 70, 165, 375, 1, 1, 1, 'Profession equipment (Leatherworking): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+35, 15, 0, -1, 'Master Leatherworking Apron', 13117, 4, 1, 250000, 62500, 0, 70, 165, 375, 1, 1, 1, 'Profession equipment (Leatherworking): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+36, 15, 0, -1, 'Proficient Alchemist''s Alembic', 8025, 2, 1, 5000, 1250, 0, 10, 171, 1, 1, 1, 1, 'Profession equipment (Alchemy): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+37, 15, 0, -1, 'Proficient Alchemist''s Goggles', 19399, 2, 1, 2500, 625, 0, 10, 171, 1, 1, 1, 1, 'Profession equipment (Alchemy): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+38, 15, 0, -1, 'Expert Alchemist''s Alembic', 8025, 3, 1, 100000, 25000, 0, 60, 171, 300, 1, 1, 1, 'Profession equipment (Alchemy): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+39, 15, 0, -1, 'Expert Alchemist''s Goggles', 19399, 3, 1, 50000, 12500, 0, 60, 171, 300, 1, 1, 1, 'Profession equipment (Alchemy): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+40, 15, 0, -1, 'Master Alchemist''s Alembic', 8025, 4, 1, 500000, 125000, 0, 70, 171, 375, 1, 1, 1, 'Profession equipment (Alchemy): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+41, 15, 0, -1, 'Master Alchemist''s Goggles', 19399, 4, 1, 250000, 62500, 0, 70, 171, 375, 1, 1, 1, 'Profession equipment (Alchemy): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+42, 15, 0, -1, 'Proficient Tailor''s Needle Set', 25048, 2, 1, 5000, 1250, 0, 10, 197, 1, 1, 1, 1, 'Profession equipment (Tailoring): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+43, 15, 0, -1, 'Proficient Tailor''s Thimble', 14432, 2, 1, 2500, 625, 0, 10, 197, 1, 1, 1, 1, 'Profession equipment (Tailoring): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+44, 15, 0, -1, 'Expert Tailor''s Needle Set', 25048, 3, 1, 100000, 25000, 0, 60, 197, 300, 1, 1, 1, 'Profession equipment (Tailoring): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+45, 15, 0, -1, 'Expert Tailor''s Thimble', 14432, 3, 1, 50000, 12500, 0, 60, 197, 300, 1, 1, 1, 'Profession equipment (Tailoring): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+46, 15, 0, -1, 'Master Tailor''s Needle Set', 25048, 4, 1, 500000, 125000, 0, 70, 197, 375, 1, 1, 1, 'Profession equipment (Tailoring): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+47, 15, 0, -1, 'Master Tailor''s Thimble', 14432, 4, 1, 250000, 62500, 0, 70, 197, 375, 1, 1, 1, 'Profession equipment (Tailoring): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+48, 15, 0, -1, 'Proficient Multitool', 7494, 2, 1, 5000, 1250, 0, 10, 202, 1, 1, 1, 1, 'Profession equipment (Engineering): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+49, 15, 0, -1, 'Proficient Engineer''s Goggles', 19409, 2, 1, 2500, 625, 0, 10, 202, 1, 1, 1, 1, 'Profession equipment (Engineering): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+50, 15, 0, -1, 'Expert Multitool', 7494, 3, 1, 100000, 25000, 0, 60, 202, 300, 1, 1, 1, 'Profession equipment (Engineering): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+51, 15, 0, -1, 'Expert Engineer''s Goggles', 19409, 3, 1, 50000, 12500, 0, 60, 202, 300, 1, 1, 1, 'Profession equipment (Engineering): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+52, 15, 0, -1, 'Master Multitool', 7494, 4, 1, 500000, 125000, 0, 70, 202, 375, 1, 1, 1, 'Profession equipment (Engineering): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+53, 15, 0, -1, 'Master Engineer''s Goggles', 19409, 4, 1, 250000, 62500, 0, 70, 202, 375, 1, 1, 1, 'Profession equipment (Engineering): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+54, 15, 0, -1, 'Proficient Enchanter''s Rod', 21207, 2, 1, 5000, 1250, 0, 10, 333, 1, 1, 1, 1, 'Profession equipment (Enchanting): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+55, 15, 0, -1, 'Proficient Enchanter''s Focus', 14432, 2, 1, 2500, 625, 0, 10, 333, 1, 1, 1, 1, 'Profession equipment (Enchanting): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+56, 15, 0, -1, 'Expert Enchanter''s Rod', 21207, 3, 1, 100000, 25000, 0, 60, 333, 300, 1, 1, 1, 'Profession equipment (Enchanting): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+57, 15, 0, -1, 'Expert Enchanter''s Focus', 14432, 3, 1, 50000, 12500, 0, 60, 333, 300, 1, 1, 1, 'Profession equipment (Enchanting): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+58, 15, 0, -1, 'Master Enchanter''s Rod', 21207, 4, 1, 500000, 125000, 0, 70, 333, 375, 1, 1, 1, 'Profession equipment (Enchanting): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+59, 15, 0, -1, 'Master Enchanter''s Focus', 14432, 4, 1, 250000, 62500, 0, 70, 333, 375, 1, 1, 1, 'Profession equipment (Enchanting): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+60, 15, 0, -1, 'Proficient Jeweler''s Loupe', 33224, 2, 1, 5000, 1250, 0, 10, 755, 1, 1, 1, 1, 'Profession equipment (Jewelcrafting): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+61, 15, 0, -1, 'Proficient Jeweler''s Goggles', 19399, 2, 1, 2500, 625, 0, 10, 755, 1, 1, 1, 1, 'Profession equipment (Jewelcrafting): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+62, 15, 0, -1, 'Expert Jeweler''s Loupe', 33224, 3, 1, 100000, 25000, 0, 60, 755, 300, 1, 1, 1, 'Profession equipment (Jewelcrafting): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+63, 15, 0, -1, 'Expert Jeweler''s Goggles', 19399, 3, 1, 50000, 12500, 0, 60, 755, 300, 1, 1, 1, 'Profession equipment (Jewelcrafting): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+64, 15, 0, -1, 'Master Jeweler''s Loupe', 33224, 4, 1, 500000, 125000, 0, 70, 755, 375, 1, 1, 1, 'Profession equipment (Jewelcrafting): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+65, 15, 0, -1, 'Master Jeweler''s Goggles', 19399, 4, 1, 250000, 62500, 0, 70, 755, 375, 1, 1, 1, 'Profession equipment (Jewelcrafting): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+66, 15, 0, -1, 'Proficient Scribe''s Quill', 57293, 2, 1, 5000, 1250, 0, 10, 773, 1, 1, 1, 1, 'Profession equipment (Inscription): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+67, 15, 0, -1, 'Proficient Scribe''s Spectacles', 13236, 2, 1, 2500, 625, 0, 10, 773, 1, 1, 1, 1, 'Profession equipment (Inscription): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+68, 15, 0, -1, 'Expert Scribe''s Quill', 57293, 3, 1, 100000, 25000, 0, 60, 773, 300, 1, 1, 1, 'Profession equipment (Inscription): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+69, 15, 0, -1, 'Expert Scribe''s Spectacles', 13236, 3, 1, 50000, 12500, 0, 60, 773, 300, 1, 1, 1, 'Profession equipment (Inscription): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+70, 15, 0, -1, 'Master Scribe''s Quill', 57293, 4, 1, 500000, 125000, 0, 70, 773, 375, 1, 1, 1, 'Profession equipment (Inscription): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+71, 15, 0, -1, 'Master Scribe''s Spectacles', 13236, 4, 1, 250000, 62500, 0, 70, 773, 375, 1, 1, 1, 'Profession equipment (Inscription): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+72, 15, 0, -1, 'Proficient Chef''s Cleaver', 4720, 2, 1, 5000, 1250, 0, 10, 185, 1, 1, 1, 1, 'Profession equipment (Cooking): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+73, 15, 0, -1, 'Proficient Chef''s Hat', 13236, 2, 1, 2500, 625, 0, 10, 185, 1, 1, 1, 1, 'Profession equipment (Cooking): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+74, 15, 0, -1, 'Expert Chef''s Cleaver', 4720, 3, 1, 100000, 25000, 0, 60, 185, 300, 1, 1, 1, 'Profession equipment (Cooking): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+75, 15, 0, -1, 'Expert Chef''s Hat', 13236, 3, 1, 50000, 12500, 0, 60, 185, 300, 1, 1, 1, 'Profession equipment (Cooking): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+76, 15, 0, -1, 'Master Chef''s Cleaver', 4720, 4, 1, 500000, 125000, 0, 70, 185, 375, 1, 1, 1, 'Profession equipment (Cooking): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+77, 15, 0, -1, 'Master Chef''s Hat', 13236, 4, 1, 250000, 62500, 0, 70, 185, 375, 1, 1, 1, 'Profession equipment (Cooking): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+78, 15, 0, -1, 'Proficient Field Surgeon''s Kit', 11907, 2, 1, 5000, 1250, 0, 10, 129, 1, 1, 1, 1, 'Profession equipment (First Aid): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+79, 15, 0, -1, 'Proficient Surgeon''s Gloves', 7348, 2, 1, 2500, 625, 0, 10, 129, 1, 1, 1, 1, 'Profession equipment (First Aid): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+80, 15, 0, -1, 'Expert Field Surgeon''s Kit', 11907, 3, 1, 100000, 25000, 0, 60, 129, 300, 1, 1, 1, 'Profession equipment (First Aid): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+81, 15, 0, -1, 'Expert Surgeon''s Gloves', 7348, 3, 1, 50000, 12500, 0, 60, 129, 300, 1, 1, 1, 'Profession equipment (First Aid): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+82, 15, 0, -1, 'Master Field Surgeon''s Kit', 11907, 4, 1, 500000, 125000, 0, 70, 129, 375, 1, 1, 1, 'Profession equipment (First Aid): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(@ProfGear+83, 15, 0, -1, 'Master Surgeon''s Gloves', 7348, 4, 1, 250000, 62500, 0, 70, 129, 375, 1, 1, 1, 'Profession equipment (First Aid): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0);

-- sold by the vendors who sell each profession's basic supplies (Coarse Thread, Mining Pick, Skinning Knife...)
DELETE FROM `npc_vendor` WHERE `item` BETWEEN @ProfGear AND @ProfGear+83;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+1, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+2, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+3, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+4, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+5, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+6, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+7, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+8, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+9, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+10, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+11, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+12, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+13, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+14, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+15, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+16, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+17, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+18, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+19, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+20, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+21, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+22, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+23, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+24, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+25, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+26, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+27, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+28, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+29, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+30, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+31, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+32, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+33, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+34, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+35, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+36, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+37, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+38, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+39, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+40, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+41, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+42, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+43, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+44, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+45, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+46, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+47, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+48, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+49, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+50, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+51, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+52, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+53, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+54, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+55, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+56, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+57, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+58, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+59, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+60, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+61, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+62, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+63, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+64, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+65, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+66, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+67, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+68, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+69, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+70, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+71, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+72, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+73, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+74, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+75, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+76, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+77, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+78, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+79, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+80, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+81, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+82, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, @ProfGear+83, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
