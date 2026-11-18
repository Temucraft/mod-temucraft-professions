-- mod-temucraft-professions: profession equipment (tools/generate_profgear.py). Re-runnable.
-- Kind: 0 tool, 1 accessory. Skill 0 = any profession. Stats in percent; SkillBonus raises the profession while worn.
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
(608700, 182, 0, 5, 3, 1, 3, 0, 0, 'Proficient Herbalist''s Sickle'),
(608701, 182, 1, 3, 1, 0, 1, 0, 0, 'Proficient Herbalist''s Gloves'),
(608702, 182, 0, 10, 5, 2, 5, 0, 0, 'Expert Herbalist''s Sickle'),
(608703, 182, 1, 6, 2, 1, 2, 0, 0, 'Expert Herbalist''s Gloves'),
(608704, 182, 0, 15, 8, 4, 8, 0, 0, 'Master Herbalist''s Sickle'),
(608705, 182, 1, 8, 4, 2, 4, 0, 0, 'Master Herbalist''s Gloves'),
(608706, 186, 0, 5, 3, 1, 3, 0, 0, 'Proficient Pickaxe'),
(608707, 186, 1, 3, 1, 0, 1, 0, 0, 'Proficient Miner''s Helmet'),
(608708, 186, 0, 10, 5, 2, 5, 0, 0, 'Expert Pickaxe'),
(608709, 186, 1, 6, 2, 1, 2, 0, 0, 'Expert Miner''s Helmet'),
(608710, 186, 0, 15, 8, 4, 8, 0, 0, 'Master Pickaxe'),
(608711, 186, 1, 8, 4, 2, 4, 0, 0, 'Master Miner''s Helmet'),
(608712, 393, 0, 5, 3, 1, 3, 0, 0, 'Proficient Skinning Knife'),
(608713, 393, 1, 3, 1, 0, 1, 0, 0, 'Proficient Skinner''s Gloves'),
(608714, 393, 0, 10, 5, 2, 5, 0, 0, 'Expert Skinning Knife'),
(608715, 393, 1, 6, 2, 1, 2, 0, 0, 'Expert Skinner''s Gloves'),
(608716, 393, 0, 15, 8, 4, 8, 0, 0, 'Master Skinning Knife'),
(608717, 393, 1, 8, 4, 2, 4, 0, 0, 'Master Skinner''s Gloves'),
(608718, 356, 0, 5, 3, 1, 3, 0, 0, 'Proficient Tackle Box'),
(608719, 356, 1, 3, 1, 0, 1, 0, 0, 'Proficient Angler''s Hat'),
(608720, 356, 0, 10, 5, 2, 5, 0, 0, 'Expert Tackle Box'),
(608721, 356, 1, 6, 2, 1, 2, 0, 0, 'Expert Angler''s Hat'),
(608722, 356, 0, 15, 8, 4, 8, 0, 0, 'Master Tackle Box'),
(608723, 356, 1, 8, 4, 2, 4, 0, 0, 'Master Angler''s Hat'),
(608724, 164, 0, 5, 0, 0, 0, 3, 3, 'Proficient Smithing Hammer'),
(608725, 164, 1, 3, 0, 0, 0, 1, 1, 'Proficient Smithing Apron'),
(608726, 164, 0, 10, 0, 0, 0, 5, 5, 'Expert Smithing Hammer'),
(608727, 164, 1, 6, 0, 0, 0, 2, 2, 'Expert Smithing Apron'),
(608728, 164, 0, 15, 0, 0, 0, 8, 8, 'Master Smithing Hammer'),
(608729, 164, 1, 8, 0, 0, 0, 4, 4, 'Master Smithing Apron'),
(608730, 165, 0, 5, 0, 0, 0, 3, 3, 'Proficient Leatherworker''s Awl'),
(608731, 165, 1, 3, 0, 0, 0, 1, 1, 'Proficient Leatherworking Apron'),
(608732, 165, 0, 10, 0, 0, 0, 5, 5, 'Expert Leatherworker''s Awl'),
(608733, 165, 1, 6, 0, 0, 0, 2, 2, 'Expert Leatherworking Apron'),
(608734, 165, 0, 15, 0, 0, 0, 8, 8, 'Master Leatherworker''s Awl'),
(608735, 165, 1, 8, 0, 0, 0, 4, 4, 'Master Leatherworking Apron'),
(608736, 171, 0, 5, 0, 0, 0, 3, 3, 'Proficient Alchemist''s Alembic'),
(608737, 171, 1, 3, 0, 0, 0, 1, 1, 'Proficient Alchemist''s Goggles'),
(608738, 171, 0, 10, 0, 0, 0, 5, 5, 'Expert Alchemist''s Alembic'),
(608739, 171, 1, 6, 0, 0, 0, 2, 2, 'Expert Alchemist''s Goggles'),
(608740, 171, 0, 15, 0, 0, 0, 8, 8, 'Master Alchemist''s Alembic'),
(608741, 171, 1, 8, 0, 0, 0, 4, 4, 'Master Alchemist''s Goggles'),
(608742, 197, 0, 5, 0, 0, 0, 3, 3, 'Proficient Tailor''s Needle Set'),
(608743, 197, 1, 3, 0, 0, 0, 1, 1, 'Proficient Tailor''s Thimble'),
(608744, 197, 0, 10, 0, 0, 0, 5, 5, 'Expert Tailor''s Needle Set'),
(608745, 197, 1, 6, 0, 0, 0, 2, 2, 'Expert Tailor''s Thimble'),
(608746, 197, 0, 15, 0, 0, 0, 8, 8, 'Master Tailor''s Needle Set'),
(608747, 197, 1, 8, 0, 0, 0, 4, 4, 'Master Tailor''s Thimble'),
(608748, 202, 0, 5, 0, 0, 0, 3, 3, 'Proficient Multitool'),
(608749, 202, 1, 3, 0, 0, 0, 1, 1, 'Proficient Engineer''s Goggles'),
(608750, 202, 0, 10, 0, 0, 0, 5, 5, 'Expert Multitool'),
(608751, 202, 1, 6, 0, 0, 0, 2, 2, 'Expert Engineer''s Goggles'),
(608752, 202, 0, 15, 0, 0, 0, 8, 8, 'Master Multitool'),
(608753, 202, 1, 8, 0, 0, 0, 4, 4, 'Master Engineer''s Goggles'),
(608754, 333, 0, 5, 0, 0, 0, 3, 3, 'Proficient Enchanter''s Rod'),
(608755, 333, 1, 3, 0, 0, 0, 1, 1, 'Proficient Enchanter''s Focus'),
(608756, 333, 0, 10, 0, 0, 0, 5, 5, 'Expert Enchanter''s Rod'),
(608757, 333, 1, 6, 0, 0, 0, 2, 2, 'Expert Enchanter''s Focus'),
(608758, 333, 0, 15, 0, 0, 0, 8, 8, 'Master Enchanter''s Rod'),
(608759, 333, 1, 8, 0, 0, 0, 4, 4, 'Master Enchanter''s Focus'),
(608760, 755, 0, 5, 0, 0, 0, 3, 3, 'Proficient Jeweler''s Loupe'),
(608761, 755, 1, 3, 0, 0, 0, 1, 1, 'Proficient Jeweler''s Goggles'),
(608762, 755, 0, 10, 0, 0, 0, 5, 5, 'Expert Jeweler''s Loupe'),
(608763, 755, 1, 6, 0, 0, 0, 2, 2, 'Expert Jeweler''s Goggles'),
(608764, 755, 0, 15, 0, 0, 0, 8, 8, 'Master Jeweler''s Loupe'),
(608765, 755, 1, 8, 0, 0, 0, 4, 4, 'Master Jeweler''s Goggles'),
(608766, 773, 0, 5, 0, 0, 0, 3, 3, 'Proficient Scribe''s Quill'),
(608767, 773, 1, 3, 0, 0, 0, 1, 1, 'Proficient Scribe''s Spectacles'),
(608768, 773, 0, 10, 0, 0, 0, 5, 5, 'Expert Scribe''s Quill'),
(608769, 773, 1, 6, 0, 0, 0, 2, 2, 'Expert Scribe''s Spectacles'),
(608770, 773, 0, 15, 0, 0, 0, 8, 8, 'Master Scribe''s Quill'),
(608771, 773, 1, 8, 0, 0, 0, 4, 4, 'Master Scribe''s Spectacles'),
(608772, 185, 0, 5, 0, 0, 0, 3, 3, 'Proficient Chef''s Cleaver'),
(608773, 185, 1, 3, 0, 0, 0, 1, 1, 'Proficient Chef''s Hat'),
(608774, 185, 0, 10, 0, 0, 0, 5, 5, 'Expert Chef''s Cleaver'),
(608775, 185, 1, 6, 0, 0, 0, 2, 2, 'Expert Chef''s Hat'),
(608776, 185, 0, 15, 0, 0, 0, 8, 8, 'Master Chef''s Cleaver'),
(608777, 185, 1, 8, 0, 0, 0, 4, 4, 'Master Chef''s Hat'),
(608778, 129, 0, 5, 0, 0, 0, 3, 3, 'Proficient Field Surgeon''s Kit'),
(608779, 129, 1, 3, 0, 0, 0, 1, 1, 'Proficient Surgeon''s Gloves'),
(608780, 129, 0, 10, 0, 0, 0, 5, 5, 'Expert Field Surgeon''s Kit'),
(608781, 129, 1, 6, 0, 0, 0, 2, 2, 'Expert Surgeon''s Gloves'),
(608782, 129, 0, 15, 0, 0, 0, 8, 8, 'Master Field Surgeon''s Kit'),
(608783, 129, 1, 8, 0, 0, 0, 4, 4, 'Master Surgeon''s Gloves');

