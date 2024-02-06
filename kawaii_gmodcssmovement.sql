-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 06, 2024 at 01:08 AM
-- Server version: 5.7.41
-- PHP Version: 8.1.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kawaii_gmodcssmovement`
--

-- --------------------------------------------------------

--
-- Table structure for table `game_bots`
--

CREATE TABLE `game_bots` (
  `szMap` text NOT NULL,
  `szPlayer` text,
  `nTime` int(11) NOT NULL,
  `nStyle` int(11) NOT NULL,
  `szSteam` text NOT NULL,
  `szDate` int(11) DEFAULT NULL,
  `nFrame` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `game_map`
--

CREATE TABLE `game_map` (
  `szMap` text NOT NULL,
  `nMultiplier` int(11) NOT NULL DEFAULT '1',
  `nBonusMultiplier` int(11) DEFAULT NULL,
  `nPlays` int(11) NOT NULL DEFAULT '0',
  `nOptions` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `game_times`
--

CREATE TABLE `game_times` (
  `szUID` text NOT NULL,
  `szPlayer` text,
  `szMap` text NOT NULL,
  `nStyle` int(11) NOT NULL,
  `nTime` double NOT NULL,
  `nPoints` float NOT NULL,
  `vData` text,
  `szDate` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `game_zones`
--

CREATE TABLE `game_zones` (
  `szMap` text NOT NULL,
  `nType` int(11) NOT NULL,
  `vPos1` text,
  `vPos2` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_admins`
--

CREATE TABLE `gmod_admins` (
  `nID` int(11) NOT NULL,
  `szSteam` varchar(255) NOT NULL,
  `nLevel` int(11) NOT NULL DEFAULT '0',
  `nType` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gmod_admins`
--

INSERT INTO `gmod_admins` (`nID`, `szSteam`, `nLevel`, `nType`) VALUES
(1, 'STEAM_0:1:48688711', 64, 2),
(1, 'STEAM_0:1:48688711', 64, 2);

-- --------------------------------------------------------

--
-- Table structure for table `gmod_bans`
--

CREATE TABLE `gmod_bans` (
  `nID` int(11) NOT NULL,
  `szUserSteam` varchar(255) NOT NULL,
  `szUserName` varchar(255) DEFAULT NULL,
  `nStart` bigint(20) NOT NULL,
  `nLength` int(11) NOT NULL,
  `szReason` varchar(255) DEFAULT NULL,
  `szAdminSteam` varchar(255) NOT NULL,
  `szAdminName` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_donations`
--

CREATE TABLE `gmod_donations` (
  `nID` int(11) NOT NULL,
  `szEmail` varchar(255) NOT NULL,
  `szName` varchar(255) DEFAULT NULL,
  `szCountry` varchar(255) DEFAULT NULL,
  `nAmount` int(11) NOT NULL,
  `szSteam` varchar(255) DEFAULT NULL,
  `szDate` varchar(255) NOT NULL,
  `szStatus` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_logging`
--

CREATE TABLE `gmod_logging` (
  `nID` int(11) NOT NULL,
  `nType` int(11) NOT NULL DEFAULT '0',
  `szData` text,
  `szDate` varchar(255) DEFAULT NULL,
  `szAdminSteam` varchar(255) NOT NULL,
  `szAdminName` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_notifications`
--

CREATE TABLE `gmod_notifications` (
  `nID` int(11) NOT NULL,
  `nType` int(11) NOT NULL DEFAULT '0',
  `nTimeout` int(11) NOT NULL DEFAULT '60',
  `szText` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_radio`
--

CREATE TABLE `gmod_radio` (
  `nID` int(11) NOT NULL,
  `szUnique` varchar(255) NOT NULL,
  `nService` int(11) DEFAULT '0',
  `nTicket` int(11) DEFAULT '0',
  `szDate` varchar(255) NOT NULL,
  `nDuration` int(11) DEFAULT '0',
  `szTagTitle` varchar(255) NOT NULL DEFAULT '',
  `szTagArtist` varchar(255) NOT NULL DEFAULT '',
  `szRequester` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_radio_queue`
--

CREATE TABLE `gmod_radio_queue` (
  `nID` int(11) NOT NULL,
  `nTicket` int(11) NOT NULL,
  `nType` int(11) NOT NULL,
  `szDate` varchar(255) DEFAULT NULL,
  `szStatus` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gmod_vips`
--

CREATE TABLE `gmod_vips` (
  `nID` int(11) NOT NULL,
  `szSteam` varchar(255) NOT NULL,
  `nType` int(11) NOT NULL,
  `szTag` varchar(255) NOT NULL DEFAULT '',
  `szName` varchar(255) NOT NULL DEFAULT '',
  `szChat` varchar(255) NOT NULL DEFAULT '',
  `nStart` bigint(20) DEFAULT NULL,
  `nLength` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gmod_vips`
--

INSERT INTO `gmod_vips` (`nID`, `szSteam`, `nType`, `szTag`, `szName`, `szChat`, `nStart`, `nLength`) VALUES
(64, 'STEAM_0:1:48688711', 2, '8 155 155 kawaii', '256 0 0 fibz', 'test', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jac_log`
--

CREATE TABLE `jac_log` (
  `id` int(11) NOT NULL,
  `steamid` varchar(255) DEFAULT NULL,
  `name` text,
  `ip` text,
  `detectionid` text,
  `data` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
