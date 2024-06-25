-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 28, 2023 at 08:34 AM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smspanel`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `menu_id` int(11) NOT NULL,
  `menu_name` varchar(255) NOT NULL,
  `icon_class` varchar(255) DEFAULT NULL,
  `status` tinyint(4) NOT NULL,
  `notification` int(111) NOT NULL DEFAULT 0,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`menu_id`, `menu_name`, `icon_class`, `status`, `notification`, `edate`) VALUES
(1, 'Services', 'pe-7s-tools\r\n', 1, 0, '2020-07-14 17:00:00'),
(2, 'User Manipulation', 'pe-7s-id', 1, 0, '2020-07-14 03:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `permission`
--

CREATE TABLE `permission` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `sub_menu_id` int(11) DEFAULT NULL,
  `can_view` tinyint(4) NOT NULL,
  `added_by` varchar(255) DEFAULT NULL,
  `user_id` int(111) DEFAULT NULL,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`id`, `role_id`, `menu_id`, `sub_menu_id`, `can_view`, `added_by`, `user_id`, `edate`) VALUES
(207, 1, 2, 15, 1, 'admin', 2, '2023-08-26 00:00:00'),
(206, 1, 2, 3, 1, 'admin', 2, '2023-08-26 00:00:00'),
(205, 1, 1, 13, 1, 'admin', 2, '2023-08-26 00:00:00'),
(204, 1, 1, 14, 1, 'admin', 2, '2023-08-26 00:00:00'),
(202, 1, 1, 1, 1, 'admin', 2, '2023-08-26 00:00:00'),
(174, 2, 3, 8, 1, 'admin', 2, '2020-09-24 00:00:00'),
(173, 2, 3, 7, 1, 'admin', 2, '2020-09-24 00:00:00'),
(172, 2, 3, 6, 1, 'admin', 2, '2020-09-24 00:00:00'),
(123, 3, 1, NULL, 1, 'das', 1, '2020-07-29 00:00:00'),
(124, 3, 2, NULL, 1, 'das', 1, '2020-07-29 00:00:00'),
(125, 3, 3, NULL, 1, 'das', 1, '2020-07-29 00:00:00'),
(126, 3, 4, NULL, 1, 'das', 1, '2020-07-29 00:00:00'),
(127, 3, 1, 1, 1, 'das', 1, '2020-07-29 00:00:00'),
(128, 3, 1, 4, 1, 'das', 1, '2020-07-29 00:00:00'),
(129, 3, 2, 2, 1, 'das', 1, '2020-07-29 00:00:00'),
(130, 3, 2, 3, 1, 'das', 1, '2020-07-29 00:00:00'),
(131, 3, 3, 5, 1, 'das', 1, '2020-07-29 00:00:00'),
(132, 3, 3, 6, 1, 'das', 1, '2020-07-29 00:00:00'),
(133, 3, 3, 7, 1, 'das', 1, '2020-07-29 00:00:00'),
(134, 3, 3, 8, 1, 'das', 1, '2020-07-29 00:00:00'),
(208, 4, 2, NULL, 1, 'admin', 2, '2023-08-27 00:00:00'),
(171, 2, 3, 5, 1, 'admin', 2, '2020-09-24 00:00:00'),
(170, 2, 3, NULL, 1, 'admin', 2, '2020-09-24 00:00:00'),
(203, 1, 1, 4, 1, 'admin', 2, '2023-08-26 00:00:00'),
(201, 1, 2, NULL, 1, 'admin', 2, '2023-08-26 00:00:00'),
(200, 1, 1, NULL, 1, 'admin', 2, '2023-08-26 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `id` int(11) NOT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `service_type` varchar(50) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`id`, `service_name`, `service_type`, `keywords`, `created_at`) VALUES
(7, 'DJ Bravo', 'PPU', 'Virat Kholi', '2023-08-22 12:46:33'),
(8, 'World cup', 'Subscription', 'Fifa', '2023-08-22 12:46:38');

-- --------------------------------------------------------

--
-- Table structure for table `sms`
--

CREATE TABLE `sms` (
  `id` int(11) NOT NULL,
  `service_id` int(11) DEFAULT NULL,
  `service_type` varchar(255) NOT NULL,
  `sms` text DEFAULT NULL,
  `datetime` datetime DEFAULT current_timestamp(),
  `status` int(11) DEFAULT 1,
  `keywords` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sms`
--

