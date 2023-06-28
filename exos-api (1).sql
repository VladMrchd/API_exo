-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 28 juin 2023 à 15:25
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
-- Structure de la table `exos_composants`
--

DROP TABLE IF EXISTS `exos_composants`;
CREATE TABLE IF NOT EXISTS `exos_composants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCycle` int NOT NULL,
  `idExo` int NOT NULL,
  `quantite` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idCycle` (`idCycle`),
  KEY `idExo` (`idExo`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_composants`
--

INSERT INTO `exos_composants` (`id`, `idCycle`, `idExo`, `quantite`) VALUES
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
(41, 13, 32, ''),
(42, 12, 0, ''),
(43, 12, 0, ''),
(44, 12, 14, '');

-- --------------------------------------------------------

--
-- Structure de la table `exos_cycles`
--

DROP TABLE IF EXISTS `exos_cycles`;
CREATE TABLE IF NOT EXISTS `exos_cycles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `idUser` int NOT NULL,
  `commentaires` text,
  PRIMARY KEY (`id`),
  KEY `idUser` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_cycles`
--

INSERT INTO `exos_cycles` (`id`, `nom`, `idUser`, `commentaires`) VALUES
(9, 'haut du corps', 2, 'ca pique'),
(10, 'bas du corps', 2, 'aille'),
(11, 'dos', 1, 'ouille'),
(12, 'jambes', 1, 'jambes'),
(13, 'général', 1, 'mal partout');

-- --------------------------------------------------------

--
-- Structure de la table `exos_exercices`
--

DROP TABLE IF EXISTS `exos_exercices`;
CREATE TABLE IF NOT EXISTS `exos_exercices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `unite` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'rep',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_exercices`
--

INSERT INTO `exos_exercices` (`id`, `nom`, `unite`) VALUES
(7, 'pompe', 'rep'),
(8, 'abdo', 'rep'),
(9, 'squat', 'rep'),
(10, 'montée de genou', 'sec'),
(11, 'planche', 'sec'),
(12, 'pompe diamant', 'rep'),
(13, 'jumping jack', 'rep'),
(14, 'corde à sauter', 'rep'),
(15, 'burpee', 'rep'),
(16, 'traction', 'rep');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `exos_users`
--

INSERT INTO `exos_users` (`id`, `pseudo`, `pass`, `hash`) VALUES
(1, 'tom', 'web', 'f1984b02879228d9cb04815ce5b0a723'),
(2, 'isa', 'bdd', 'b9edda3aacebbf26bdfb708540070c05'),
(3, 'vlad', 'pmr', 'f1984b02879228d9cb04815ce5b0a723');

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `exos_cycles`
--
ALTER TABLE `exos_cycles`
  ADD CONSTRAINT `exos_cycles_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `exos_users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
