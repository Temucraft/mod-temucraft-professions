-- mod-temucraft-professions: its commands (all under .temucraft) as RBAC permissions 102750-102799. Every command is admin only by
-- default: linked to the administrator roles 192 and 1014. To give one to players, link it to 195 and 1010 here (or
-- grant it per account with .rbac account grant <account> <id>). "Temucraft: use ..." permissions are not
-- commands: they stay linked to the player roles so the items keep working.
DELETE FROM `rbac_linked_permissions` WHERE `linkedId` BETWEEN 102750 AND 102799;
DELETE FROM `rbac_permissions` WHERE `id` BETWEEN 102750 AND 102799;
INSERT INTO `rbac_permissions` (`id`, `name`) VALUES
(102750, 'Command: temucraft knowledge'),
(102751, 'Command: temucraft profgear'),
(102752, 'Command: temucraft repairall'),
(102753, 'Command: temucraft recraft'),
(102754, 'Command: temucraft profslots');
INSERT INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
(192, 102750),
(1014, 102750),
(192, 102751),
(1014, 102751),
(192, 102752),
(1014, 102752),
(192, 102753),
(1014, 102753),
(192, 102754),
(1014, 102754);
