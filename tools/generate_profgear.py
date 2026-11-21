#!/usr/bin/env python3
"""Writes mod_temucraft_professions_profgear.sql: the profession equipment table (existing tools count as tools)
and a tool plus an accessory per profession in three tiers: Proficient (Classic, skill 1), Expert (Outland,
skill 300) and Master (Northrend, skill 375). Items 608700 and up; sold by the profession's trainers' vendors."""
import sys
# skill, profession, gathering?, tool (name, display), accessory (name, display)
P = [
    (182, 'Herbalism', 1, ("Herbalist's Sickle", 7393), ("Herbalist's Gloves", 7348)),
    (186, 'Mining', 1, ("Pickaxe", 6568), ("Miner's Helmet", 23161)),
    (393, 'Skinning', 1, ("Skinning Knife", 6440), ("Skinner's Gloves", 17176)),
    (356, 'Fishing', 1, ("Tackle Box", 4720), ("Angler's Hat", 13236)),
    (164, 'Blacksmithing', 0, ("Smithing Hammer", 8568), ("Smithing Apron", 13117)),
    (165, 'Leatherworking', 0, ("Leatherworker's Awl", 6440), ("Leatherworking Apron", 13117)),
    (171, 'Alchemy', 0, ("Alchemist's Alembic", 8025), ("Alchemist's Goggles", 19399)),
    (197, 'Tailoring', 0, ("Tailor's Needle Set", 25048), ("Tailor's Thimble", 14432)),
    (202, 'Engineering', 0, ("Multitool", 7494), ("Engineer's Goggles", 19409)),
    (333, 'Enchanting', 0, ("Enchanter's Rod", 21207), ("Enchanter's Focus", 14432)),
    (755, 'Jewelcrafting', 0, ("Jeweler's Loupe", 33224), ("Jeweler's Goggles", 19399)),
    (773, 'Inscription', 0, ("Scribe's Quill", 57293), ("Scribe's Spectacles", 13236)),
    (185, 'Cooking', 0, ("Chef's Cleaver", 4720), ("Chef's Hat", 13236)),
    (129, 'First Aid', 0, ("Field Surgeon's Kit", 11907), ("Surgeon's Gloves", 7348)),
]
TIERS = [('Proficient', 1, 10, 2, 5, 3), ('Expert', 300, 60, 3, 10, 5), ('Master', 375, 70, 4, 15, 8)]   # name, skill, ilvl, quality, +skill, stat%
EXISTING = [  # existing tools: item, skill, finesse, perception, deftness, multicraft, resourcefulness, +skill
    (2901, 186, 5, 0, 0, 0, 0, 0), (7005, 393, 5, 0, 0, 0, 0, 0), (40772, 0, 5, 0, 10, 0, 5, 0), (15138, 393, 10, 5, 10, 0, 0, 0),
    (19901, 393, 10, 5, 10, 0, 0, 0), (608100, 182, 5, 0, 10, 0, 0, 0), (608101, 186, 10, 5, 10, 0, 0, 0), (608102, 393, 10, 5, 10, 0, 0, 0),
    (5956, 164, 0, 0, 0, 0, 5, 0), (40892, 164, 0, 0, 0, 0, 5, 0), (40893, 164, 0, 0, 0, 0, 5, 0), (6219, 202, 0, 0, 0, 0, 5, 0),
    (10498, 202, 0, 0, 0, 5, 5, 0), (20815, 755, 0, 0, 0, 5, 5, 0), (39505, 773, 0, 0, 0, 5, 5, 0), (6218, 333, 0, 0, 0, 0, 2, 0),
    (6339, 333, 0, 0, 0, 0, 3, 0), (11130, 333, 0, 0, 0, 0, 4, 0), (11145, 333, 0, 0, 0, 0, 5, 0), (16207, 333, 0, 0, 0, 5, 6, 0),
    (22461, 333, 0, 0, 0, 5, 7, 0), (22462, 333, 0, 0, 0, 5, 8, 0), (22463, 333, 0, 0, 0, 10, 9, 0), (44452, 333, 0, 0, 0, 10, 10, 0),
    (608103, 197, 0, 0, 0, 5, 10, 0), (608104, 165, 0, 0, 0, 5, 10, 0), (608105, 185, 0, 0, 0, 10, 5, 0),
]
def q(s): return "'" + s.replace("'", "''") + "'"
gear, items, vend = [], [], []
for item, skill, fi, pe, de, mu, re_, sk in EXISTING:
    gear.append(f"({item}, {skill}, 0, {sk}, {fi}, {pe}, {de}, {mu}, {re_}, 'existing tool')")
