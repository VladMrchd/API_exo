-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 27 juin 2023 à 12:25
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `exos-api`
--

-- --------------------------------------------------------

--
-- Structure de la table `exos_cycles`
--

DROP TABLE IF EXISTS `exos_cycles`;
CREATE TABLE IF NOT EXISTS `exos_cycles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_cycle` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `idUser` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idUser` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_cycles`
--

INSERT INTO `exos_cycles` (`id`, `nom_cycle`, `idUser`) VALUES
(9, 'Bas du corps', 2),
(10, 'Bras', 2),
(11, 'Jambes', 1),
(12, 'Haut du corps', 1),
(13, 'Course', 1);

-- --------------------------------------------------------

--
-- Structure de la table `exos_exercices`
--

DROP TABLE IF EXISTS `exos_exercices`;
CREATE TABLE IF NOT EXISTS `exos_exercices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_exercices`
--

INSERT INTO `exos_exercices` (`id`, `nom`) VALUES
(1, 'pompe'),
(2, 'burpee'),
(34, 'squat');

-- --------------------------------------------------------

--
-- Structure de la table `exos_exocycle`
--

DROP TABLE IF EXISTS `exos_exocycle`;
CREATE TABLE IF NOT EXISTS `exos_exocycle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCycle` int NOT NULL,
  `idExercice` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idCocktail` (`idCycle`),
  KEY `idIngredient` (`idExercice`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `exos_users`
--

DROP TABLE IF EXISTS `exos_users`;
CREATE TABLE IF NOT EXISTS `exos_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pseudo` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `pass` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `hash` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'hash',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pseudo` (`pseudo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_users`
--

INSERT INTO `exos_users` (`id`, `pseudo`, `pass`, `hash`) VALUES
(1, 'tom', 'web', 'f1984b02879228d9cb04815ce5b0a723'),
(2, 'isa', 'bdd', 'b9edda3aacebbf26bdfb708540070c05'),
(5, 'vlad', 'pmr', 'd19df1c77ae420f4e26817e32e2bb5ed');

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `exos_cycles`
--
ALTER TABLE `exos_cycles`
  ADD CONSTRAINT `exercices_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `exos_users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `exos_exocycle`
--
ALTER TABLE `exos_exocycle`
  ADD CONSTRAINT `exos_exocycle_ibfk_1` FOREIGN KEY (`idCycle`) REFERENCES `exos_cycles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `exos_exocycle_ibfk_2` FOREIGN KEY (`idExercice`) REFERENCES `exos_exercices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
