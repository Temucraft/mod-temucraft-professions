# mod-temucraft-professions

Professions for Temucraft: later-expansion profession systems (gathering and crafting stats, knowledge, specializations, quality, recrafting, profession gear) and the profession perks (something for every profession from the first skill point).

Before: mod-temucraft-professions, mod-temucraft-profession-perks. Their tables, SQL file names, texts (`module_string` rows under their old names), settings and addon prefixes are unchanged, so an existing server only swaps the folders.

## From mod-temucraft-professions


Profession systems from later expansions, built for 3.3.5. Phase 1: **gathering stats**. Phase 2: **crafting stats**. Phase 3: **knowledge, specializations, concentration, quality and recrafting**.

| Stat | Effect |
|---|---|
| Finesse | chance for each gathered stack (ore, herbs, leather, fish) to come with half again as much |
| Perception | chance to also find a rare reagent that fits the node: gems from ore, rare herbs, rare hides |
| Deftness | shorter mining, herb gathering and skinning casts |

**Tools** give the stats while they are in your bags or equipped, so they never take a gear slot. Each tool helps
one gathering skill (or all). Existing tools now count (Mining Pick, Skinning Knife, Gnomish Army Knife, Finkle's
Skinner, Zulian Slicer, fishing poles) and three new ones are sold wherever Mining Picks are: Herbalist's Sickle,
Prospector's Pick and Keen Skinning Knife. The stats are written in each new tool's description.

- `mod_temucraft_gathering_tool`: item, skill (182 Herbalism, 186 Mining, 393 Skinning, 356 Fishing, 0 all), stats.
- `mod_temucraft_gathering_rare`: rare reagents per skill and node level (gems per ore tier, Wildvine, Black Lotus,
  Fel Lotus, Frost Lotus, rare leathers and scales).
- Deftness uses a hidden server-side aura (spell 95420) whose cast-time bonus only reaches gathering spells.

### Crafting stats

| Stat | Effect |
|---|---|
| Multicraft | chance for a craft of stackable goods (potions, food, bandages, gems, thread, ammo) to make extra |
| Resourcefulness | chance, for each kind of reagent, to get 30% of it back (at least 1) |

They come from **tools** carried in your bags or equipped (Blacksmith Hammer, Arclight Spanner, Gyromatic
Micro-Adjustor, Philosopher's and Alchemist's Stones, Jeweler's Kit, Virtuoso Inking Set, the runed enchanting rods,
Gnomish Army Knife for every craft) and three new ones sold wherever Coarse Thread is: Tailor's Needle Set,
Leatherworker's Awl and Chef's Spice Pouch. **Mastery** adds up to 10% of each as your skill climbs from a recipe's
yellow rank to its grey rank. Table: `mod_temucraft_crafting_tool`.

### Profession equipment

Each profession has three slots kept by the server, apart from bags and gear: a **tool** and two **accessories**.
Wearing an item takes it out of your bags (its enchantments, creator, durability and crafted quality are kept);
taking it off gives the same item back. Worn equipment adds profession **skill** and the gathering or crafting stats.

- `.temucraft profgear` opens a menu; the **TemucraftProfGear** addon (`client/AddOns`) adds a **Professions** tab to the
  character window (`/profgear`): alt-right-click equipment in your bags to wear it, right-click a slot to take it off.
- Equipment: `mod_temucraft_profgear_item`. The existing tools count as tools, plus a tool and an accessory per
  profession in three tiers: Proficient (skill 1), Expert (300) and Master (375), sold by the vendors who sell each
  profession's supplies (`tools/generate_profgear.py`, items 608700-608783).
- Worn items: `mod_temucraft_profgear` (characters).

### Knowledge, specializations and concentration

Each profession earns **knowledge**: the first craft of each recipe (+1), the first time you gather each kind of item
(+1) and every 75 skill points (+3, counted for skill you already have). `.temucraft knowledge` opens a menu to spend it on
three **specializations** per profession, 10 ranks each, +2% per rank:

- gathering: Fine Touch (Finesse), Keen Eye (Perception), Swift Hands (Deftness)
- crafting: Mass Production (Multicraft), Thrift (Resourcefulness), Deep Focus (cheaper concentration, bigger pool)

Points can be taken back for free. **Concentration** is a pool per crafting profession (1000, +20 an hour, offline
too). Switched on in the same menu, each craft spends 50 and its Multicraft and Resourcefulness rolls all succeed.
Tables (characters): `mod_temucraft_knowledge`, `_first`, `_spec`, `mod_temucraft_concentration`.

### Quality and recrafting

Gear you craft gets a **quality rank**, 1 (Rough) to 5 (Masterwork): from how far your skill is past the recipe's
yellow rank, a little luck, and concentration (always 5). The client can't show quality icons, so quality works
through the random enchantment: it is rolled as many times as the rank and the strongest is kept. `.temucraft recraft <item>`
crafts a piece you made again for half its reagents with your current skill, keeping the better result. Table
(characters): `mod_temucraft_crafted_item`.

Crafted random enchantments (the other half of phase 1) are SQL in configuration-main
(`2026_11_17_06_crafted_random_enchants.sql`).

SQL: `data/sql/db-world/base`. Settings: `conf/mod-temucraft-professions.conf.dist`. No client changes.