DELETE FROM `item_template` WHERE `entry` BETWEEN 608700 AND 608783;
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `ItemLevel`, `RequiredSkill`, `RequiredSkillRank`, `maxcount`, `stackable`, `bonding`, `description`, `Material`, `VerifiedBuild`) VALUES
(608700, 15, 0, -1, 'Proficient Herbalist''s Sickle', 7393, 2, 1, 5000, 1250, 0, 10, 182, 1, 1, 1, 1, 'Profession equipment (Herbalism): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608701, 15, 0, -1, 'Proficient Herbalist''s Gloves', 7348, 2, 1, 2500, 625, 0, 10, 182, 1, 1, 1, 1, 'Profession equipment (Herbalism): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608702, 15, 0, -1, 'Expert Herbalist''s Sickle', 7393, 3, 1, 100000, 25000, 0, 60, 182, 300, 1, 1, 1, 'Profession equipment (Herbalism): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608703, 15, 0, -1, 'Expert Herbalist''s Gloves', 7348, 3, 1, 50000, 12500, 0, 60, 182, 300, 1, 1, 1, 'Profession equipment (Herbalism): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608704, 15, 0, -1, 'Master Herbalist''s Sickle', 7393, 4, 1, 500000, 125000, 0, 70, 182, 375, 1, 1, 1, 'Profession equipment (Herbalism): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608705, 15, 0, -1, 'Master Herbalist''s Gloves', 7348, 4, 1, 250000, 62500, 0, 70, 182, 375, 1, 1, 1, 'Profession equipment (Herbalism): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608706, 15, 0, -1, 'Proficient Pickaxe', 6568, 2, 1, 5000, 1250, 0, 10, 186, 1, 1, 1, 1, 'Profession equipment (Mining): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608707, 15, 0, -1, 'Proficient Miner''s Helmet', 23161, 2, 1, 2500, 625, 0, 10, 186, 1, 1, 1, 1, 'Profession equipment (Mining): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608708, 15, 0, -1, 'Expert Pickaxe', 6568, 3, 1, 100000, 25000, 0, 60, 186, 300, 1, 1, 1, 'Profession equipment (Mining): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608709, 15, 0, -1, 'Expert Miner''s Helmet', 23161, 3, 1, 50000, 12500, 0, 60, 186, 300, 1, 1, 1, 'Profession equipment (Mining): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608710, 15, 0, -1, 'Master Pickaxe', 6568, 4, 1, 500000, 125000, 0, 70, 186, 375, 1, 1, 1, 'Profession equipment (Mining): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608711, 15, 0, -1, 'Master Miner''s Helmet', 23161, 4, 1, 250000, 62500, 0, 70, 186, 375, 1, 1, 1, 'Profession equipment (Mining): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608712, 15, 0, -1, 'Proficient Skinning Knife', 6440, 2, 1, 5000, 1250, 0, 10, 393, 1, 1, 1, 1, 'Profession equipment (Skinning): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608713, 15, 0, -1, 'Proficient Skinner''s Gloves', 17176, 2, 1, 2500, 625, 0, 10, 393, 1, 1, 1, 1, 'Profession equipment (Skinning): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608714, 15, 0, -1, 'Expert Skinning Knife', 6440, 3, 1, 100000, 25000, 0, 60, 393, 300, 1, 1, 1, 'Profession equipment (Skinning): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608715, 15, 0, -1, 'Expert Skinner''s Gloves', 17176, 3, 1, 50000, 12500, 0, 60, 393, 300, 1, 1, 1, 'Profession equipment (Skinning): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608716, 15, 0, -1, 'Master Skinning Knife', 6440, 4, 1, 500000, 125000, 0, 70, 393, 375, 1, 1, 1, 'Profession equipment (Skinning): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608717, 15, 0, -1, 'Master Skinner''s Gloves', 17176, 4, 1, 250000, 62500, 0, 70, 393, 375, 1, 1, 1, 'Profession equipment (Skinning): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608718, 15, 0, -1, 'Proficient Tackle Box', 4720, 2, 1, 5000, 1250, 0, 10, 356, 1, 1, 1, 1, 'Profession equipment (Fishing): +5 skill, Finesse +3%, Perception +1%, Deftness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608719, 15, 0, -1, 'Proficient Angler''s Hat', 13236, 2, 1, 2500, 625, 0, 10, 356, 1, 1, 1, 1, 'Profession equipment (Fishing): +3 skill, Finesse +1%, Perception +0%, Deftness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608720, 15, 0, -1, 'Expert Tackle Box', 4720, 3, 1, 100000, 25000, 0, 60, 356, 300, 1, 1, 1, 'Profession equipment (Fishing): +10 skill, Finesse +5%, Perception +2%, Deftness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608721, 15, 0, -1, 'Expert Angler''s Hat', 13236, 3, 1, 50000, 12500, 0, 60, 356, 300, 1, 1, 1, 'Profession equipment (Fishing): +6 skill, Finesse +2%, Perception +1%, Deftness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608722, 15, 0, -1, 'Master Tackle Box', 4720, 4, 1, 500000, 125000, 0, 70, 356, 375, 1, 1, 1, 'Profession equipment (Fishing): +15 skill, Finesse +8%, Perception +4%, Deftness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608723, 15, 0, -1, 'Master Angler''s Hat', 13236, 4, 1, 250000, 62500, 0, 70, 356, 375, 1, 1, 1, 'Profession equipment (Fishing): +8 skill, Finesse +4%, Perception +2%, Deftness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608724, 15, 0, -1, 'Proficient Smithing Hammer', 8568, 2, 1, 5000, 1250, 0, 10, 164, 1, 1, 1, 1, 'Profession equipment (Blacksmithing): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608725, 15, 0, -1, 'Proficient Smithing Apron', 13117, 2, 1, 2500, 625, 0, 10, 164, 1, 1, 1, 1, 'Profession equipment (Blacksmithing): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608726, 15, 0, -1, 'Expert Smithing Hammer', 8568, 3, 1, 100000, 25000, 0, 60, 164, 300, 1, 1, 1, 'Profession equipment (Blacksmithing): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608727, 15, 0, -1, 'Expert Smithing Apron', 13117, 3, 1, 50000, 12500, 0, 60, 164, 300, 1, 1, 1, 'Profession equipment (Blacksmithing): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608728, 15, 0, -1, 'Master Smithing Hammer', 8568, 4, 1, 500000, 125000, 0, 70, 164, 375, 1, 1, 1, 'Profession equipment (Blacksmithing): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608729, 15, 0, -1, 'Master Smithing Apron', 13117, 4, 1, 250000, 62500, 0, 70, 164, 375, 1, 1, 1, 'Profession equipment (Blacksmithing): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608730, 15, 0, -1, 'Proficient Leatherworker''s Awl', 6440, 2, 1, 5000, 1250, 0, 10, 165, 1, 1, 1, 1, 'Profession equipment (Leatherworking): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608731, 15, 0, -1, 'Proficient Leatherworking Apron', 13117, 2, 1, 2500, 625, 0, 10, 165, 1, 1, 1, 1, 'Profession equipment (Leatherworking): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608732, 15, 0, -1, 'Expert Leatherworker''s Awl', 6440, 3, 1, 100000, 25000, 0, 60, 165, 300, 1, 1, 1, 'Profession equipment (Leatherworking): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608733, 15, 0, -1, 'Expert Leatherworking Apron', 13117, 3, 1, 50000, 12500, 0, 60, 165, 300, 1, 1, 1, 'Profession equipment (Leatherworking): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608734, 15, 0, -1, 'Master Leatherworker''s Awl', 6440, 4, 1, 500000, 125000, 0, 70, 165, 375, 1, 1, 1, 'Profession equipment (Leatherworking): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608735, 15, 0, -1, 'Master Leatherworking Apron', 13117, 4, 1, 250000, 62500, 0, 70, 165, 375, 1, 1, 1, 'Profession equipment (Leatherworking): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608736, 15, 0, -1, 'Proficient Alchemist''s Alembic', 8025, 2, 1, 5000, 1250, 0, 10, 171, 1, 1, 1, 1, 'Profession equipment (Alchemy): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608737, 15, 0, -1, 'Proficient Alchemist''s Goggles', 19399, 2, 1, 2500, 625, 0, 10, 171, 1, 1, 1, 1, 'Profession equipment (Alchemy): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608738, 15, 0, -1, 'Expert Alchemist''s Alembic', 8025, 3, 1, 100000, 25000, 0, 60, 171, 300, 1, 1, 1, 'Profession equipment (Alchemy): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608739, 15, 0, -1, 'Expert Alchemist''s Goggles', 19399, 3, 1, 50000, 12500, 0, 60, 171, 300, 1, 1, 1, 'Profession equipment (Alchemy): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608740, 15, 0, -1, 'Master Alchemist''s Alembic', 8025, 4, 1, 500000, 125000, 0, 70, 171, 375, 1, 1, 1, 'Profession equipment (Alchemy): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608741, 15, 0, -1, 'Master Alchemist''s Goggles', 19399, 4, 1, 250000, 62500, 0, 70, 171, 375, 1, 1, 1, 'Profession equipment (Alchemy): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608742, 15, 0, -1, 'Proficient Tailor''s Needle Set', 25048, 2, 1, 5000, 1250, 0, 10, 197, 1, 1, 1, 1, 'Profession equipment (Tailoring): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608743, 15, 0, -1, 'Proficient Tailor''s Thimble', 14432, 2, 1, 2500, 625, 0, 10, 197, 1, 1, 1, 1, 'Profession equipment (Tailoring): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608744, 15, 0, -1, 'Expert Tailor''s Needle Set', 25048, 3, 1, 100000, 25000, 0, 60, 197, 300, 1, 1, 1, 'Profession equipment (Tailoring): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608745, 15, 0, -1, 'Expert Tailor''s Thimble', 14432, 3, 1, 50000, 12500, 0, 60, 197, 300, 1, 1, 1, 'Profession equipment (Tailoring): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608746, 15, 0, -1, 'Master Tailor''s Needle Set', 25048, 4, 1, 500000, 125000, 0, 70, 197, 375, 1, 1, 1, 'Profession equipment (Tailoring): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608747, 15, 0, -1, 'Master Tailor''s Thimble', 14432, 4, 1, 250000, 62500, 0, 70, 197, 375, 1, 1, 1, 'Profession equipment (Tailoring): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608748, 15, 0, -1, 'Proficient Multitool', 7494, 2, 1, 5000, 1250, 0, 10, 202, 1, 1, 1, 1, 'Profession equipment (Engineering): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608749, 15, 0, -1, 'Proficient Engineer''s Goggles', 19409, 2, 1, 2500, 625, 0, 10, 202, 1, 1, 1, 1, 'Profession equipment (Engineering): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608750, 15, 0, -1, 'Expert Multitool', 7494, 3, 1, 100000, 25000, 0, 60, 202, 300, 1, 1, 1, 'Profession equipment (Engineering): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608751, 15, 0, -1, 'Expert Engineer''s Goggles', 19409, 3, 1, 50000, 12500, 0, 60, 202, 300, 1, 1, 1, 'Profession equipment (Engineering): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608752, 15, 0, -1, 'Master Multitool', 7494, 4, 1, 500000, 125000, 0, 70, 202, 375, 1, 1, 1, 'Profession equipment (Engineering): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608753, 15, 0, -1, 'Master Engineer''s Goggles', 19409, 4, 1, 250000, 62500, 0, 70, 202, 375, 1, 1, 1, 'Profession equipment (Engineering): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608754, 15, 0, -1, 'Proficient Enchanter''s Rod', 21207, 2, 1, 5000, 1250, 0, 10, 333, 1, 1, 1, 1, 'Profession equipment (Enchanting): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608755, 15, 0, -1, 'Proficient Enchanter''s Focus', 14432, 2, 1, 2500, 625, 0, 10, 333, 1, 1, 1, 1, 'Profession equipment (Enchanting): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608756, 15, 0, -1, 'Expert Enchanter''s Rod', 21207, 3, 1, 100000, 25000, 0, 60, 333, 300, 1, 1, 1, 'Profession equipment (Enchanting): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608757, 15, 0, -1, 'Expert Enchanter''s Focus', 14432, 3, 1, 50000, 12500, 0, 60, 333, 300, 1, 1, 1, 'Profession equipment (Enchanting): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608758, 15, 0, -1, 'Master Enchanter''s Rod', 21207, 4, 1, 500000, 125000, 0, 70, 333, 375, 1, 1, 1, 'Profession equipment (Enchanting): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608759, 15, 0, -1, 'Master Enchanter''s Focus', 14432, 4, 1, 250000, 62500, 0, 70, 333, 375, 1, 1, 1, 'Profession equipment (Enchanting): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608760, 15, 0, -1, 'Proficient Jeweler''s Loupe', 33224, 2, 1, 5000, 1250, 0, 10, 755, 1, 1, 1, 1, 'Profession equipment (Jewelcrafting): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608761, 15, 0, -1, 'Proficient Jeweler''s Goggles', 19399, 2, 1, 2500, 625, 0, 10, 755, 1, 1, 1, 1, 'Profession equipment (Jewelcrafting): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608762, 15, 0, -1, 'Expert Jeweler''s Loupe', 33224, 3, 1, 100000, 25000, 0, 60, 755, 300, 1, 1, 1, 'Profession equipment (Jewelcrafting): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608763, 15, 0, -1, 'Expert Jeweler''s Goggles', 19399, 3, 1, 50000, 12500, 0, 60, 755, 300, 1, 1, 1, 'Profession equipment (Jewelcrafting): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608764, 15, 0, -1, 'Master Jeweler''s Loupe', 33224, 4, 1, 500000, 125000, 0, 70, 755, 375, 1, 1, 1, 'Profession equipment (Jewelcrafting): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608765, 15, 0, -1, 'Master Jeweler''s Goggles', 19399, 4, 1, 250000, 62500, 0, 70, 755, 375, 1, 1, 1, 'Profession equipment (Jewelcrafting): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608766, 15, 0, -1, 'Proficient Scribe''s Quill', 57293, 2, 1, 5000, 1250, 0, 10, 773, 1, 1, 1, 1, 'Profession equipment (Inscription): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608767, 15, 0, -1, 'Proficient Scribe''s Spectacles', 13236, 2, 1, 2500, 625, 0, 10, 773, 1, 1, 1, 1, 'Profession equipment (Inscription): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608768, 15, 0, -1, 'Expert Scribe''s Quill', 57293, 3, 1, 100000, 25000, 0, 60, 773, 300, 1, 1, 1, 'Profession equipment (Inscription): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608769, 15, 0, -1, 'Expert Scribe''s Spectacles', 13236, 3, 1, 50000, 12500, 0, 60, 773, 300, 1, 1, 1, 'Profession equipment (Inscription): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608770, 15, 0, -1, 'Master Scribe''s Quill', 57293, 4, 1, 500000, 125000, 0, 70, 773, 375, 1, 1, 1, 'Profession equipment (Inscription): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608771, 15, 0, -1, 'Master Scribe''s Spectacles', 13236, 4, 1, 250000, 62500, 0, 70, 773, 375, 1, 1, 1, 'Profession equipment (Inscription): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608772, 15, 0, -1, 'Proficient Chef''s Cleaver', 4720, 2, 1, 5000, 1250, 0, 10, 185, 1, 1, 1, 1, 'Profession equipment (Cooking): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608773, 15, 0, -1, 'Proficient Chef''s Hat', 13236, 2, 1, 2500, 625, 0, 10, 185, 1, 1, 1, 1, 'Profession equipment (Cooking): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608774, 15, 0, -1, 'Expert Chef''s Cleaver', 4720, 3, 1, 100000, 25000, 0, 60, 185, 300, 1, 1, 1, 'Profession equipment (Cooking): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608775, 15, 0, -1, 'Expert Chef''s Hat', 13236, 3, 1, 50000, 12500, 0, 60, 185, 300, 1, 1, 1, 'Profession equipment (Cooking): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608776, 15, 0, -1, 'Master Chef''s Cleaver', 4720, 4, 1, 500000, 125000, 0, 70, 185, 375, 1, 1, 1, 'Profession equipment (Cooking): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608777, 15, 0, -1, 'Master Chef''s Hat', 13236, 4, 1, 250000, 62500, 0, 70, 185, 375, 1, 1, 1, 'Profession equipment (Cooking): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0),
(608778, 15, 0, -1, 'Proficient Field Surgeon''s Kit', 11907, 2, 1, 5000, 1250, 0, 10, 129, 1, 1, 1, 1, 'Profession equipment (First Aid): +5 skill, Multicraft +3%, Resourcefulness +3%. Wear it with .profgear or the profession panel.', 1, 0),
(608779, 15, 0, -1, 'Proficient Surgeon''s Gloves', 7348, 2, 1, 2500, 625, 0, 10, 129, 1, 1, 1, 1, 'Profession equipment (First Aid): +3 skill, Multicraft +1%, Resourcefulness +1%. Wear it with .profgear or the profession panel.', 1, 0),
(608780, 15, 0, -1, 'Expert Field Surgeon''s Kit', 11907, 3, 1, 100000, 25000, 0, 60, 129, 300, 1, 1, 1, 'Profession equipment (First Aid): +10 skill, Multicraft +5%, Resourcefulness +5%. Wear it with .profgear or the profession panel.', 1, 0),
(608781, 15, 0, -1, 'Expert Surgeon''s Gloves', 7348, 3, 1, 50000, 12500, 0, 60, 129, 300, 1, 1, 1, 'Profession equipment (First Aid): +6 skill, Multicraft +2%, Resourcefulness +2%. Wear it with .profgear or the profession panel.', 1, 0),
(608782, 15, 0, -1, 'Master Field Surgeon''s Kit', 11907, 4, 1, 500000, 125000, 0, 70, 129, 375, 1, 1, 1, 'Profession equipment (First Aid): +15 skill, Multicraft +8%, Resourcefulness +8%. Wear it with .profgear or the profession panel.', 1, 0),
(608783, 15, 0, -1, 'Master Surgeon''s Gloves', 7348, 4, 1, 250000, 62500, 0, 70, 129, 375, 1, 1, 1, 'Profession equipment (First Aid): +8 skill, Multicraft +4%, Resourcefulness +4%. Wear it with .profgear or the profession panel.', 1, 0);

-- sold by the vendors who sell each profession's basic supplies (Coarse Thread, Mining Pick, Skinning Knife...)
DELETE FROM `npc_vendor` WHERE `item` BETWEEN 608700 AND 608783;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608700, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608701, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608702, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608703, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608704, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608705, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608706, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608707, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608708, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608709, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608710, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608711, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608712, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608713, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608714, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608715, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608716, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608717, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 7005;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608718, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608719, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608720, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608721, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608722, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608723, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6256;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608724, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608725, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608726, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608727, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608728, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608729, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2901;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608730, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608731, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608732, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608733, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608734, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608735, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608736, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608737, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608738, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608739, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608740, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608741, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 3371;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608742, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608743, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608744, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608745, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608746, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608747, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2320;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608748, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608749, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608750, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608751, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608752, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608753, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2880;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608754, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608755, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608756, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608757, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608758, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608759, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 6217;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608760, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608761, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608762, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608763, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608764, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608765, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 20815;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608766, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608767, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608768, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608769, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608770, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608771, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 39354;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608772, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608773, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608774, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608775, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608776, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608777, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2678;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608778, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608779, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608780, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608781, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608782, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, 608783, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = 2589;