INSERT INTO `sms` (`id`, `service_id`, `service_type`, `sms`, `datetime`, `status`, `keywords`) VALUES
(181, 8, 'Subscription', '\"To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.\" - Ralph Waldo Emerson', '2023-08-23 15:40:49', 1, 'Fifa'),
(182, 7, 'PPU', '\"Life is either a daring adventure or nothing at all.\" - Helen Keller', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(183, 7, 'PPU', '\"In three words I can sum up everything I\'ve learned about life: it goes on.\" - Robert Frost', '2023-08-23 17:11:36', 1, 'Fifa'),
(184, 7, 'PPU', '\"Be yourself; everyone else is already taken.\" - Oscar Wilde', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(185, 7, 'Subscription', '\"The only way to do great work is to love what you do.\" - Steve Jobs', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(186, 7, 'PPU', '\"The future belongs to those who believe in the beauty of their dreams.\" - Eleanor Roosevelt', '2023-08-23 17:11:36', 1, 'Fifa'),
(187, 7, 'Subscription', '\"In the middle of every difficulty lies opportunity.\" - Albert Einstein', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(188, 7, 'PPU', '\"Success is not final, failure is not fatal: It is the courage to continue that counts.\" - Winston Churchill', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(189, 7, 'PPU', '\"The only limit to our realization of tomorrow will be our doubts of today.\" - Franklin D. Roosevelt', '2023-08-23 17:11:36', 1, 'Fifa'),
(190, 7, 'Subscription', '\"Happiness is not something ready-made. It comes from your own actions.\" - Dalai Lama', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(191, 7, 'PPU', '\"To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.\" - Ralph Waldo Emerson', '2023-08-23 17:11:36', 1, 'Virat Kholi'),
(194, 7, 'PPU', 'have an amazing day', '2023-08-27 11:37:19', 1, 'Virat Kholi'),
(195, 7, 'PPU', 'HEllo', '2023-08-27 12:49:54', 1, 'Virat Kholi');

-- --------------------------------------------------------

--
-- Table structure for table `sub_menu`
--

CREATE TABLE `sub_menu` (
  `sub_menu_id` int(111) NOT NULL,
  `menu_id` int(111) NOT NULL,
  `sub_menu_name` varchar(255) DEFAULT NULL,
  `page_url` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `notification` int(111) NOT NULL DEFAULT 0,
  `added_by` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sub_menu`
--

INSERT INTO `sub_menu` (`sub_menu_id`, `menu_id`, `sub_menu_name`, `page_url`, `status`, `notification`, `added_by`, `user_id`, `edate`) VALUES
(1, 1, 'Add SMS', 'add_sms.php', 1, 0, 'das', NULL, '2020-07-14 17:00:00'),
(3, 2, 'Role Permission', 'add_role_permission.php', 1, 0, 'sanad', 1, '2023-08-22 11:23:50'),
(4, 1, 'Add Service', 'add_service.php', 1, 0, 'das', NULL, '2020-07-15 00:00:00'),
(14, 1, 'SMS List', 'all_sms.php', 1, 0, 'sanad', 1, '2023-08-22 12:58:28'),
(13, 1, 'Bulk Upload', 'add_excel.php', 1, 0, 'sanad', NULL, '2023-08-22 09:25:12');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user_name` varchar(35) NOT NULL,
  `first_name` varchar(35) DEFAULT NULL,
  `last_name` varchar(35) DEFAULT NULL,
  `company_id` int(111) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `user_role_id` int(111) NOT NULL,
  `status` tinyint(111) NOT NULL,
  `datetime` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_name`, `first_name`, `last_name`, `company_id`, `mobile`, `email`, `password`, `user_role_id`, `status`, `datetime`) VALUES
(1, 'das', 'shiba', 'das', 1, NULL, NULL, 'MTIz', 3, 1, '2019-09-24 00:00:00'),
(2, 'admin', 'admin', '', 1, NULL, NULL, 'MTIz', 1, 1, '2020-07-14 13:00:00'),
(3, 'mod', 'moderator', '', 1, '', '', 'MTIz', 2, 1, '2020-07-14 16:07:56'),
(7, 'demo_publisher', 'Demo', ' ', 1, '123', 'demo@gmail.com', 'MTIz', 4, 1, '2020-09-24 22:14:34'),
(8, 'demo_publisher2', 'Demo', '2', 1, '', '', 'MTIz', 4, 1, '2020-10-10 13:55:31');

-- --------------------------------------------------------

--
-- Table structure for table `user_role`
--

CREATE TABLE `user_role` (
  `id` int(11) NOT NULL,
  `role_name` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `core_id` tinyint(4) NOT NULL DEFAULT 0,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_role`
--

INSERT INTO `user_role` (`id`, `role_name`, `status`, `core_id`, `edate`) VALUES
(1, 'Admin', 1, 0, '2020-07-14 11:20:00'),
(2, 'Moderator', 1, 0, '2020-07-14 11:00:00'),
(3, 'Super Duper Admin', 1, 1, '2020-07-14 12:00:00'),
(4, 'Publisher', 1, 0, '2020-07-14 13:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indexes for table `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sms`
--
ALTER TABLE `sms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sub_menu`
--
ALTER TABLE `sub_menu`
  ADD PRIMARY KEY (`sub_menu_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_role`
--
ALTER TABLE `user_role`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `permission`
--
ALTER TABLE `permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `sms`
--
ALTER TABLE `sms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;

--
-- AUTO_INCREMENT for table `sub_menu`
--
ALTER TABLE `sub_menu`
  MODIFY `sub_menu_id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_role`
--
ALTER TABLE `user_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
