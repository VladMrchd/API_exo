-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 30 déc. 2022 à 17:10
-- Version du serveur :  8.0.31-0ubuntu0.20.04.1
-- Version de PHP : 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cocktails-api`
--

DELIMITER $$
--
-- Fonctions
--
CREATE FUNCTION `isAlcoolise` (`idCocktail` INT) RETURNS INT 
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE resultat INT;
  SET resultat = 0;
  SET resultat = (SELECT COUNT(c.id) FROM `cocktails_composants` c INNER JOIN  cocktails_ingredients i ON c.idIngredient = i.id WHERE i.alcoolise=1 AND c.idCocktail = idCocktail); 
  RETURN resultat;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `cocktails_cocktails`
--

CREATE TABLE `cocktails_cocktails` (
  `id` int NOT NULL,
  `nom` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `idUser` int NOT NULL,
  `alcoolise` tinyint(1) NOT NULL DEFAULT '0',
  `commentaires` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `cocktails_cocktails`
--

INSERT INTO `cocktails_cocktails` (`id`, `nom`, `idUser`, `alcoolise`, `commentaires`) VALUES
(9, 'bora bora', 2, 0, 'bora-bora'),
(10, 'cocktail pétillant aux fraises', 2, 0, 'cocktail aux fraises'),
(11, 'side-car', 1, 1, 'side-car'),
(12, 'ti punch aux agrumes', 1, 1, 'ti-punch'),
(13, 'whisky-coca', 1, 1, 'whisky-coca');

-- --------------------------------------------------------

--
-- Structure de la table `cocktails_composants`
--

CREATE TABLE `cocktails_composants` (
  `id` int NOT NULL,
  `idCocktail` int NOT NULL,
  `idIngredient` int NOT NULL,
  `quantite` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `cocktails_composants`
--

INSERT INTO `cocktails_composants` (`id`, `idCocktail`, `idIngredient`, `quantite`) VALUES
(1, 9, 7, '10'),
(2, 9, 8, '6'),
(3, 9, 9, '1'),
(4, 9, 10, '1'),
(5, 10, 11, '500'),
(6, 10, 12, '1'),
(7, 10, 13, '5'),
(8, 10, 14, '50'),
(9, 11, 15, '6'),
(10, 11, 16, '3'),
(11, 11, 9, '20'),
(12, 11, 18, NULL),
(18, 12, 19, 'un demi'),
(19, 12, 20, '1/4'),
(20, 12, 21, '2'),
(21, 12, 22, '3'),
(22, 12, 23, '1'),
(30, 12, 24, '6'),
(40, 13, 31, ''),
(41, 13, 32, '');

--
-- Déclencheurs `cocktails_composants`
--
DELIMITER $$
CREATE TRIGGER `delete_composants` AFTER DELETE ON `cocktails_composants` FOR EACH ROW UPDATE cocktails_cocktails SET alcoolise=(
  CASE 
    WHEN isAlcoolise(OLD.idCocktail) > 0 THEN 1
    ELSE 0
  END
) WHERE id=OLD.idCocktail
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_composants` AFTER INSERT ON `cocktails_composants` FOR EACH ROW UPDATE cocktails_cocktails SET alcoolise=1 WHERE isAlcoolise(NEW.idCocktail) > 0 AND id=NEW.idCocktail
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `cocktails_ingredients`
--

CREATE TABLE `cocktails_ingredients` (
  `id` int NOT NULL,
  `nom` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `unite` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'cl',
  `alcoolise` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `cocktails_ingredients`
--

INSERT INTO `cocktails_ingredients` (`id`, `nom`, `unite`, `alcoolise`) VALUES
(7, 'jus d\'ananas', 'cl', 0),
(8, 'jus de fruits de la passion', 'cl', 0),
(9, 'jus de citron', 'cl', 0),
(10, 'grenadine', 'cl', 0),
(11, 'fraises', 'g', 0),
(12, 'sucre roux', 'c. à soupe', 0),
(13, 'eau minérale gazeuse', 'cl', 0),
(14, 'limonade', 'cl', 0),
(15, 'cognac', 'cl', 1),
(16, 'liqueur d\'orange (Grand Marnier ou Cointreau)', 'cl', 1),
(18, 'glaçons', '', 0),
(19, 'citron-vert', '', 0),
(20, 'pamplemousse', '', 0),
(21, 'jus de citron vert', 'cl', 0),
(22, 'sirop de sucre de canne', 'cl', 0),
(23, 'cassonade', 'c. à café', 0),
(24, 'rhum', 'cl', 1),
(25, 'feuilles de menthe', '', 0),
(31, 'coca', '', 0),
(32, 'whisky', 'cl', 1);

-- --------------------------------------------------------

--
-- Structure de la table `cocktails_users`
--

CREATE TABLE `cocktails_users` (
  `id` int NOT NULL,
  `pseudo` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `pass` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `hash` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'hash'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `cocktails_users`
--

INSERT INTO `cocktails_users` (`id`, `pseudo`, `pass`, `hash`) VALUES
(1, 'tom', 'web', 'f1984b02879228d9cb04815ce5b0a723'),
(2, 'isa', 'bdd', 'b9edda3aacebbf26bdfb708540070c05');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `cocktails_cocktails`
--
ALTER TABLE `cocktails_cocktails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idUser` (`idUser`);

--
-- Index pour la table `cocktails_composants`
--
ALTER TABLE `cocktails_composants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idCocktail` (`idCocktail`),
  ADD KEY `idIngredient` (`idIngredient`);

--
-- Index pour la table `cocktails_ingredients`
--
ALTER TABLE `cocktails_ingredients`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cocktails_users`
--
ALTER TABLE `cocktails_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pseudo` (`pseudo`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `cocktails_cocktails`
--
ALTER TABLE `cocktails_cocktails`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `cocktails_composants`
--
ALTER TABLE `cocktails_composants`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT pour la table `cocktails_ingredients`
--
ALTER TABLE `cocktails_ingredients`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT pour la table `cocktails_users`
--
ALTER TABLE `cocktails_users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `cocktails_cocktails`
--
ALTER TABLE `cocktails_cocktails`
  ADD CONSTRAINT `cocktails_cocktails_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `cocktails_users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `cocktails_composants`
--
ALTER TABLE `cocktails_composants`
  ADD CONSTRAINT `cocktails_composants_ibfk_1` FOREIGN KEY (`idCocktail`) REFERENCES `cocktails_cocktails` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cocktails_composants_ibfk_2` FOREIGN KEY (`idIngredient`) REFERENCES `cocktails_ingredients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