### Texts and translations

The 19 player-facing texts (chat messages, gossip options) are in the `module_string` table under the module name
`mod-temucraft-professions`, so they can be changed without rebuilding. Translations go in `module_string_locale` with the same
module and id plus the locale (`deDE`, `esES`, `frFR`, ...). If a row is missing the English text in the code is used.

## From mod-temucraft-profession-perks


Something for every profession from the first skill points on, growing with the skill, so a profession is worth
keeping up while levelling. Each perk only works while the profession is known.

| Profession | Perk |
|---|---|
| Alchemy | **Mixology** for every alchemist from skill 1: all elixirs and flasks (not only the Northrend recipes you know) get their Mixology bonus and last twice as long |
| Blacksmithing | **Repair All**: `.temucraft repairall` mends all your gear for free; every 8 hours, 4 from skill 225, 2 from 375 |
| Mining | **Toughness**: +1% maximum health per 75 skill (6% at 450), on top of the stock stamina bonus |
| Skinning | **Beasts of the Wild**: +1% damage done to beasts per 75 skill, pets included |
| Tailoring | **Cloth Scavenging**: when cloth drops from a creature, a 25% chance for one more piece |

Everything is in the config (on/off per perk, skill steps, percentages, cooldowns). Elixirs the stock Mixology already
covers (Mixology learned and the recipe known) are left to it, so nothing is counted twice.

### Install

Copy the module into `modules/`, re-run CMake and build. The SQL in `data/sql` is applied by the module updater
(characters: `mod_temucraft_profession_perks`, last Repair All per character; world: texts).

### Works with other modules

Gathering and crafting stats, profession equipment and rare finds stay in mod-temucraft-professions; this module only
adds the per-profession perks above.

### Texts and translations

Player-facing texts are in `module_string` (module `mod-temucraft-profession-perks`); translations go in
`module_string_locale`.

Part of the Temucraft modules for AzerothCore 3.3.5a.

## Reagent bag

An extra bag for trade goods and reagents, kept by the server (the 3.3.5 client can't show a sixth bag slot). It sits
on the right of the profession equipment window (TemucraftProfGear addon, `/profgear` or the Professions tab on
the character window) as a bag grid.

- **Send reagents here** (per character, on by default): reagents you loot or craft go straight into it, with a chat
  line saying so (module_string 51).
- Click a stack to take it out, shift-click to take all of that item. Ctrl-right-click a reagent in your bags to put
  it in; **Deposit reagents** moves every reagent from your bags.
- The trade skill window gets a **Reagent bag** button: it takes what the selected recipe needs (times the number in
  the box) out into your bags, then Create works as usual.
- Without the addon: `.temucraft profgear` -> Reagent bag.
- **Tabs** (`Temucraft.ReagentBag.Tabs`, up to 4): tab 1 is free; the next tab is unlocked per character for gold
  (`TabGold`, 10 / 50 / 250) or by giving up an empty bag of `TabBagSlots` (12) or more (ctrl-alt-click it in your bags),
  also from `.temucraft profgear` -> Reagent bag. Character setting `reagenttabs`.
- Each tab holds `Temucraft.ReagentBag.Slots` stacks (28) of stackable trade goods, reagents and misc reagents (not limited or
  timed items). Tables `mod_temucraft_reagent_bag` and `mod_temucraft_character_setting` (setting `reagentbag`) (characters).

## Treasures, herbs and ore

`src/TemucraftTreasures.cpp`, settings `Temucraft.Treasures.*`:

- Chests and other objects opened with the generic "Opening" spells (3365, 6477, 6478, 22810, 26868) open at once.
  The release patch-T Spell.dbc has them instant too, so the cast bar matches. Battleground captures (21651, 8 s)
  and special quest objects (5 s) are not changed.
- Treasure chests always show on the minimap, and herbs and ore veins too: the tracking bits of Find Herbs, Find
  Minerals and Find Treasure are kept on (put back each second if a tracking change clears them).
  `Temucraft.Treasures.Minimap`: 2 (default) herbs only for players with Herbalism and ore only for players with
  Mining; 1 both for everyone (the old behaviour); 0 off (only the normal tracking spells).
- They sparkle in the world, like quest objects, for players within 80 yards. The server tells each client this
  for the objects it can see (their dynamic flags); nothing changes in the database.
- Dwarves: Treasure Finding is no longer a tracking spell everyone has for free. Dwarves get 20% more gold from any
  loot and 50% more from treasure chests. The spell's text in patch-T says so.

## Profession slots

- Every character can learn `Temucraft.ProfessionSlots.Base` (2) primary professions.
- More are unlocked one at a time, up to `MaxPrimaryTradeSkill` in worldserver.conf (set it to **11** for every
  profession). The server decides how: add the script to any spell, for example an item's spell or a quest reward spell:
  `INSERT INTO spell_script_names (spell_id, ScriptName) VALUES (<spell>, 'spell_temucraft_profession_slot');`
  Each cast gives one more slot (the cast fails with a message when the character has them all).
- GMs: `.temucraft profslots` shows the selected player's slots; `add`, `remove`, `set <n>` change the unlocked ones.
- SQL: `mod_temucraft_profession_slots` (characters). RBAC 102754.
