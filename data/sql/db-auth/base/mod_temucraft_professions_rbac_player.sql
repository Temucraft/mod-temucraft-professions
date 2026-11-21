-- mod-temucraft-professions: its player commands (all under .temucraft) as RBAC permissions 102750-102799. Linked to the stock player
-- role 195 and the Temucraft player role 1010, so every account has them by default. To take one away, remove its
-- link here (or deny it per account with .rbac account deny <account> <id>); to give it to staff only, link it to
-- 1011-1014 instead.
DELETE FROM `rbac_linked_permissions` WHERE `linkedId` BETWEEN 102750 AND 102799;
DELETE FROM `rbac_permissions` WHERE `id` BETWEEN 102750 AND 102799;
INSERT INTO `rbac_permissions` (`id`, `name`) VALUES
(102750, 'Command: temucraft knowledge'),
(102751, 'Command: temucraft profgear'),
(102752, 'Command: temucraft repairall'),
(102753, 'Command: temucraft recraft');
INSERT INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
(195, 102750),
(1010, 102750),
(195, 102751),
(1010, 102751),
(195, 102752),
(1010, 102752),
(195, 102753),
(1010, 102753);