entry = 608700
for skill, prof, gathering, tool, acc in P:
    for tname, rskill, ilvl, quality, plus, pct in TIERS:
        for kind, (base, disp) in enumerate((tool, acc)):
            name = f"{tname} {base}"
            stat_pct = pct if kind == 0 else max(1, pct // 2)
            bonus = plus if kind == 0 else plus // 2 + 1
            if gathering:
                st = (stat_pct, stat_pct // 2, stat_pct, 0, 0)
                desc = f"Profession equipment ({prof}): +{bonus} skill, Finesse +{st[0]}%, Perception +{st[1]}%, Deftness +{st[2]}%."
            else:
                st = (0, 0, 0, stat_pct, stat_pct)
                desc = f"Profession equipment ({prof}): +{bonus} skill, Multicraft +{st[3]}%, Resourcefulness +{st[4]}%."
            desc += " Wear it with .temucraft profgear or the profession panel."
            gear.append(f"({entry}, {skill}, {kind}, {bonus}, {st[0]}, {st[1]}, {st[2]}, {st[3]}, {st[4]}, {q(name)})")
            price = {1: 2500, 300: 50000, 375: 250000}[rskill] * (2 if kind == 0 else 1)
            items.append(f"({entry}, 15, 0, -1, {q(name)}, {disp}, {quality}, 1, {price}, {price // 4}, 0, {ilvl}, {skill}, {rskill}, 1, 1, 1, {q(desc)}, 1, 0)")
            vend.append((entry, skill))
            entry += 1
with open(sys.argv[1], 'w') as o:
    o.write("-- mod-temucraft-professions: profession equipment (tools/generate_profgear.py). Re-runnable.\n")
    o.write("-- Kind: 0 tool, 1 accessory. Skill 0 = any profession. Stats in percent; SkillBonus raises the profession while worn.\n")
    o.write("""CREATE TABLE IF NOT EXISTS `mod_temucraft_profgear_item` (
  `ItemID` int unsigned NOT NULL, `Skill` smallint unsigned NOT NULL DEFAULT 0, `Kind` tinyint unsigned NOT NULL DEFAULT 0,
  `SkillBonus` smallint NOT NULL DEFAULT 0, `Finesse` tinyint NOT NULL DEFAULT 0, `Perception` tinyint NOT NULL DEFAULT 0,
  `Deftness` tinyint NOT NULL DEFAULT 0, `Multicraft` tinyint NOT NULL DEFAULT 0, `Resourcefulness` tinyint NOT NULL DEFAULT 0,
  `Comment` varchar(100) NOT NULL DEFAULT '', PRIMARY KEY (`ItemID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mod-temucraft-professions: profession equipment';
DELETE FROM `mod_temucraft_profgear_item`;
INSERT INTO `mod_temucraft_profgear_item` (`ItemID`, `Skill`, `Kind`, `SkillBonus`, `Finesse`, `Perception`, `Deftness`, `Multicraft`, `Resourcefulness`, `Comment`) VALUES
""" + ",\n".join(gear) + ";\n\n")
    o.write(f"DELETE FROM `item_template` WHERE `entry` BETWEEN 608700 AND {entry - 1};\n")
    o.write("INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `ItemLevel`, `RequiredSkill`, `RequiredSkillRank`, `maxcount`, `stackable`, `bonding`, `description`, `Material`, `VerifiedBuild`) VALUES\n")
    o.write(",\n".join(items) + ";\n\n")
    o.write("-- sold by the vendors who sell each profession's basic supplies (Coarse Thread, Mining Pick, Skinning Knife...)\n")
    o.write(f"DELETE FROM `npc_vendor` WHERE `item` BETWEEN 608700 AND {entry - 1};\n")
    supply = {182: 2901, 186: 2901, 393: 7005, 356: 6256, 164: 2901, 165: 2320, 171: 3371, 197: 2320, 202: 2880, 333: 6217, 755: 20815, 773: 39354, 185: 2678, 129: 2589}
    for e, skill in vend:
        o.write(f"INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) SELECT DISTINCT `entry`, 0, {e}, 0, 0, 0, 0 FROM `npc_vendor` WHERE `item` = {supply[skill]};\n")
print(entry - 608700, "new items")
