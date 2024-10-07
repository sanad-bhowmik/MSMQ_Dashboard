-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 07, 2024 at 03:01 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shasthobdapi`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`jjupxrppwp`@`%` FUNCTION `get_url_path_of_category` (`categoryId` INT, `localeCode` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8 COLLATE utf8_general_ci  BEGIN

                DECLARE urlPath VARCHAR(255);

                IF NOT EXISTS (
                    SELECT id
                    FROM categories
                    WHERE
                        id = categoryId
                        AND parent_id IS NULL
                )
                THEN
                    SELECT
                        GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO urlPath
                    FROM
                        categories AS node,
                        categories AS parent
                        JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                    WHERE
                        node._lft >= parent._lft
                        AND node._rgt <= parent._rgt
                        AND node.id = categoryId
                        AND node.parent_id IS NOT NULL
                        AND parent.parent_id IS NOT NULL
                        AND parent_translations.locale = localeCode
                    GROUP BY
                        node.id;

                    IF urlPath IS NULL
                    THEN
                        SET urlPath = (SELECT slug FROM category_translations WHERE category_translations.category_id = categoryId);
                    END IF;
                 ELSE
                    SET urlPath = '';
                 END IF;

                 RETURN urlPath;
            END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(10) UNSIGNED NOT NULL,
  `address_type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'null if guest checkout',
  `cart_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'only for cart_addresses',
  `order_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'only for order_addresses',
  `first_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address1` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address2` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_address` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'only for customer_addresses',
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) DEFAULT NULL,
  `api_token` varchar(80) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `role_id` int(10) UNSIGNED NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `api_token`, `status`, `role_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Example', 'admin@example.com', '$2y$10$YAabEZFjNiIRha9SztgyzONGyXq0w.Uh35HWV6VshL45zZ3pD5xtW', 'IzqlGLzAzv6sufwXUQs1edJmBEXmkDeSmQI9UVb3QkMZWghQfxBKnWuuwhiFYyPjgc3Zyy4gbew4iTeT', 1, 1, NULL, '2020-10-08 08:45:13', '2021-03-07 06:49:10'),
(2, ' Dr. Khaled Al Mounsur', 'khaledalmounsur@gmail.com', '$2y$10$vbpkIJvNXiFhRHQUnevv8OAa40lOuZDNrl4vR9sDU0DJLYkQ0Hkty', 'ZxMovCOz7FMlrpPDZrvJKyGZ2kXB97usW3Jnq2EIq8lSiV2oPKUYYZMzt8d4dUvw9XK8ufuK2kT19Om9', 1, 1, NULL, '2020-10-20 06:09:10', '2020-10-20 06:09:10');

-- --------------------------------------------------------

--
-- Table structure for table `admin_password_resets`
--

CREATE TABLE `admin_password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `appointmentview`
--

CREATE TABLE `appointmentview` (
  `MYEDMXID` varchar(36) DEFAULT NULL,
  `OID` bigint(20) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `PatientID` varchar(50) DEFAULT NULL,
  `RelativeID` varchar(50) DEFAULT NULL,
  `DOCID` varchar(50) DEFAULT NULL,
  `Appointment_Time` varchar(50) DEFAULT NULL,
  `AppointmentDate` date DEFAULT NULL,
  `Created_at` datetime(3) DEFAULT NULL,
  `Updatedat` datetime(3) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `DocDegree` varchar(200) DEFAULT NULL,
  `BmdcReg` varchar(255) DEFAULT NULL,
  `DocName` varchar(200) DEFAULT NULL,
  `MobileNum` varchar(200) DEFAULT NULL,
  `PatientName` varchar(200) DEFAULT NULL,
  `ParientGender` varchar(200) DEFAULT NULL,
  `StartDuty` varchar(50) DEFAULT NULL,
  `EndDuty` varchar(50) DEFAULT NULL,
  `PatientPF` varchar(200) DEFAULT NULL,
  `DocType` varchar(200) DEFAULT NULL,
  `JsonTime` text DEFAULT NULL,
  `DayOfPractice` varchar(200) DEFAULT NULL,
  `DocImage` varchar(200) DEFAULT NULL,
  `Payment` varchar(200) DEFAULT NULL,
  `PatientMobile` varchar(200) DEFAULT NULL,
  `service_status` varchar(255) DEFAULT NULL,
  `txn_id` varchar(300) DEFAULT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `paid_amount` varchar(255) DEFAULT NULL,
  `cupon_code` varchar(255) DEFAULT NULL,
  `RelativeName` varchar(200) DEFAULT NULL,
  `RelativeRelation` varchar(50) DEFAULT NULL,
  `RelativeMobile` varchar(50) DEFAULT NULL,
  `RelativeGender` varchar(50) DEFAULT NULL,
  `RelativeDOB` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

CREATE TABLE `attributes` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `admin_name` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `validation` varchar(191) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `is_unique` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_locale` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_channel` tinyint(1) NOT NULL DEFAULT 0,
  `is_filterable` tinyint(1) NOT NULL DEFAULT 0,
  `is_configurable` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_visible_on_front` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `swatch_type` varchar(191) DEFAULT NULL,
  `use_in_flat` tinyint(1) NOT NULL DEFAULT 1,
  `is_comparable` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attributes`
--

INSERT INTO `attributes` (`id`, `code`, `admin_name`, `type`, `validation`, `position`, `is_required`, `is_unique`, `value_per_locale`, `value_per_channel`, `is_filterable`, `is_configurable`, `is_user_defined`, `is_visible_on_front`, `created_at`, `updated_at`, `swatch_type`, `use_in_flat`, `is_comparable`) VALUES
(1, 'sku', 'SKU', 'text', NULL, 1, 1, 1, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(2, 'name', 'Name', 'text', NULL, 2, 1, 0, 1, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 1),
(3, 'url_key', 'URL Key', 'text', NULL, 3, 1, 1, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(4, 'tax_category_id', 'Tax Category', 'select', NULL, 4, 0, 0, 0, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(5, 'new', 'New', 'boolean', NULL, 5, 0, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(6, 'featured', 'Featured', 'boolean', NULL, 6, 0, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(7, 'visible_individually', 'Visible Individually', 'boolean', NULL, 7, 1, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(8, 'status', 'Status', 'boolean', NULL, 8, 1, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(9, 'short_description', 'Short Description', 'textarea', NULL, 9, 1, 0, 1, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(10, 'description', 'Description', 'textarea', NULL, 10, 1, 0, 1, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 1),
(11, 'price', 'Price', 'price', 'decimal', 11, 1, 0, 0, 0, 1, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 1),
(12, 'cost', 'Cost', 'price', 'decimal', 12, 0, 0, 0, 1, 0, 0, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(13, 'special_price', 'Special Price', 'price', 'decimal', 13, 0, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(14, 'special_price_from', 'Special Price From', 'date', NULL, 14, 0, 0, 0, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(15, 'special_price_to', 'Special Price To', 'date', NULL, 15, 0, 0, 0, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(16, 'meta_title', 'Meta Title', 'textarea', NULL, 16, 0, 0, 1, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(17, 'meta_keywords', 'Meta Keywords', 'textarea', NULL, 17, 0, 0, 1, 1, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(18, 'meta_description', 'Meta Description', 'textarea', NULL, 18, 0, 0, 1, 1, 0, 0, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(19, 'width', 'Width', 'text', 'decimal', 19, 0, 0, 0, 0, 0, 0, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(20, 'height', 'Height', 'text', 'decimal', 20, 0, 0, 0, 0, 0, 0, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(21, 'depth', 'Depth', 'text', 'decimal', 21, 0, 0, 0, 0, 0, 0, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(22, 'weight', 'Weight', 'text', 'decimal', 22, 1, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(23, 'color', 'Color', 'select', NULL, 23, 0, 0, 0, 0, 1, 1, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(24, 'size', 'Size', 'select', NULL, 24, 0, 0, 0, 0, 1, 1, 1, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(25, 'brand', 'Brand', 'select', '', 25, 0, 0, 0, 0, 1, 0, 1, 1, '2020-10-08 08:45:11', '2021-02-15 19:24:17', 'dropdown', 1, 0),
(26, 'guest_checkout', 'Guest Checkout', 'boolean', NULL, 8, 1, 0, 0, 0, 0, 0, 0, 0, '2020-10-08 08:45:11', '2020-10-08 08:45:11', NULL, 1, 0),
(27, 'paotcustomername', 'Name', 'text', '', NULL, 1, 0, 0, 0, 0, 0, 1, 1, '2021-02-09 21:15:46', '2021-02-09 21:15:46', NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_families`
--

CREATE TABLE `attribute_families` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_families`
--

INSERT INTO `attribute_families` (`id`, `code`, `name`, `status`, `is_user_defined`) VALUES
(1, 'default', 'Default', 0, 1),
(2, 'package', 'Package', 0, 1),
(3, 'healthproduct', 'Health Product', 0, 1),
(4, 'babycare', 'Baby Care', 0, 1),
(5, 'physiooccupationaltherapy', 'Physio Occupational Therapy', 0, 1),
(6, 'organicproduct', 'Organic Product', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_groups`
--

CREATE TABLE `attribute_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `position` int(11) NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `attribute_family_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_groups`
--

INSERT INTO `attribute_groups` (`id`, `name`, `position`, `is_user_defined`, `attribute_family_id`) VALUES
(1, 'General', 1, 0, 1),
(2, 'Description', 2, 0, 1),
(3, 'Meta Description', 3, 0, 1),
(4, 'Price', 4, 0, 1),
(5, 'Shipping', 5, 0, 1),
(6, 'General', 1, 0, 2),
(7, 'Description', 2, 0, 2),
(8, 'Meta Description', 3, 0, 2),
(9, 'Price', 4, 0, 2),
(10, 'Shipping', 5, 0, 2),
(11, 'General', 1, 0, 3),
(12, 'Description', 2, 0, 3),
(13, 'Meta Description', 3, 0, 3),
(14, 'Price', 4, 0, 3),
(15, 'Shipping', 5, 0, 3),
(16, 'General', 1, 0, 4),
(17, 'Description', 2, 0, 4),
(18, 'Meta Description', 3, 0, 4),
(19, 'Price', 4, 0, 4),
(20, 'Shipping', 5, 0, 4),
(21, 'General', 1, 0, 5),
(22, 'Description', 2, 0, 5),
(23, 'Meta Description', 3, 0, 5),
(24, 'Price', 4, 0, 5),
(25, 'Shipping', 5, 0, 5),
(26, 'General', 1, 0, 6),
(27, 'Description', 2, 0, 6),
(28, 'Meta Description', 3, 0, 6),
(29, 'Price', 4, 0, 6),
(30, 'Shipping', 5, 0, 6);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_group_mappings`
--

CREATE TABLE `attribute_group_mappings` (
  `attribute_id` int(10) UNSIGNED NOT NULL,
  `attribute_group_id` int(10) UNSIGNED NOT NULL,
  `position` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_group_mappings`
--

INSERT INTO `attribute_group_mappings` (`attribute_id`, `attribute_group_id`, `position`) VALUES
(1, 1, 1),
(1, 6, 1),
(1, 11, 1),
(1, 16, 1),
(1, 21, 1),
(1, 26, 1),
(2, 1, 2),
(2, 6, 2),
(2, 11, 2),
(2, 16, 2),
(2, 21, 2),
(2, 26, 2),
(3, 1, 3),
(3, 6, 3),
(3, 11, 3),
(3, 16, 3),
(3, 21, 3),
(3, 26, 3),
(4, 1, 4),
(4, 6, 4),
(4, 11, 4),
(4, 16, 4),
(4, 21, 4),
(4, 26, 4),
(5, 1, 5),
(5, 6, 5),
(5, 11, 5),
(5, 16, 5),
(5, 21, 5),
(5, 26, 5),
(6, 1, 6),
(6, 6, 6),
(6, 11, 6),
(6, 16, 6),
(6, 21, 6),
(6, 26, 6),
(7, 1, 7),
(7, 6, 7),
(7, 11, 7),
(7, 16, 7),
(7, 21, 7),
(7, 26, 7),
(8, 1, 8),
(8, 6, 8),
(8, 11, 8),
(8, 16, 8),
(8, 21, 8),
(8, 26, 8),
(9, 2, 1),
(9, 7, 1),
(9, 12, 1),
(9, 17, 1),
(9, 22, 1),
(9, 27, 1),
(10, 2, 2),
(10, 7, 2),
(10, 12, 2),
(10, 17, 2),
(10, 22, 2),
(10, 27, 2),
(11, 4, 1),
(11, 9, 1),
(11, 14, 1),
(11, 19, 1),
(11, 24, 1),
(11, 29, 1),
(12, 4, 2),
(12, 9, 2),
(12, 14, 2),
(12, 19, 2),
(12, 24, 2),
(12, 29, 2),
(13, 4, 3),
(13, 9, 3),
(13, 14, 3),
(13, 19, 3),
(13, 24, 3),
(13, 29, 3),
(14, 4, 4),
(14, 9, 4),
(14, 14, 4),
(14, 19, 4),
(14, 24, 4),
(14, 29, 4),
(15, 4, 5),
(15, 9, 5),
(15, 14, 5),
(15, 19, 5),
(15, 24, 5),
(15, 29, 5),
(16, 3, 1),
(16, 8, 1),
(16, 13, 1),
(16, 18, 1),
(16, 23, 1),
(16, 28, 1),
(17, 3, 2),
(17, 8, 2),
(17, 13, 2),
(17, 18, 2),
(17, 23, 2),
(17, 28, 2),
(18, 3, 3),
(18, 8, 3),
(18, 13, 3),
(18, 18, 3),
(18, 23, 3),
(18, 28, 3),
(19, 5, 1),
(19, 15, 1),
(19, 20, 1),
(19, 30, 1),
(20, 5, 2),
(20, 15, 2),
(20, 20, 2),
(20, 30, 2),
(21, 5, 3),
(21, 15, 3),
(21, 20, 3),
(21, 30, 3),
(22, 5, 4),
(22, 10, 1),
(22, 15, 4),
(22, 20, 4),
(22, 25, 4),
(22, 30, 4),
(23, 1, 10),
(24, 1, 11),
(25, 1, 12),
(25, 11, 10),
(25, 16, 10),
(26, 1, 9),
(26, 6, 9),
(26, 11, 9),
(26, 16, 9),
(26, 21, 9),
(26, 26, 9);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_options`
--

CREATE TABLE `attribute_options` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_name` varchar(191) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL,
  `swatch_value` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_options`
--

INSERT INTO `attribute_options` (`id`, `admin_name`, `sort_order`, `attribute_id`, `swatch_value`) VALUES
(1, 'Red', 1, 23, NULL),
(2, 'Green', 2, 23, NULL),
(3, 'Yellow', 3, 23, NULL),
(4, 'Black', 4, 23, NULL),
(5, 'White', 5, 23, NULL),
(6, 'S', 1, 24, NULL),
(7, 'M', 2, 24, NULL),
(8, 'L', 3, 24, NULL),
(9, 'XL', 4, 24, NULL),
(15, 'Non Brand', 1, 25, NULL),
(16, 'Farmzila', 2, 25, NULL),
(17, 'Jitron Singapore', 3, 25, NULL),
(18, 'Wister', 4, 25, NULL),
(19, 'krishok bazar', 5, 25, NULL),
(20, 'Rowza pure foods ltd', 6, 25, NULL),
(21, 'Dhaka farmers', 7, 25, NULL),
(22, 'SPIRIT', 8, 25, NULL),
(23, 'Naturals', 9, 25, NULL),
(24, 'Andy', 10, 25, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_option_translations`
--

CREATE TABLE `attribute_option_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `label` text DEFAULT NULL,
  `attribute_option_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_option_translations`
--

INSERT INTO `attribute_option_translations` (`id`, `locale`, `label`, `attribute_option_id`) VALUES
(1, 'en', 'Red', 1),
(2, 'en', 'Green', 2),
(3, 'en', 'Yellow', 3),
(4, 'en', 'Black', 4),
(5, 'en', 'White', 5),
(6, 'en', 'S', 6),
(7, 'en', 'M', 7),
(8, 'en', 'L', 8),
(9, 'en', 'XL', 9),
(15, 'en', 'Non Brand', 15),
(16, 'en', 'Farmzila', 16),
(17, 'en', 'Jitron Singapore', 17),
(18, 'en', 'Wister', 18),
(19, 'en', 'krishok bazar', 19),
(20, 'en', 'Rowza pure foods ltd', 20),
(21, 'en', 'Dhaka farmers', 21),
(22, 'en', 'SPIRIT', 22),
(23, 'en', 'Naturals', 23),
(24, 'en', 'Andy', 24);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_translations`
--

CREATE TABLE `attribute_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` text DEFAULT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_translations`
--

INSERT INTO `attribute_translations` (`id`, `locale`, `name`, `attribute_id`) VALUES
(1, 'en', 'SKU', 1),
(2, 'en', 'Name', 2),
(3, 'en', 'URL Key', 3),
(4, 'en', 'Tax Category', 4),
(5, 'en', 'New', 5),
(6, 'en', 'Featured', 6),
(7, 'en', 'Visible Individually', 7),
(8, 'en', 'Status', 8),
(9, 'en', 'Short Description', 9),
(10, 'en', 'Description', 10),
(11, 'en', 'Price', 11),
(12, 'en', 'Cost', 12),
(13, 'en', 'Special Price', 13),
(14, 'en', 'Special Price From', 14),
(15, 'en', 'Special Price To', 15),
(16, 'en', 'Meta Description', 16),
(17, 'en', 'Meta Keywords', 17),
(18, 'en', 'Meta Description', 18),
(19, 'en', 'Width', 19),
(20, 'en', 'Height', 20),
(21, 'en', 'Depth', 21),
(22, 'en', 'Weight', 22),
(23, 'en', 'Color', 23),
(24, 'en', 'Size', 24),
(25, 'en', 'Brand', 25),
(26, 'en', 'Allow Guest Checkout', 26),
(27, 'en', 'Name', 27);

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `qty` int(11) DEFAULT 0,
  `from` int(11) DEFAULT NULL,
  `to` int(11) DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `booking_product_event_ticket_id` int(10) UNSIGNED DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `qty`, `from`, `to`, `order_item_id`, `booking_product_event_ticket_id`, `order_id`, `product_id`) VALUES
(1, 1, NULL, NULL, 7, NULL, 7, 115),
(2, 1, NULL, NULL, 8, NULL, 8, 119),
(3, 1, NULL, NULL, 9, NULL, 9, 124);

-- --------------------------------------------------------

--
-- Table structure for table `booking_products`
--

CREATE TABLE `booking_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) NOT NULL,
  `qty` int(11) DEFAULT 0,
  `location` varchar(191) DEFAULT NULL,
  `show_location` tinyint(1) NOT NULL DEFAULT 0,
  `available_every_week` tinyint(1) DEFAULT NULL,
  `available_from` datetime DEFAULT NULL,
  `available_to` datetime DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `booking_products`
--

INSERT INTO `booking_products` (`id`, `type`, `qty`, `location`, `show_location`, `available_every_week`, `available_from`, `available_to`, `product_id`, `created_at`, `updated_at`) VALUES
(7, 'default', 1000000, '', 0, NULL, '2021-03-11 12:00:00', '2023-04-30 12:00:00', 115, '2021-03-11 11:16:06', '2021-03-11 11:16:06'),
(8, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 117, '2021-03-11 12:20:30', '2021-03-14 08:39:35'),
(9, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 118, '2021-03-11 12:38:21', '2021-03-14 08:39:04'),
(10, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 119, '2021-03-11 12:47:51', '2021-03-14 08:38:29'),
(11, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 120, '2021-03-11 13:15:06', '2021-03-14 08:37:55'),
(12, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 121, '2021-03-14 08:36:45', '2021-03-14 08:36:45'),
(13, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 123, '2021-03-14 08:45:51', '2021-03-14 08:45:51'),
(14, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 124, '2021-03-14 08:50:19', '2021-03-14 08:50:19'),
(15, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 125, '2021-03-14 08:55:19', '2021-03-14 08:55:19'),
(16, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 127, '2021-03-14 09:00:30', '2021-03-14 09:00:30'),
(17, 'default', 1000, '', 0, NULL, '2021-03-14 12:00:00', '2023-03-31 12:00:00', 129, '2021-03-14 09:41:04', '2021-03-14 09:41:04');

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_appointment_slots`
--

CREATE TABLE `booking_product_appointment_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_default_slots`
--

CREATE TABLE `booking_product_default_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `booking_type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_event_tickets`
--

CREATE TABLE `booking_product_event_tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `qty` int(11) DEFAULT 0,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` datetime DEFAULT NULL,
  `special_price_to` datetime DEFAULT NULL,
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_event_ticket_translations`
--

CREATE TABLE `booking_product_event_ticket_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `booking_product_event_ticket_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_rental_slots`
--

CREATE TABLE `booking_product_rental_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `renting_type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `daily_price` decimal(12,4) DEFAULT 0.0000,
  `hourly_price` decimal(12,4) DEFAULT 0.0000,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_table_slots`
--

CREATE TABLE `booking_product_table_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `price_type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guest_limit` int(11) NOT NULL DEFAULT 0,
  `duration` int(11) NOT NULL,
  `break_time` int(11) NOT NULL,
  `prevent_scheduling_before` int(11) NOT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `brand_shop_sliders`
--

CREATE TABLE `brand_shop_sliders` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `image` text NOT NULL,
  `url` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `brand_sliders`
--

CREATE TABLE `brand_sliders` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `image` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `brand_sliders`
--

INSERT INTO `brand_sliders` (`id`, `name`, `image`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Roushon Physiotherapy Center', '1602191036.jpeg', 1, '2020-10-08 21:03:56', '2020-10-08 21:03:56'),
(2, 'Mirpur Pain Management Centre', '1602191080.jpeg', 1, '2020-10-08 21:04:40', '2020-10-08 21:04:40'),
(3, 'JAKI MEDICAL CENTER', '1602191095.jpeg', 1, '2020-10-08 21:04:55', '2020-10-08 21:04:55'),
(4, 'Uttara Crescent Hospital Dhaka', '1602191112.jpeg', 1, '2020-10-08 21:05:12', '2020-10-08 21:05:12'),
(5, 'Thyrocare BD', '1602191147.png', 1, '2020-10-08 21:05:47', '2020-10-08 21:05:47'),
(6, 'Al Helal Specialized Hospital Dhaka', '1602191179.png', 1, '2020-10-08 21:06:19', '2020-10-08 21:06:19'),
(7, 'Bangladesh Specialized Hospital Dhaka', '1602191192.jpeg', 1, '2020-10-08 21:06:32', '2020-10-08 21:06:32'),
(8, 'DNA SOLUTION LTD', '1614418161.png', 1, '2021-02-27 09:11:13', '2021-02-27 09:29:21'),
(9, 'RUSHMONO SPECIALIZED HOSPITAL', '1614417151.jpeg', 1, '2021-02-27 09:12:31', '2021-02-27 09:12:31');

-- --------------------------------------------------------

--
-- Table structure for table `careers`
--

CREATE TABLE `careers` (
  `id` int(10) UNSIGNED NOT NULL,
  `position` varchar(191) DEFAULT NULL,
  `vacancy` varchar(191) DEFAULT NULL,
  `responsibility` text DEFAULT NULL,
  `employment_status` varchar(191) DEFAULT NULL,
  `skill_type` varchar(191) DEFAULT NULL,
  `educational_requirement` text DEFAULT NULL,
  `aditional_requirement` text DEFAULT NULL,
  `job_location` varchar(191) DEFAULT NULL,
  `salary` varchar(191) DEFAULT NULL,
  `compensation` text DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `job_status` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `careers`
--

INSERT INTO `careers` (`id`, `position`, `vacancy`, `responsibility`, `employment_status`, `skill_type`, `educational_requirement`, `aditional_requirement`, `job_location`, `salary`, `compensation`, `deadline`, `email`, `job_status`, `created_at`, `updated_at`) VALUES
(1, 'Sales Officer', '10', '<p>N/A</p>', 'Experienced', 'Sales & Relation Building', '<p>N/A</p>', '<p>N/A</p>', 'Mohammadpur, Dhaka', '10,000 - 15,000 Taka', '<p>N/A</p>', '2020-12-31 00:00:00', 'khaledalmounsur@gmail.com', 1, '2020-12-03 14:06:01', '2020-12-03 14:06:01');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(10) UNSIGNED NOT NULL,
  `customer_email` varchar(191) DEFAULT NULL,
  `customer_first_name` varchar(191) DEFAULT NULL,
  `customer_last_name` varchar(191) DEFAULT NULL,
  `shipping_method` varchar(191) DEFAULT NULL,
  `coupon_code` varchar(191) DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `items_count` int(11) DEFAULT NULL,
  `items_qty` decimal(12,4) DEFAULT NULL,
  `exchange_rate` decimal(12,4) DEFAULT NULL,
  `global_currency_code` varchar(191) DEFAULT NULL,
  `base_currency_code` varchar(191) DEFAULT NULL,
  `channel_currency_code` varchar(191) DEFAULT NULL,
  `cart_currency_code` varchar(191) DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `tax_total` decimal(12,4) DEFAULT 0.0000,
  `base_tax_total` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `checkout_method` varchar(191) DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `conversion_time` datetime DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `customer_email`, `customer_first_name`, `customer_last_name`, `shipping_method`, `coupon_code`, `is_gift`, `items_count`, `items_qty`, `exchange_rate`, `global_currency_code`, `base_currency_code`, `channel_currency_code`, `cart_currency_code`, `grand_total`, `base_grand_total`, `sub_total`, `base_sub_total`, `tax_total`, `base_tax_total`, `discount_amount`, `base_discount_amount`, `checkout_method`, `is_guest`, `is_active`, `conversion_time`, `customer_id`, `channel_id`, `created_at`, `updated_at`, `applied_cart_rule_ids`) VALUES
(2, 'asifnazrul2@gmail.com', 'Asif', 'Nazrul', 'free_free', NULL, 0, 1, 1.0000, NULL, 'USD', 'USD', 'BDT', 'BDT', 500.0000, 500.0000, 500.0000, 500.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-10-11 07:11:10', '2020-10-11 07:12:58', ''),
(3, 'rkreza24@gmail.com', 'Md', 'Karim', 'free_free', NULL, 0, 1, 1.0000, NULL, 'USD', 'USD', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 0, NULL, NULL, 1, '2020-10-11 14:21:49', '2020-10-11 14:50:48', ''),
(4, 'rkreza24@gmail.com', 'Md', 'Karim', 'free_free', NULL, 0, 1, 1.0000, NULL, 'USD', 'USD', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 0, NULL, NULL, 1, '2020-10-11 14:51:18', '2020-10-11 14:54:19', ''),
(5, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-10-11 18:58:14', '2020-10-11 18:58:27', ''),
(6, 'mdraiuddin@gmail.com', 'MD Raihan', 'Uddin', 'free_free', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 3, 1, '2020-10-11 19:17:27', '2020-10-11 19:24:19', ''),
(9, 'admin@example.com', 'Md', 'Karim', 'free_free', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 0, NULL, NULL, 1, '2020-10-14 12:25:42', '2020-10-14 12:46:42', ''),
(10, 'rkreza2q4@gmail.com', 'Md', 'Karim', 'flatrate_flatrate', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 5300.0000, 5300.0000, 4900.0000, 4900.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-10-20 09:31:28', '2020-10-20 14:02:09', ''),
(11, 'rkreza247@gmail.com', 'Md Rezaul', 'Karim', 'custom_ship_two', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 380.0000, 380.0000, 260.0000, 260.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-10-22 19:02:19', '2020-10-22 19:03:09', ''),
(13, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 250.0000, 250.0000, 250.0000, 250.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-12-01 16:44:52', '2020-12-01 16:45:50', ''),
(14, NULL, NULL, NULL, NULL, NULL, 0, 2, 3.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1020.0000, 1020.0000, 1020.0000, 1020.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-12-05 18:20:54', '2020-12-05 18:21:28', ''),
(15, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 250.0000, 250.0000, 250.0000, 250.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-12-07 11:25:26', '2020-12-07 11:25:39', ''),
(17, NULL, NULL, NULL, NULL, NULL, 0, 3, 3.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 8500.0000, 8500.0000, 8500.0000, 8500.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2020-12-22 13:19:17', '2020-12-22 13:22:04', ''),
(20, 'rkreza24@gmail.com', 'Md', 'Karim', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 315.0000, 315.0000, 250.0000, 250.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 43, 1, '2021-01-07 07:44:37', '2021-01-07 07:47:05', ''),
(21, 'rkreza24@gmail.com', 'Md', 'Karim', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 115.0000, 115.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 43, 1, '2021-01-10 23:17:15', '2021-04-03 03:26:25', ''),
(22, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-01-11 14:37:27', '2021-01-11 14:37:27', ''),
(23, 'khaledalmounsur@gmail.com', 'Khaled', 'Mounsur', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1265.0000, 1265.0000, 1200.0000, 1200.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-01-31 20:02:33', '2021-01-31 20:04:36', ''),
(24, 'makhfuroll@gmail.com', 'Makhfuroll', 'Hossain', 'custom_ship_one', NULL, 0, 2, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 9765.0000, 9765.0000, 9700.0000, 9700.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-02-09 21:05:03', '2021-02-09 23:14:24', ''),
(26, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 5000.0000, 5000.0000, 5000.0000, 5000.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-02-18 15:53:10', '2021-02-18 15:53:34', ''),
(27, 'admin@examplhe.com', 'Md', 'Karim', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 315.0000, 315.0000, 250.0000, 250.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-02-20 05:45:56', '2021-02-20 05:47:02', ''),
(29, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 50.0000, 50.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-02 20:35:42', '2021-03-02 20:35:42', ''),
(35, NULL, NULL, NULL, NULL, NULL, 0, 1, 8.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 14400.0000, 14400.0000, 14400.0000, 14400.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-07 08:47:41', '2021-03-07 08:47:53', ''),
(36, NULL, NULL, NULL, NULL, NULL, 0, 1, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 10900.0000, 10900.0000, 10900.0000, 10900.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-08 08:20:14', '2021-03-08 08:20:22', ''),
(37, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7500.0000, 7500.0000, 7500.0000, 7500.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-08 09:16:00', '2021-03-08 09:16:00', ''),
(38, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 50.0000, 50.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-09 05:55:04', '2021-03-09 05:55:13', ''),
(39, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 330.0000, 330.0000, 330.0000, 330.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-09 12:32:46', '2021-03-09 12:32:47', ''),
(40, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 650.0000, 650.0000, 650.0000, 650.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-09 12:51:37', '2021-03-09 12:51:44', ''),
(42, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 400.0000, 400.0000, 400.0000, 400.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-11 01:06:27', '2021-03-11 01:06:27', ''),
(43, 'khaledalmounsur@gmail.com', 'Khaled Al', 'Mounsur', NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 67, 1, '2021-03-11 11:17:00', '2021-03-11 11:25:36', ''),
(44, 'khaledalmounsur@gmail.com', 'Khaled Al', 'Mounsur', NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7430.0000, 7430.0000, 7430.0000, 7430.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 67, 1, '2021-03-11 13:22:00', '2021-03-11 13:22:59', ''),
(45, 'khaledalmounsur1@gmail.com', 'Khaled', 'Mounsur', NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 5400.0000, 5400.0000, 5400.0000, 5400.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 69, 1, '2021-03-14 10:00:40', '2021-03-14 10:11:17', ''),
(46, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 400.0000, 400.0000, 400.0000, 400.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-17 05:15:04', '2021-03-17 05:16:01', ''),
(48, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 50.0000, 50.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-17 19:18:26', '2021-03-17 19:18:26', ''),
(49, 'khaledalmounsur@gmail.com', 'Khaled Al', 'Mounsur', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 445.0000, 445.0000, 380.0000, 380.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 0, NULL, 67, 1, '2021-03-20 07:52:08', '2021-03-20 07:54:15', ''),
(53, 'khaledalmounsur@gmail.com', 'Khaled Al', 'Mounsur', 'custom_ship_one', 'ORGANIC10', 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 600.5000, 600.5000, 595.0000, 595.0000, 0.0000, 0.0000, 59.5000, 59.5000, NULL, 0, 0, NULL, 67, 1, '2021-03-23 20:21:52', '2021-03-23 20:24:01', '2'),
(54, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 50.0000, 50.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-24 15:10:08', '2021-03-24 15:10:08', ''),
(55, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 255.0000, 255.0000, 255.0000, 255.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-03-28 13:14:03', '2021-03-28 13:14:09', ''),
(56, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 120.0000, 120.0000, 120.0000, 120.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-03 06:34:49', '2021-04-03 10:36:00', ''),
(57, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1500.0000, 1500.0000, 1500.0000, 1500.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-05 08:54:31', '2021-04-05 08:54:31', ''),
(58, NULL, NULL, NULL, NULL, 'ORGANIC10', 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 495.0000, 495.0000, 550.0000, 550.0000, 0.0000, 0.0000, 55.0000, 55.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-06 03:32:23', '2021-04-06 03:33:36', '2'),
(60, NULL, NULL, NULL, NULL, NULL, 0, 1, 3.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 480.0000, 480.0000, 480.0000, 480.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-06 10:06:56', '2021-04-06 10:09:11', ''),
(61, 'tuhin00000.du@gmail.com', 'Tuhin', 'Mehedi', 'custom_ship_one', 'ORGANIC10', 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 393.0000, 393.0000, 370.0000, 370.0000, 0.0000, 0.0000, 37.0000, 37.0000, NULL, 0, 1, NULL, 75, 1, '2021-04-06 10:12:04', '2021-04-06 10:32:29', '2'),
(63, 'mhimu@yahoo.com', 'M Hedayet', 'Hossain', NULL, 'ORGANIC10', 0, 1, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 144.0000, 144.0000, 160.0000, 160.0000, 0.0000, 0.0000, 16.0000, 16.0000, NULL, 0, 1, NULL, 76, 1, '2021-04-07 03:34:51', '2021-04-23 16:08:30', '2'),
(64, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 2600.0000, 2600.0000, 2600.0000, 2600.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-07 07:28:48', '2021-04-07 07:28:48', ''),
(65, NULL, NULL, NULL, NULL, NULL, 0, 4, 7.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 960.0000, 960.0000, 960.0000, 960.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-08 03:22:25', '2021-04-08 03:33:17', ''),
(66, 'aa@aa.aa', 'aa', 'aa', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 110.0000, 110.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-08 13:55:20', '2021-04-08 13:56:41', ''),
(67, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 50.0000, 50.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-09 07:50:26', '2021-04-09 07:50:30', ''),
(68, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 170.0000, 170.0000, 170.0000, 170.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-12 12:14:49', '2021-04-12 12:14:49', ''),
(69, 'upol4321@gmail.com', 'Ataul Gani', 'Upol', 'custom_ship_one', 'ORGANIC10', 0, 5, 5.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1189.5000, 1189.5000, 1255.0000, 1255.0000, 0.0000, 0.0000, 125.5000, 125.5000, NULL, 0, 1, NULL, 79, 1, '2021-04-13 19:51:22', '2021-04-13 20:14:54', '2'),
(71, 'mdriad.alone@gmail.com', 'MD ', 'Riad', NULL, 'ORGANIC10', 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 229.5000, 229.5000, 255.0000, 255.0000, 0.0000, 0.0000, 25.5000, 25.5000, NULL, 0, 1, NULL, 80, 1, '2021-04-15 16:02:35', '2021-04-15 16:06:22', '2'),
(72, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 100.0000, 100.0000, 100.0000, 100.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-18 23:11:26', '2021-04-18 23:11:26', ''),
(73, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 260.0000, 260.0000, 260.0000, 260.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-19 06:01:42', '2021-04-19 06:01:51', ''),
(74, 'selimdmc58@gmail.com', 'Selim', 'Reza', 'custom_ship_two', 'ORGANIC10', 0, 1, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1128.0000, 1128.0000, 1120.0000, 1120.0000, 0.0000, 0.0000, 112.0000, 112.0000, NULL, 0, 0, NULL, 81, 1, '2021-04-19 06:09:10', '2021-05-06 05:08:28', '2'),
(75, NULL, NULL, NULL, NULL, NULL, 0, 1, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 510.0000, 510.0000, 510.0000, 510.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-22 18:01:01', '2021-04-22 18:01:48', ''),
(76, 'nhranabd24@gmail.com', 'Nh', 'Rana', NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 255.0000, 255.0000, 255.0000, 255.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 1, NULL, 82, 1, '2021-04-22 18:03:06', '2021-04-22 18:03:06', ''),
(78, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 7850.0000, 7850.0000, 7850.0000, 7850.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-04-27 04:00:16', '2021-04-27 04:00:16', ''),
(79, NULL, NULL, NULL, NULL, 'ORGANIC10', 0, 2, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 729.0000, 729.0000, 810.0000, 810.0000, 0.0000, 0.0000, 81.0000, 81.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-05 19:01:48', '2021-05-05 19:13:22', '2'),
(81, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 140.0000, 140.0000, 140.0000, 140.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-08 16:56:03', '2021-05-08 16:56:03', ''),
(82, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 200.0000, 200.0000, 200.0000, 200.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-19 06:46:33', '2021-05-19 06:53:33', ''),
(83, 'ayon_2009@live.com', 'Rakib', 'Ayon', 'custom_ship_one', NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1540.0000, 1540.0000, 1480.0000, 1480.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-22 11:19:48', '2021-05-22 11:20:30', ''),
(84, 'arifcse11@gmail.com', 'Arif', 'Hossain', NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 195.0000, 195.0000, 195.0000, 195.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 1, NULL, 87, 1, '2021-05-22 12:49:35', '2021-05-22 12:51:39', ''),
(85, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 100.0000, 100.0000, 100.0000, 100.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-24 08:45:03', '2021-05-24 08:45:03', ''),
(86, NULL, NULL, NULL, NULL, NULL, 0, 1, 3.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 1650.0000, 1650.0000, 1650.0000, 1650.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-25 08:11:25', '2021-05-25 08:12:45', ''),
(87, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 250.0000, 250.0000, 250.0000, 250.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-05-26 04:55:02', '2021-05-26 04:55:08', ''),
(88, 'superman68608@gmail.com', 'Wsuper', 'Man', NULL, NULL, 0, 1, 2.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 160.0000, 160.0000, 160.0000, 160.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0, 1, NULL, 93, 1, '2021-05-29 21:21:56', '2021-05-29 21:32:12', ''),
(89, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 50.0000, 50.0000, 50.0000, 50.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-06-02 17:04:04', '2021-06-02 17:04:04', ''),
(90, NULL, NULL, NULL, NULL, NULL, 0, 1, 1.0000, NULL, 'BDT', 'BDT', 'BDT', 'BDT', 140.0000, 140.0000, 140.0000, 140.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 1, 1, NULL, NULL, 1, '2021-06-05 07:52:11', '2021-06-05 07:52:11', '');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sku` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price` decimal(12,4) NOT NULL DEFAULT 1.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_item_inventories`
--

CREATE TABLE `cart_item_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `inventory_source_id` int(10) UNSIGNED DEFAULT NULL,
  `cart_item_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_payment`
--

CREATE TABLE `cart_payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `method` varchar(191) NOT NULL,
  `method_title` varchar(191) DEFAULT NULL,
  `cart_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cart_payment`
--

INSERT INTO `cart_payment` (`id`, `method`, `method_title`, `cart_id`, `created_at`, `updated_at`) VALUES
(5, 'cashondelivery', NULL, 3, '2020-10-11 14:50:39', '2020-10-11 14:50:39'),
(6, 'cashondelivery', NULL, 4, '2020-10-11 14:53:43', '2020-10-11 14:53:43'),
(7, 'cashondelivery', NULL, 6, '2020-10-11 19:23:56', '2020-10-11 19:23:56'),
(14, 'cashondelivery', NULL, 9, '2020-10-14 12:44:41', '2020-10-14 12:44:41'),
(21, 'sslcommerz', NULL, 10, '2020-10-20 14:00:19', '2020-10-20 14:00:19'),
(22, 'sslcommerz', NULL, 11, '2020-10-22 19:03:03', '2020-10-22 19:03:03'),
(25, 'cashondelivery', NULL, 20, '2021-01-07 07:47:01', '2021-01-07 07:47:01'),
(30, 'sslcommerz', NULL, 27, '2021-02-20 05:46:58', '2021-02-20 05:46:58'),
(32, 'cashondelivery', NULL, 43, '2021-03-11 11:25:31', '2021-03-11 11:25:31'),
(33, 'cashondelivery', NULL, 44, '2021-03-11 13:22:30', '2021-03-11 13:22:30'),
(34, 'cashondelivery', NULL, 45, '2021-03-14 10:10:29', '2021-03-14 10:10:29'),
(35, 'cashondelivery', NULL, 49, '2021-03-20 07:53:28', '2021-03-20 07:53:28'),
(36, 'cashondelivery', NULL, 53, '2021-03-23 20:23:22', '2021-03-23 20:23:22'),
(37, 'cashondelivery', NULL, 21, '2021-04-03 03:26:21', '2021-04-03 03:26:21'),
(38, 'sslcommerz', NULL, 61, '2021-04-06 10:32:29', '2021-04-06 10:32:29'),
(40, 'sslcommerz', NULL, 69, '2021-04-13 20:14:37', '2021-04-13 20:14:37'),
(42, 'cashondelivery', NULL, 74, '2021-05-06 05:07:35', '2021-05-06 05:07:35'),
(43, 'cashondelivery', NULL, 83, '2021-05-22 11:20:30', '2021-05-22 11:20:30');

-- --------------------------------------------------------

--
-- Table structure for table `cart_rules`
--

CREATE TABLE `cart_rules` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `coupon_type` int(11) NOT NULL DEFAULT 1,
  `use_auto_generation` tinyint(1) NOT NULL DEFAULT 0,
  `usage_per_customer` int(11) NOT NULL DEFAULT 0,
  `uses_per_coupon` int(11) NOT NULL DEFAULT 0,
  `times_used` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
-- Table structure for table `tbl_appointment`
--

CREATE TABLE `tbl_appointment` (
  `OID` bigint(20) NOT NULL,
  `PatientID` varchar(50) DEFAULT NULL,
  `DOCID` varchar(50) DEFAULT NULL,
  `RelativeID` varchar(50) DEFAULT NULL,
  `Appointment_Time` varchar(50) DEFAULT NULL,
  `AppointmentDate` date DEFAULT NULL,
  `Created_at` datetime(3) DEFAULT NULL,
  `Updatedat` datetime(3) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `type` varchar(255) NOT NULL DEFAULT ' ',
  `followup` date DEFAULT NULL,
  `txn_id` varchar(300) NOT NULL DEFAULT ' '
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_appointment`
--

INSERT INTO `tbl_appointment` (`OID`, `PatientID`, `DOCID`, `RelativeID`, `Appointment_Time`, `AppointmentDate`, `Created_at`, `Updatedat`, `updated_at`, `Status`, `type`, `followup`, `txn_id`) VALUES
(48, '10', '19', '0', '1:00 AM', '2020-11-10', '2020-11-09 00:15:02.000', NULL, '2020-11-10 19:41:52', 'Completed', ' ', NULL, 'BGW62882020110901343'),
(47, '19', '36', '0', '1:30 AM', '2020-12-11', '2020-10-22 21:22:34.000', NULL, '2020-12-11 01:20:23', 'overdue', ' ', NULL, 'BGW361920201022124884'),
(46, '14', '19', '0', '1:00 PM', '2020-10-22', '2020-10-18 00:28:47.000', NULL, '2020-10-22 12:24:13', 'Completed', ' ', NULL, 'BGW28002020101802809'),
(43, '14', '19', '0', '4:30 PM', '2020-10-14', '2020-10-14 16:15:49.000', NULL, '2020-10-14 16:21:31', 'Completed', ' ', NULL, 'BGW79692020101471833'),
(42, '20', '36', '0', '11:00 PM', '2020-10-14', '2020-10-14 15:37:16.000', NULL, '2020-10-14 15:37:16', 'overdue', ' ', NULL, 'BGW87212020101467162'),
(37, '18', '19', '0', '1:00 PM', '2020-10-31', '2020-10-11 07:49:12.000', NULL, '2020-10-22 12:11:08', 'overdue', ' ', NULL, 'BGW36952020101161269'),
(38, '18', '20', '0', '4:00 PM', '2021-01-16', '2020-10-11 07:49:50.000', NULL, '2020-10-11 07:56:53', 'Completed', ' ', NULL, 'BGW10492020101161374'),
(39, '10', '1', '0', '8:00 PM', '2020-10-13', '2020-10-13 14:03:04.000', NULL, '2020-10-13 14:03:04', 'overdue', ' ', NULL, 'BGW62612020101356158'),
(40, '11', '1', '0', '7:30 PM', '2020-10-14', '2020-10-14 13:17:20.000', NULL, '2020-10-14 13:17:20', 'overdue', ' ', NULL, 'BGW26012020101450652'),
(41, '10', '36', '0', '11:30 PM', '2020-10-31', '2020-10-14 15:19:41.000', NULL, '2020-10-14 15:19:41', 'overdue', ' ', NULL, 'BGW71832020101465140'),
(50, '19', '38', '0', '2:30 AM', '2020-12-11', '2020-12-11 01:33:20.000', NULL, '2020-12-11 01:33:20', 'overdue', ' ', NULL, 'BGW64842020121103856'),
(49, '10', '38', '0', '2:00 AM', '2020-12-11', '2020-12-11 01:12:14.000', NULL, '2020-12-11 01:12:14', 'overdue', ' ', NULL, 'NG85592020121103421'),
(51, '17', '36', '0', '5:00 PM', '2020-12-17', '2020-12-17 16:36:13.000', NULL, '2020-12-17 16:41:56', 'Completed', ' ', NULL, 'BGW89072020121741868'),
(93, '11', '41', '0', '8:00 PM', '2021-01-27', '2021-01-27 19:25:00.000', NULL, '2021-01-27 21:03:06', 'Completed', ' ', NULL, 'BGT79172021012769546'),
(85, '10', '41', '0', '4:30 PM', '2021-01-10', '2021-01-09 01:12:35.000', NULL, '2021-01-10 15:59:30', 'Completed', ' ', NULL, 'NG56232021010902709'),
(54, '3', '39', '0', '7:00 PM', '2020-12-17', '2020-12-17 18:40:56.000', NULL, '2020-12-17 18:40:56', 'overdue', ' ', NULL, 'BGW36832020121751436'),
(55, '30', '23', '0', '12:00 PM', '2020-12-18', '2020-12-18 09:45:00.000', NULL, '2020-12-18 09:45:00', 'overdue', ' ', NULL, 'BGW77952020121810833'),
(56, '11', '41', '0', '3:30 PM', '2021-01-03', '2020-12-30 16:52:40.000', NULL, '2021-01-03 15:49:59', 'Completed', ' ', NULL, 'NG36802020123051356'),
(57, '11', '41', '0', '5:00 PM', '2021-01-10', '2020-12-30 18:02:56.000', NULL, '2021-01-10 17:01:39', 'Completed', ' ', NULL, 'BGW67022020123057903'),
(58, '11', '41', '0', '2:00 PM', '2021-01-03', '2021-01-03 13:11:18.000', NULL, '2021-01-03 14:07:13', 'Completed', ' ', NULL, 'BGW38392021010330175'),
(59, '3', '42', '0', '4:00 PM', '2021-01-31', '2021-01-07 14:02:11.000', NULL, '2021-01-31 15:54:45', 'Completed', ' ', NULL, 'NG65182021010734014'),
(60, '3', '42', '0', '1:45 PM', '2021-04-12', '2021-01-07 15:07:40.000', NULL, '2021-04-12 13:38:48', 'overdue', ' ', NULL, 'NG32042021010739065'),
(86, '3', '41', '0', '6:30 PM', '2021-02-14', '2021-01-15 00:35:00.000', NULL, '2021-02-14 14:09:07', 'overdue', ' ', NULL, 'NG87462021011501893'),
(87, '11', '41', '0', '2:30 PM', '2021-01-16', '2021-01-16 13:47:15.000', NULL, '2021-01-16 14:00:52', 'Completed', ' ', NULL, 'BGT72932021011635694'),
(88, '11', '41', '0', '5:00 AM', '2021-02-23', '2021-01-16 14:10:58.000', NULL, '2021-02-23 15:26:59', 'Completed', ' ', NULL, 'BGT46302021011637640'),
(89, '11', '41', '0', '2:00 PM', '2021-01-19', '2021-01-19 13:20:35.000', NULL, '2021-01-19 15:09:09', 'Completed', ' ', NULL, 'BGT45742021011930898'),
(90, '11', '41', '0', '3:30 PM', '2021-01-19', '2021-01-19 15:13:13.000', NULL, '2021-01-19 15:24:21', 'Completed', ' ', NULL, 'BGT56862021011938760'),
(91, '3', '41', '0', '11:30 PM', '2021-04-09', '2021-01-21 20:11:42.000', NULL, '2021-04-08 16:21:50', 'overdue', ' ', NULL, 'NG37132021012171040'),
(92, '10', '41', '0', '4:30 PM', '2021-01-27', '2021-01-27 16:02:30.000', NULL, '2021-01-27 18:52:54', 'Completed', ' ', NULL, 'NG37212021012749761'),
(102, '3', '42', '0', '9:45 PM', '2021-04-21', '2021-02-15 16:23:42.000', NULL, '2021-04-20 13:02:15', 'overdue', ' ', NULL, 'BGT31252021021553586'),
(101, '3', '42', '0', '3:30 PM', '2021-04-12', '2021-02-15 14:42:10.000', NULL, '2021-04-12 13:38:23', 'overdue', ' ', NULL, 'BGT53852021021544690'),
(100, '10', '41', '0', '5:00 PM', '2021-02-23', '2021-02-09 15:34:41.000', NULL, '2021-02-23 15:00:26', 'Completed', ' ', NULL, 'NG28092021020950903'),
(99, '10', '41', '0', '5:30 AM', '2021-02-09', '2021-02-09 04:20:43.000', NULL, '2021-02-09 04:31:52', 'Completed', ' ', NULL, 'NG69202021020907637'),
(98, '10', '41', '0', '4:15 AM', '2021-02-09', '2021-02-09 04:06:07.000', NULL, '2021-02-09 05:27:26', 'Completed', ' ', NULL, 'NG92162021020907540'),
(97, '10', '41', '0', '2:30 PM', '2021-02-09', '2021-02-09 01:18:52.000', NULL, '2021-02-09 03:59:54', 'Completed', ' ', NULL, 'NG48302021020904789'),
(96, '3', '42', '11', '5:30 PM', '2021-02-03', '2021-02-02 00:00:02.000', NULL, '2021-02-02 00:06:03', 'Completed', ' ', NULL, 'BGT72362021020192934'),
(95, '3', '42', '0', '3:00 PM', '2021-04-20', '2021-02-01 23:30:37.000', NULL, '2021-04-20 13:13:22', 'Completed', ' ', NULL, 'BGT12812021020191071'),
(94, '10', '41', '0', '2:00 PM', '2021-01-28', '2021-01-28 13:25:37.000', NULL, '2021-01-28 14:13:21', 'Completed', ' ', NULL, 'NG27862021012832978'),
(103, '10', '41', '0', '5:00 PM', '2021-02-23', '2021-02-15 17:59:53.000', NULL, '2021-02-23 15:07:01', 'Completed', ' ', NULL, 'NG34152021021562142'),
(104, '10', '41', '0', '4:00 PM', '2021-02-23', '2021-02-16 15:54:02.000', NULL, '2021-02-23 13:45:51', 'Completed', ' ', NULL, 'NG18952021021648386'),
(105, '11', '41', '0', '9:30 PM', '2021-02-23', '2021-02-16 17:53:40.000', NULL, '2021-02-25 00:59:49', 'Completed', ' ', NULL, 'BGT28252021021658053'),
(106, '10', '41', '0', '9:00 PM', '2021-02-23', '2021-02-20 20:03:50.000', NULL, '2021-02-23 14:00:02', 'overdue', ' ', NULL, 'NG38382021022085028'),
(107, '41', '41', '0', '2:15 AM', '2021-02-25', '2021-02-25 01:07:23.000', NULL, '2021-02-25 01:07:23', 'overdue', ' ', NULL, 'NG20422021022504008'),
(108, '11', '41', '0', '6:00 PM', '2021-02-27', '2021-02-27 17:34:03.000', NULL, '2021-02-27 18:28:03', 'Completed', ' ', NULL, 'BGT69142021022767433'),
(109, '51', '41', '0', '5:00 PM', '2021-03-01', '2021-03-01 16:39:50.000', NULL, '2021-03-01 17:08:42', 'Completed', ' ', NULL, 'NG25732021030162264'),
(110, '51', '41', '0', '4:30 PM', '2021-03-02', '2021-03-02 16:17:05.000', NULL, '2021-03-02 16:31:43', 'Completed', ' ', NULL, 'NG59192021030256407'),
(111, '10', '41', '0', '6:00 PM', '2021-03-03', '2021-03-03 09:42:37.000', NULL, '2021-03-03 09:42:37', 'overdue', ' ', NULL, 'NG24752021030322142'),
(112, '10', '41', '13', '7:00 PM', '2021-03-03', '2021-03-03 09:57:50.000', NULL, '2021-03-03 10:30:36', 'Completed', ' ', NULL, 'NG22332021030323611'),
(113, '51', '59', '0', '5:00 PM', '2021-03-04', '2021-03-03 16:33:35.000', NULL, '2021-03-04 15:20:51', 'overdue', ' ', NULL, 'NG75772021030363891'),
(114, '51', '59', '0', '5:30 PM', '2021-03-04', '2021-03-03 16:52:45.000', NULL, '2021-03-04 15:21:28', 'overdue', ' ', NULL, 'NG77942021030365677'),
(115, '10', '59', '0', '5:30 PM', '2021-03-03', '2021-03-03 17:12:05.000', NULL, '2021-03-03 17:12:05', 'overdue', ' ', NULL, 'BGT75532021030367443'),
(116, '11', '59', '0', '5:00 PM', '2021-03-04', '2021-03-03 17:25:10.000', NULL, '2021-03-04 15:14:14', 'overdue', ' ', NULL, 'BGT97112021030368679'),
(117, '51', '70', '0', '9:15 PM', '2021-03-06', '2021-03-06 20:50:51.000', NULL, '2021-03-06 21:20:45', 'Completed', ' ', NULL, 'NG63412021030699783'),
(118, '51', '63', '0', '9:45 PM', '2021-03-06', '2021-03-06 21:27:37.000', NULL, '2021-03-06 21:27:37', 'overdue', ' ', NULL, 'NG479120210306104612'),
(119, '51', '40', '0', '11:15 AM', '2021-03-07', '2021-03-07 11:17:56.000', NULL, '2021-03-07 12:11:23', 'Completed', ' ', NULL, 'NG51332021030727948'),
(120, '51', '26', '0', '1:15 PM', '2021-03-07', '2021-03-07 13:01:54.000', NULL, '2021-03-07 13:19:16', 'Completed', ' ', NULL, 'BGT91372021030741136'),
(121, '51', '53', '0', '7:30 PM', '2021-03-08', '2021-03-08 19:21:47.000', NULL, '2021-03-08 19:30:19', 'Completed', ' ', NULL, 'BGT77632021030886565'),
(122, '51', '7', '0', '9:00 PM', '2021-03-08', '2021-03-08 20:55:33.000', NULL, '2021-03-08 21:03:12', 'Completed', ' ', NULL, 'BGT34512021030899920'),
(123, '51', '51', '0', '5:45 PM', '2021-03-09', '2021-03-09 17:31:07.000', NULL, '2021-03-09 17:38:30', 'Completed', ' ', NULL, 'BGT18622021030976607'),
(124, '51', '45', '0', '7:00 PM', '2021-03-09', '2021-03-09 18:53:43.000', NULL, '2021-03-09 18:56:57', 'Completed', ' ', NULL, 'BGT55332021030988986'),
(125, '51', '46', '0', '12:30 PM', '2021-03-10', '2021-03-10 12:02:27.000', NULL, '2021-03-10 12:07:58', 'Completed', ' ', NULL, 'BGT64412021031052376'),
(126, '51', '68', '0', '1:15 PM', '2021-03-13', '2021-03-13 13:06:30.000', NULL, '2021-03-13 13:20:40', 'Completed', ' ', NULL, 'BGT31622021031353735'),
(127, '51', '44', '0', '8:30 PM', '2021-03-13', '2021-03-13 20:16:56.000', NULL, '2021-03-13 20:20:32', 'Completed', ' ', NULL, 'BGT121720210313108055'),
(128, '27', '1', '15', '7:00 PM', '2021-03-15', '2021-03-14 21:33:35.000', NULL, '2021-03-15 19:14:48', 'Completed', ' ', NULL, 'BGT258620210314100530'),
(129, '51', '43', '0', '1:00 PM', '2021-03-17', '2021-03-17 12:45:32.000', NULL, '2021-03-17 12:55:33', 'Completed', ' ', NULL, 'BGT61452021031741254'),
(130, '51', '55', '0', '6:00 PM', '2021-03-21', '2021-03-21 17:42:32.000', NULL, '2021-03-21 17:49:45', 'Completed', ' ', NULL, 'BGT47472021032176658'),
(131, '51', '59', '0', '7:45 PM', '2021-03-21', '2021-03-21 19:27:56.000', NULL, '2021-03-21 20:00:34', 'Completed', ' ', NULL, 'BGT43552021032190385'),
(132, '51', '59', '0', '8:00 PM', '2021-03-21', '2021-03-21 19:43:03.000', NULL, '2021-03-21 20:09:46', 'Completed', ' ', NULL, 'BGT57582021032192604'),
(133, '51', '59', '0', '8:30 PM', '2021-03-21', '2021-03-21 20:18:21.000', NULL, '2021-03-21 20:23:17', 'Completed', ' ', NULL, 'BGT69532021032197460'),
(134, '11', '41', '0', '5:30 PM', '2021-03-24', '2021-03-22 16:26:39.000', NULL, '2021-03-24 17:16:04', 'overdue', ' ', NULL, 'BGT71792021032263858'),
(135, '3', '42', '11', '11:15 PM', '2021-03-22', '2021-03-22 19:01:25.000', NULL, '2021-03-22 19:15:42', 'Completed', ' ', NULL, 'BGT21722021032281283'),
(136, '11', '52', '0', '8:00 PM', '2021-03-22', '2021-03-22 19:52:53.000', NULL, '2021-03-22 19:52:53', 'overdue', ' ', NULL, 'BGT65272021032288317'),
(137, '11', '52', '0', '7:00 PM', '2021-04-05', '2021-03-22 19:58:18.000', NULL, '2021-04-05 10:39:26', 'overdue', ' ', NULL, 'BGT27322021032289123'),
(138, '11', '54', '0', '9:00 PM', '2021-03-22', '2021-03-22 20:42:12.000', NULL, '2021-03-22 20:52:29', 'Completed', ' ', NULL, 'BGT12382021032295063'),
(139, '3', '42', '17', '12:15 PM', '2021-04-12', '2021-03-23 13:23:18.000', NULL, '2021-04-12 13:39:10', 'overdue', 'report_showing', NULL, 'NG41422021032340366'),
(140, '11', '56', '0', '11:00 AM', '2021-03-24', '2021-03-24 10:39:26.000', NULL, '2021-03-24 10:39:26', 'overdue', ' ', NULL, 'BGT80022021032424039'),
(141, '11', '50', '0', '1:30 PM', '2021-03-24', '2021-03-24 13:23:16.000', NULL, '2021-03-24 13:35:32', 'Completed', ' ', NULL, 'BGT32932021032443041'),
(142, '11', '30', '0', '8:15 PM', '2021-03-24', '2021-03-24 20:05:51.000', NULL, '2021-03-24 20:18:14', 'Completed', ' ', NULL, 'BGT16832021032485441'),
(143, '11', '68', '0', '1:15 PM', '2021-03-25', '2021-03-25 13:07:20.000', NULL, '2021-03-25 13:31:50', 'Completed', ' ', NULL, 'BGT80232021032542691'),
(144, '3', '42', '25', '11:15 PM', '2021-03-26', '2021-03-26 21:26:07.000', NULL, '2021-03-26 21:36:31', 'Completed', 'report_showing', NULL, 'BGT249720210326101254'),
(145, '11', '41', '0', '5:30 PM', '2021-04-04', '2021-03-27 16:48:13.000', NULL, '2021-04-04 17:01:51', 'overdue', 'video_consultation', NULL, 'BGT98732021032771115'),
(146, '11', '41', '0', '5:00 AM', '2021-04-06', '2021-03-27 16:51:32.000', NULL, '2021-04-06 16:35:01', 'overdue', 'report_showing', NULL, 'BGT99812021032771478'),
(147, '11', '77', '0', '8:15 PM', '2021-03-29', '2021-03-29 19:58:44.000', NULL, '2021-03-29 20:11:04', 'Completed', ' ', NULL, 'BGT21392021032982460'),
(148, '11', '77', '0', '8:30 PM', '2021-03-29', '2021-03-29 20:13:48.000', NULL, '2021-03-29 20:18:40', 'Completed', ' ', NULL, 'BGT17482021032984220'),
(149, '11', '49', '0', '4:00 PM', '2021-03-31', '2021-03-31 11:50:55.000', NULL, '2021-03-31 12:07:54', 'Completed', ' ', NULL, 'BGT45262021033133273'),
(150, '9', '42', '0', '12:15 PM', '2021-03-31', '2021-03-31 12:02:51.000', NULL, '2021-03-31 12:02:51', 'overdue', 'report_showing', NULL, 'BGT53142021033134855'),
(151, '11', '72', '0', '1:30 PM', '2021-03-31', '2021-03-31 13:09:50.000', NULL, '2021-03-31 13:30:23', 'Completed', ' ', NULL, 'BGT92872021033143563'),
(152, '11', '72', '0', '4:00 PM', '2021-04-04', '2021-04-01 15:39:47.000', NULL, '2021-04-04 18:20:16', 'Completed', ' ', NULL, 'BGT70902021040160384'),
(153, '11', '6', '0', '5:45 PM', '2021-04-10', '2021-04-10 17:08:03.000', NULL, '2021-04-10 18:48:15', 'Completed', 'video_consultation', NULL, 'BGT79312021041079460'),
(154, '11', '5', '0', '4:15 PM', '2021-04-11', '2021-04-11 15:47:37.000', NULL, '2021-04-11 15:47:37', 'overdue', 'video_consultation', NULL, 'BGT89112021041166141'),
(155, '11', '78', '0', '9:15 PM', '2021-04-11', '2021-04-11 21:03:42.000', NULL, '2021-04-11 21:07:48', 'Completed', ' ', NULL, 'BGT695420210411108768'),
(156, '11', '26', '0', '12:45 PM', '2021-04-12', '2021-04-12 12:38:13.000', NULL, '2021-04-12 13:49:44', 'Completed', 'video_consultation', NULL, 'BGT65922021041248772'),
(157, '11', '51', '0', '5:00 PM', '2021-04-12', '2021-04-12 16:02:16.000', NULL, '2021-04-12 17:05:43', 'Completed', ' ', NULL, 'BGT31032021041275322'),
(158, '11', '70', '0', '6:45 PM', '2021-04-12', '2021-04-12 18:26:31.000', NULL, '2021-04-12 19:21:13', 'Completed', 'video_consultation', NULL, 'BGT43502021041293641'),
(159, '11', '41', '0', '1:30 PM', '2021-04-14', '2021-04-14 13:01:30.000', NULL, '2021-04-14 13:01:30', 'overdue', 'video_consultation', NULL, 'BGT38432021041453828');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_consultation`
--

CREATE TABLE `tbl_consultation` (
  `OID` bigint(20) NOT NULL,
  `RefNo` text DEFAULT NULL,
  `PatientID` bigint(20) DEFAULT NULL,
  `DoctorID` bigint(20) DEFAULT NULL,
  `AppointmentID` varchar(255) NOT NULL DEFAULT '0',
  `Complaints` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Investigations` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `OnExamination` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Rx` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '\' \'',
  `Medicine` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Frequency` varchar(200) DEFAULT NULL,
  `Duration` varchar(200) DEFAULT NULL,
  `Instruction` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Advice` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_consultation`
--

INSERT INTO `tbl_consultation` (`OID`, `RefNo`, `PatientID`, `DoctorID`, `AppointmentID`, `Complaints`, `Investigations`, `OnExamination`, `Rx`, `Medicine`, `Frequency`, `Duration`, `Instruction`, `Advice`, `Created_at`, `Updated_at`) VALUES
(42, '449093', 3, 8, '0', 'headace', 'none', NULL, ' ', 'napa', '1+1+1', '7days', '', '', '2020-09-27 18:09:48', NULL),
(40, '495131', 3, 11, '0', 'test', 'test', NULL, ' ', 'test', '1+2+1', '6days', '', '', '2020-09-02 23:09:48', NULL),
(41, '402875', 3, 11, '0', 'Fever', '103 f', NULL, ' ', 'Napa', '1+1+1', '3days', '', '', '2020-09-05 21:09:58', NULL),
(38, '7564971599052514', 5, 8, '0', 'Pain', 'No', NULL, ' ', 'Seclo 20 mg', '1+0+1', '7days', '', '', '2020-09-02 19:09:11', NULL),
(39, '1962661599066957', 9, 11, '0', 'too much', 'Headache', NULL, ' ', 'Napa', '1+0+1', '3days', '', '', '2020-09-02 23:09:53', NULL),
(37, '7564971599052514', 5, 8, '0', 'Pain', 'No', NULL, ' ', 'Paracetemol 500 mg', '1+1+1', '7days', '', '', '2020-09-02 19:09:24', NULL),
(36, '7318091599052280', 3, 11, '0', 'ddd', 'ddd', NULL, ' ', 'ddd', '1+0+0', '1day', '', '', '2020-09-02 19:09:15', NULL),
(34, '63WK0155-1598968065', 5, 8, '0', 'ddd', 'sss', NULL, ' ', 'sss', '1+1+1', '1year', '', '', '2020-09-01 19:09:39', NULL),
(35, '7330501598972570', 8, 8, '0', 'bb', 'bb', NULL, ' ', 'bb', '1+0+0', '1year', '', '', '2020-09-01 21:09:46', NULL),
(43, '62809', 14, 20, '0', 'Pain', 'no solution', NULL, ' ', 'peracitamol', '1+1+1+1', 'life time', 'with pani', 'no comment', '2020-10-09 23:10:09', NULL),
(44, '645814', 14, 20, '0', 'Pain', 'no solution', NULL, ' ', 'peracitamol', '1+1+1+1', 'life time', 'with pani', 'no comment', '2020-10-09 23:10:09', NULL),
(45, '978914', 14, 20, '0', 'Pain', 'no solution', NULL, ' ', 'peracitamol', '1+1+1+1', 'life time', 'with pani', 'no comment', '2020-10-09 23:10:09', NULL),
(46, '74494', 14, 20, '0', 'Pain', 'no solution', NULL, ' ', 'peracitamol', '1+1+1+1', 'life time', 'with pani', 'no comment', '2020-10-09 23:10:09', NULL),
(47, '953085', 14, 20, '0', 'Pain', 'no solution', NULL, ' ', 'peracitamol', '1+1+1+1', 'life time', 'with pani', 'no comment', '2020-10-09 23:10:09', NULL),
(48, '469991', 3, 14, '0', 'test', 'headache', NULL, ' ', 'napa', '1+1+1', '7days', '', '', '2020-10-10 11:10:27', NULL),
(49, '127046', 15, 8, '0', 'head ache', 'head', NULL, ' ', 'napa', '1+1+1', '7days', 'before meal', 'no late night', '2020-10-10 05:10:15', NULL),
(51, '331002', 14, 20, '0', 'Tension', 'No findings', NULL, ' ', 'dormitol', '0+0+1', '7days', 'water drink', 'enjoy', '2020-10-11 02:10:42', NULL),
(52, '328690', 1, 2, '0', 'Fever', 'Regular', NULL, ' ', 'Napa Extra', '1+1+1', '7day', 'After Meal', 'Take your medi in right time', '2020-08-25 00:08:00', NULL),
(53, '328690', 1, 2, '0', 'Alchar', 'Altra Sonography', NULL, ' ', 'Vita C', '1+1+0', '1 months', 'After Meal', 'Take your medi in right time', '2020-08-25 00:08:00', NULL),
(54, '342188', 1, 2, '0', 'Fever', 'Regular', NULL, ' ', 'Napa Extra', '1+1+1', '7day', 'After Meal', 'Take your medi in right time', '2020-08-25 00:08:00', NULL),
(55, '342188', 1, 2, '0', 'Alchar', 'Altra Sonography', NULL, ' ', 'Vita C', '1+1+0', '1 months', 'After Meal', 'Take your medi in right time', '2020-08-25 00:08:00', NULL),
(56, '639427', 14, 20, '0', 'Fever', 'Viral Fever', NULL, ' ', 'Peracetemol 500mg', '1+1+1', '3 Days', 'After Meal', '', '2020-10-14 05:10:42', NULL),
(57, '639427', 14, 20, '0', 'Insomania', 'Tension', NULL, ' ', 'Clonazepam 0.5mg', '0+0+1', '7 Days', 'After Meal', 'Take bed rest', '2020-10-14 05:10:15', NULL),
(58, '645891', 1, 2, '0', 'Fever', 'Regular', 'Serious', ' ', 'Napa Extra', '1+1+1', '7day', 'After Meal', 'Take your medi in right time', '2020-08-25 00:08:00', NULL),
(59, '645891', 1, 2, '0', 'Alchar', 'Altra Sonography', 'Serious', ' ', 'Vita C', '1+1+0', '1 months', 'After Meal', 'Take your medi in right time', '2020-08-25 00:08:00', NULL),
(60, '868073', 14, 8, '0', 'Gastrict', 'Serious Gastric', 'relaxation', ' ', 'Omiprazol', '1+1+1', '3days', 'After Meal', 'drink Water', '2020-10-22 01:10:28', NULL),
(61, '868073', 14, 8, '0', 'Gastric', 'none', '', ' ', 'Metazol', '1+1+1', '1days', '', '', '2020-10-22 01:10:59', NULL),
(62, '86413', 10, 38, '0', 'pain\nfever', 'cbc\nxray', '', ' ', 'tab.napa\ntab.fexo 120', '1+1+1+1\n0+0+1', '5 days\n14 days', '', '', '2020-11-10 19:11:41', NULL),
(63, '845432', 17, 36, '0', 'headache', 'fever', '', ' ', 'napa', '1+1+1', '3days', '', '', '2020-12-17 16:12:05', NULL),
(64, '845432', 17, 36, '0', 'knee pain', 'calcium lack', 'muscle stretch', ' ', 'calbo D', '0+0+1', '1month', 'after dinner', 'rest properly', '2020-12-17 16:12:51', NULL),
(65, '122391', 11, 41, '0', 'Fever', 'CBC', 'Redness of eye', ' ', 'Napa', '1+1+1', '7 days', 'with meal', 'drink plenty of water', '2021-01-03 14:01:01', NULL),
(66, '729117', 11, 41, '0', 'a', 'b', '', ' ', 'c', '2', '6', '', '', '2021-01-03 15:01:56', NULL),
(67, '153693', 10, 41, '0', 'fever\nbody ache', 'cbc\nns1 antigen', 'rash on body', ' ', 'Tab.Napa - 500mg (1+1+1) বাংলাদেশ \nTab.Fexo 120mg (0+0+1) ? ??? ?????', '1+1+1\n0+0+1', '7 days\n1month', 'Aaaaaaaaaaaaa', 'Bbbbbbbbbbbbb', '2021-01-10 15:01:21', NULL),
(68, '886582', 11, 41, '0', 'Fever \nbody ache', 'cbc\nns-1 antigen', 'rash on body', ' ', '1) Tab.Napa 500\n2) Tab.Fexo 120', '1) 1+1+1 \n2) 0+0+1', '1) 7 day\n2) 30 day', '1) if fever remains', 'take bed rest', '2021-01-10 17:01:27', NULL),
(69, '658633', 3, 42, '0', 'মাথা বেথা', 'মিগ্রাএইন এর বেথা', 'নাই', ' ', 'নাপা', '?+?+?', '????', 'খাবার পর এ খাবেন', 'রাত এ ঘুমাবেন ঠিক  মত', '2021-01-12 18:01:39', NULL),
(70, '385674', 3, 42, '0', 'বুক  বেথা', 'খাবার বদ হজিম', 'নাই', ' ', 'ইনু', '?+?+?', '????', 'খাবার আগে, খুব প্রব্লেম হলে', 'পানি বেশি  বেশী', '2021-01-12 18:01:03', NULL),
(71, '380253', 3, 42, '0', 'কি জন্য', 'নেই', 'নাই', ' ', 'নাপা', '?+?+?', '????', 'ভহরা পেত', 'নাই', '2021-01-12 18:01:48', NULL),
(72, '433163', 11, 41, '0', 'Cough\nshortness of breathing \nSuffocation', 'Cbc, \nCXR p/a view, \nFEV-1', 'chest movement restricted', ' ', '1) Tab.Cefotil 500mg', '1+0+1', '7 days', 'Take with meal', 'maintain 12 hours schedule', '2021-01-16 13:01:54', NULL),
(73, '433163', 11, 41, '0', 'Fever \nShortness of breathing \nSuffocation', 'cbc,\ncxr p/a view,\nFEV-1', 'chest movement restricted', ' ', 'Tab.Fexo 120', '0+0+1', '30 days', 'after meal', 'take just at night', '2021-01-16 14:01:31', NULL),
(74, '27775', 11, 41, '0', 'Abdominal pain,\nVomiting,\nAnorexia', 'Cbc, \nUSG of W.Abdomen,\nEndoscopy', 'Abdominal upset', ' ', '1)Ciprocin 500', '1+0+1', '14 days', 'maintain 12 hours', 'Avoid junk food \nMeal with specific schedule', '2021-01-19 15:01:42', NULL),
(75, '27775', 11, 41, '0', 'a', 'b', '', ' ', '2) Syrp.Gastid', '1+1+1', '30 days', '15 mints after meal', '', '2021-01-19 15:01:02', NULL),
(76, '461142', 11, 41, '0', 'Upsetness,\nSuicidal attempt', 'n/a', 'n/a', ' ', 'n/a', 'n/a', 'n/a', 'n/a', '1) take regular medicine \n2) sleep before 11 Pm\n3) bath with warm water\n4) do regular exercise \n5) avoid fast food', '2021-01-19 15:01:16', NULL),
(77, '707896', 10, 41, '0', 'A', 'd, e, f', 'b, c', ' ', '1) G', '1+0+1', '7 days', 'before meal', 'take complete rest', '2021-01-27 18:01:51', NULL),
(78, '707896', 10, 41, '0', '', '', '', ' ', '2) X', '1+1+1', '14 days', '', '', '2021-01-27 18:01:47', NULL),
(79, '434873', 11, 41, '0', 'a, b, c', 'cbc, sgpt', 'd, e', ' ', '1)x', '1+0+1', '7 days', 'before meal', 'take complete rest', '2021-01-27 21:01:55', NULL),
(80, '434873', 11, 41, '0', '', '', '', ' ', '2) name', '1+0+0', '14 days', '', '', '2021-01-27 21:01:42', NULL),
(81, '345416', 10, 41, '0', 'A, B', 'F, G', 'C, D, E', ' ', 'X', '1+0+1', '7 days', 'before meal', 'take complete bed rest', '2021-01-28 14:01:14', NULL),
(82, '249239', 3, 42, '0', 'fever', 'abcd', 'abc', ' ', 'peracitamol', '1+1+1', '7days', 'abc', '', '2021-01-31 15:01:41', NULL),
(83, '641115', 3, 42, '60', 'fevr', 'none', '', ' ', 'peracitamol', '1+1+1', '7days', '', '', '2021-02-01 23:02:22', NULL),
(84, '641115', 3, 42, '60', '', '', '', ' ', 'omiprazol', '0+0+1', '7days', '', '', '2021-02-01 23:02:52', NULL),
(85, '25881', 3, 42, '96', 'fever', '', '', ' ', 'napa', '1+1+1', '2days', '', '', '2021-02-02 00:02:22', NULL),
(86, '657147', 3, 42, '96', 'neck pain', '', '', ' ', 'peracitamol', '1+0+1', '2days', '', '', '2021-02-02 00:02:00', NULL),
(87, '822405', 10, 41, '97', 'a, b, c', 'f, g, h', 'd, e', ' ', 'x', '1+1+1', '7 days', 'before meal', 'complete bed rest', '2021-02-09 03:02:02', NULL),
(88, '822405', 10, 41, '97', '', '', '', ' ', 'k', '1+0+01', '14 days', 'after meal', '', '2021-02-09 03:02:48', NULL),
(89, '822405', 10, 41, '97', 'a, b, c', 'f, g', 'd, e', ' ', 'x', '1+1+1', '7 days', 'before meal', 'take complete bed rest', '2021-02-09 03:02:57', NULL),
(90, '822405', 10, 41, '97', '', '', '', ' ', 'k', '1+0+0', '14 days', 'after meal', '', '2021-02-09 03:02:45', NULL),
(91, '277642', 10, 41, '99', 'a, b, c', 'f, g, h', 'd, e', ' ', 'Tab.Napa 500', '1+1+1', '7 days', 'if fever remains', 'take complete bed rest', '2021-02-09 04:02:40', NULL),
(92, '277642', 10, 41, '99', '', '', '', ' ', 'Tab.Fexo 120', '0+0+1', '14 days', '', '', '2021-02-09 04:02:38', NULL),
(93, '498333', 10, 41, '98', 'n/a', 'n/a', 'n/a', ' ', 'n/a', 'n/a', 'n/a', 'n/a', 'Diet plat \nxxxxxxx\nxxxxxxx\n.................................\n.....................................\n.....................................xxxxx\nxxxxxxxxxxxxxxxxxxxxxxxxxxx\nxxxxxxxxxxxxxxxxxxxxxxxxxxx', '2021-02-09 05:02:20', NULL),
(94, '886060', 10, 41, '100', '', '', '', ' ', 'n/a', 'n/a', 'n/a', '', '1) abccccccc bbbbbbbbbb bbbb bbbb bbb bbn bbbb bbbbb bbbbbb\n2)aaaaa aaaa aa.. aaaa aaa aa aaa aaa aaa aaaa \n3)kkkk kkk kkkkk kkk kk kk kkk kkk kkkkk\n4)Mmm mmmm mmmmm mmmmmm mmmmmmmm\n5)Ppppp pppp ppppp', '2021-02-09 17:02:19', NULL),
(95, '296928', 3, 42, '95', '', '', '', '\' \'', '', '', '', '', '', '2021-02-14 14:02:35', NULL),
(96, '10142664', 3, 42, '101', 'জর;সরদি;কাসি;', 'ভাইরাস জর', '', 'নাপা- ১+১+১- ৭দিন- খাবার  পর;\nসেক্লু- ০+০+১- ৩দিন- খাবার  আগে', '', '', '', '', 'বেশি বেশি  পানি খাবেন', '2021-02-15 17:02:20', NULL),
(97, '103610271', 10, 41, '103', 'a, b, c', 'f, g, h', 'd, e', '1)x- 1+0+1- 14 days- after meal;\n2)z- 1+1+1- 30 days', '', '', '', '', 'take bed rest', '2021-02-15 18:02:19', NULL),
(98, '104351110', 10, 41, '104', 'Fever ; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin ;', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 dyas;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:41', NULL),
(99, '104275098', 10, 41, '104', 'Fever ; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin ;', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 dyas;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:41', NULL),
(100, '104298367', 10, 41, '104', 'Fever ; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin ;', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 dyas;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:41', NULL),
(101, '104561495', 10, 41, '104', 'Fever ; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin ;', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 dyas;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:41', NULL),
(102, '104305460', 10, 41, '104', 'Fever; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa 500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 days ;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:46', NULL),
(103, '104623705', 10, 41, '104', 'Fever; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa 500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 days ;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:46', NULL),
(104, '104842142', 10, 41, '104', 'Fever; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa 500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 days ;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:46', NULL),
(105, '104896058', 10, 41, '104', 'Fever; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa 500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 days ;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:46', NULL),
(106, '104223725', 10, 41, '104', 'Fever; Body pain; Yellow coloration of urine;', 'CBC; SGPT; S.Bilirubin', 'Yellowish palm; Yellowish sclara', '1)Tab.Napa 500 - 1+1+1 - 7 days - after meal;\n2)Tab.Bost - 0+1+0 - 30 days ;\n3)Tab.Fexo 120 - 0+0+1 - 14 days;', '', '', '', '', 'Take complete bed rest', '2021-02-16 17:02:46', NULL),
(107, '101456444', 3, 42, '101', 'ঢাকা,বাংলাদেশ, ঢাকা,বাংলাদেশ,', 'ঢাকা,বাংলাদেশ,', 'ঢাকা,বাংলাদেশ,', 'বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা. বাংলাদেশ, ঢাকা,রাজশাহি,রংপুর, টাংাইল,কুমিল্লা.', '', '', '', '', 'ঢাকা,বাংলাদেশ,', '2021-02-20 15:02:28', NULL),
(108, '103656136', 10, 41, '103', 'a, b.c', 'f, g, h', 'd.e', '1) X 500 mg 1+0+1 খাবার পরে 7 days. 2) Y 120 mg 0+0+1 খাবার আগে - চলবে', '', '', '', '', 'পর্যাপ্ত পানি খাবেন', '2021-02-20 19:02:42', NULL),
(109, '106917716', 10, 41, '106', 'a,b,c', 'a, b\nc', 'a\nb\nc', '1) aaaaaaa\n2)bbbbbbbbb.3)cccccc', '', '', '', '', 'jjjjjjjjjjjjjjjjjj', '2021-02-20 20:02:43', NULL),
(110, '102902551', 3, 42, '102', 'abc.def.ghi.jkl', 'abc.def.ghi', 'mno.pqr.st', 'abc.\nabavs.\nvshsgsbs.\nvHsbshsgsvxvxbxvxgxbxvxhxvxgx\nvxhxvdgxgdhdhd.', '', '', '', '', '', '2021-02-22 18:02:00', NULL),
(111, '104433216', 10, 41, '104', 'a, b. c', 'a.b.c', 'a,b,c.d.e.f', '1) Tab.X 500mg 1+0+1 7 days খাবার পre.2)Tab Z 120 mg 0+0+1 চলবে.\n3)Syrp Y ২ চামচ করে দিনে ৩ বার', '', '', '', '', 'পর্যাপ্ত পানি খাবেন', '2021-02-23 13:02:31', NULL),
(112, '106873791', 10, 41, '106', 'afgh', 'dhko', 'sgh', 'vhjjkk\'bbbbbbbbbbbb.\nbnnnmmmmm.\nhhjjkkkkkkkk\n1333.\n3455.\ntyuu.\ndghj.\nghjjkk.\nghjkkk.\nrfghhjj.\ntyuiioo.\nbnnkkk.\nyuioccv.\nghji.\nfghjkk.\nghjjk.\nvhjkk.\nguii.\ndtuu.\nghjk.\nghjk.\nghjjk.\nfhjkk.\nvhjkk.\nghjjk.\nghjkk.\nghjkll.\ngjkk.\nxvn.\ncbnmm.\nvbnn.\ncbnm.\ncvbn.\nxvbn', '', '', '', '', '', '2021-02-23 13:02:53', NULL),
(113, '10017410', 10, 41, '100', 'a', 'c', 'b', '1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n10.\n11.\n12.\n13.\n14.\n15.\n16.\n17.\n18.\n19.\n20.\n21.\n22.\n23.\n24.\n25', '', '', '', '', '', '2021-02-23 15:02:19', NULL),
(114, '103651422', 10, 41, '103', '1', '2', '3', '1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n10.\n11.\n12.\n13.\n14.\n15.\n16.\n17.\n18.\n19.\n20.\n21.\n22.\n23.\n24.\n25.\n26.\n27.\n28.\n29.\n30.\n31.\n32.\n33.\n34.\n35.\n36.\n37.\n38.\n39.\n40.\n41.\n42.\n43.\n44.\n45.\n46.\n47.\n48.\n49.\n50', '', '', '', '', '', '2021-02-23 15:02:57', NULL),
(115, '88680303', 11, 41, '88', 'a.b', 'e.f', 'c.d', 'g.h.i.j', '', '', '', '', 'k.l.m', '2021-02-23 15:02:03', NULL),
(116, '101141323', 3, 42, '101', 'sfcv,ggg', 'abc,def,gh', 'cvhh,gvbh', 'svvbb,vhhgbh', '', '', '', '', 'xvggcgh,gghgb,cbjh', '2021-02-24 22:02:23', NULL),
(117, '105813646', 11, 41, '105', 'a,b,c', 'c,d,e', 'a,b', '1)Tab.X 500mg 1+0+1 14 days,\n2)Srp.Z ২ চামচ করে তিন বেলা ৭ দিন,\n3)Cap.V 0+1+1 খাওয়ার আগে ১৪ দিন', '', '', '', '', 'নিয়মিত ওষুধ খাবেন। ১৪ দিন পরে দেখা করবেন।', '2021-02-25 00:02:02', NULL),
(118, '108125299', 11, 41, '108', 'aaaaaaa, bbbbbb', 'eeeee,fffff', 'cccc,dddd', '1)Tab x 500 mg 1+0+1 ৭ দিন,২)Tab.Y 200 mg 0+0+1  14 days,\n3)Cap.z 20 mg 0+1+1 খাবার আগে', '', '', '', '', 'Take complete bed rest, ১৪ দিন পরে আবার আসবেন।', '2021-02-27 18:02:13', NULL),
(119, '109736009', 51, 41, '109', 'fever,throat pain', 'cbc,sgpt', 'aaaaa,', '1) tab. zimax 500 mg 1+0+1 7 days,\n2)Tab.x 20mg 0+1+1 চলবে,\n3)Tab.Y 200 mg 0+0+1 28 days', '', '', '', '', 'নিয়নিত ওষুধ খাবেন, \n১ মাস পরে দেখা করবেন।', '2021-03-01 17:03:41', NULL),
(120, '110653605', 51, 41, '110', 'a', 'c', 'b', 'd', '', '', '', '', 'f', '2021-03-02 16:03:17', NULL),
(121, '112888840', 10, 41, '112', 'ক', 'গ', 'খ', '১) ঘ\n২) চ', '', '', '', '', 'ক্কক্কক্কক্কল', '2021-03-03 10:03:33', NULL),
(122, '117177225', 51, 70, '117', 'weakness', 'cbc', 'bp 100/60', 'vitamin', '', '', '', '', 'n/v after 1 m', '2021-03-06 21:03:34', NULL),
(123, '119155975', 51, 40, '119', 'afds', 'xfd', 'ghjy', 'teb x napa', '', '', '', '', 'hgf', '2021-03-07 12:03:13', NULL),
(124, '120356732', 51, 26, '120', 'fht', 'bhg', 'srt', 'fdey', '', '', '', '', 'bgj', '2021-03-07 13:03:07', NULL),
(125, '121996692', 51, 53, '121', 'hgt', 'iuy', 'bgff', 'hgfvc', '', '', '', '', 'khg', '2021-03-08 19:03:38', NULL),
(126, '122653254', 51, 7, '122', 'jgf', 'hfd', 'jhg', 'jhfc htt', '', '', '', '', 'jhg', '2021-03-08 21:03:39', NULL),
(127, '123771762', 51, 51, '123', 'low', 'TSH', 'anaemia', 'seteafu', '', '', '', '', '', '2021-03-09 17:03:20', NULL),
(128, '124555797', 51, 45, '124', 'Rh', 'Kuyt', 'Gte', 'Talp6yrew ute\nHgfrjj', '', '', '', '', 'Ytt', '2021-03-09 18:03:42', NULL),
(129, '125468590', 51, 46, '125', 'hsur', 'kudb', 'heyxg', 'TabNapa 5\ndfgytd\ndgtycvhjg\nchgfgv', '', '', '', '', 'vgut', '2021-03-10 12:03:33', NULL),
(130, '126916964', 51, 68, '126', 'chestpain', '', '', '1tab. part 1+0+1\n2tab ace 1+0+2(', '', '', '', '', '', '2021-03-13 13:03:00', NULL),
(131, '127470184', 51, 44, '127', '', '', '', 'Syrup CEF-3', '', '', '', '', '', '2021-03-13 20:03:13', NULL),
(132, '12829322', 27, 1, '128', 'bumps on face for 1 year. Unwanted facial hair', 'USG of lower abdomen', '', '1. Tablet rozith 500mg (1 tablet on Tuesday, Wednesday, Thursday every week for 2months), 2. benoxicilin gel 0+0+1 for 2months(apply a thin layer on pimples only), 3. dove soap (wash face twice daily everyday for 4months), 4. sunlock gel (spf30) apply 20minutes before going under the sun & cooking (continue). 5. vaniflo cream (apply on areas of unwanted hair at night) for 2 months.', '', '', '', '', 'apply dove cream if skin is dry or irritated. do the investigation & if cysts are found see a gynaecologist.', '2021-03-15 19:03:32', NULL),
(133, '129692161', 51, 43, '129', 'ঘু', 'fds', 'fgh', 'gtdc', '', '', '', '', 'fgt', '2021-03-17 12:03:16', NULL),
(134, '13064311', 51, 55, '130', 'fever', 'cbc', 'tmp 100', 'napa 500,\n1+0+1 after meal 7 days', '', '', '', '', 'follow up after 7 days', '2021-03-21 17:03:19', NULL),
(135, '131620679', 51, 59, '131', 'fever\ncough for 7 days', 'CBC with ESR', 'chest clrar', 'Tab Napa 500mg,\n1+0+1 for 7 days', '', '', '', '', 'ঠান্ডা খাবেন না', '2021-03-21 20:03:07', NULL),
(136, '132217820', 51, 59, '132', 'ন', 'স', 'ফ', 'র', '', '', '', '', 'এ', '2021-03-21 20:03:24', NULL),
(137, '133716051', 51, 59, '133', 'ক', 'ত', 'ক', 'ত', '', '', '', '', 'ব', '2021-03-21 20:03:04', NULL),
(138, '135672273', 3, 42, '135', 'head ache', 'none', 'none', 'napa 1, ace 2,', '', '', '', '', 'drink plenty of water', '2021-03-22 19:03:21', NULL),
(139, '135568236', 3, 42, '135', 'abc', 'ghi', 'def', 'j,k,l,m,', '', '', '', '', 'abc', '2021-03-22 19:03:38', NULL),
(140, '138186694', 11, 54, '138', 'pain abdomen', 'cbc', 'bp', 'fggjj ghhjj ghhj,\ntab finix\nyy', '', '', '', '', '', '2021-03-22 20:03:09', NULL),
(141, '141258690', 11, 50, '141', 'asdd', 'erttt', 'eewwe', 'rtty', '', '', '', '', 'dxc', '2021-03-24 13:03:13', NULL),
(142, '142986284', 11, 30, '142', 'chest pain', 'ecg', 'tender', 'tab.nidocard,tab.eco', '', '', '', '', 'rest', '2021-03-24 20:03:08', NULL),
(143, '143241614', 11, 68, '143', ',2', 'ab', 'anae', '1napa1+0+1 (7_days,2 anfree 3-', '', '', '', '', '', '2021-03-25 13:03:59', NULL),
(144, '144117898', 3, 42, '144', 'abc', 'ghi', 'def', 'a,b,c,d', '', '', '', '', 'none', '2021-03-26 21:03:53', NULL),
(145, '14497746', 3, 42, '144', 'ahahsh', 'vdhdbdb', 'gagsgs', 'a,b,c,d,e,f', '', '', '', '', 'abcdef', '2021-03-26 21:03:28', NULL),
(146, '147673776', 11, 77, '147', 'Fever , cough,', 'CXR,', 'temp 100,R/R 60min', 'syp, brodil Levo\n 1 t,st ,db', '', '', '', '', 'breast feeding', '2021-03-29 20:03:01', NULL),
(147, '148248769', 11, 77, '148', 'abdominal pain for 3 days', 'Xray abdomen', 'abdomen soft, nontender', 'syp colicon , 1 tsf twice daily', '', '', '', '', 'soft food.', '2021-03-29 20:03:29', NULL),
(148, '149748726', 11, 49, '149', 'fever', 'cbc,uriner/e', 'temp 102', 'tab.nap500\n1+0+1', '', '', '', '', 'tapid spong', '2021-03-31 12:03:47', NULL),
(149, '151973529', 11, 72, '151', 'pain in lower abdomen,Anorexia,weakness,', 'cbc,urine R/E,', '', 'Tab pantonix 20 mg 1+0+1,Tab Algin 1+0+1,', '', '', '', '', 'Rest, take medicines regularly,', '2021-03-31 13:03:17', NULL),
(150, '15225899', 11, 72, '152', 'cough for 3 day\'s,runny nose,shallow breathing,', 'X-ray chest P/A view,', 'pulse -88 b/m,Temp:97,BP:120/75 mm of mer,', 'Tab zimax 500 mg,0+0+1 daily one for 5 days, Tab fexo 120mg,1+0+1 7 days,Tab Monas 10 mg ,0+0+1 15 days,', '', '', '', '', 'নিয়মিত ঔষধ খাবেন,সময় মত রিপোর্ট দেখাবেন, মাস্ক পরবেন ,', '2021-04-04 18:04:27', NULL),
(151, '153803618', 11, 6, '153', 'asd', 'as', 'as', 'ff', '', '', '', '', '', '2021-04-10 18:04:01', NULL),
(152, '155594342', 11, 78, '155', 'ccc', 'nnnn', 'bbb', 'abc', '', '', '', '', '', '2021-04-11 21:04:19', NULL),
(153, '156207135', 11, 26, '156', 'ljgg', 'rrdd', 'ghh', 'tad b111mg,fgg,jjjj,', '', '', '', '', '', '2021-04-12 13:04:28', NULL),
(154, '157975348', 11, 51, '157', 'Low mood', 'FT4', 'Depressed mood', 'Tab Setra 50mg 1+0+0.....Continue, \nTab Oleanz 10mg 0+0+1.....Continue', '', '', '', '', '', '2021-04-12 17:04:55', NULL),
(155, '158922673', 11, 70, '158', 'fever', '', '', 'paracetamol', '', '', '', '', '', '2021-04-12 19:04:59', NULL),
(156, '95363992', 3, 42, '95', 'Head Ace', 'none', 'none', 'take paracitamol,\ntake saline', '', '', '', '', 'meet again in next 7days, show report within 2days', '2021-04-20 13:04:59', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_contact_info`
--

CREATE TABLE `tbl_contact_info` (
  `id` int(11) NOT NULL,
  `address` varchar(300) NOT NULL,
  `email` varchar(255) NOT NULL,
  `number` varchar(255) NOT NULL,
  `terms_condition` text NOT NULL,
  `admin_number` varchar(255) NOT NULL DEFAULT ' ',
  `admin_address` varchar(255) NOT NULL DEFAULT ' ',
  `admin_email` varchar(255) NOT NULL DEFAULT ' '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_contact_info`
--

INSERT INTO `tbl_contact_info` (`id`, `address`, `email`, `number`, `terms_condition`, `admin_number`, `admin_address`, `admin_email`) VALUES
(1, '3rd floor, 15/ka/1, Mirpur Road, Shyamoli, Dhaka-1207', 'info@shasthobd.com', '01400-040404', '\n<div class=\"text\"><p>You have taken the responsibility and agreed upon the following maters:<br><br>\n<h4> 1. Registration: </h4>1.1	To create and access an account in the Shastho BD app, you are an adult and under customary law you are not prohibited from using this app. In case of minority you have given the assurance that your parent or legitimate guardianship have given you permission to use the platform.      \n<br><br>1.2	By registering with Shastho BD app you agree to abide by the Terms and Conditions of Bangladesh in accordance with the laws of Bangladesh. You also agreed not to abuse the the Shastho BD app in any way and to refrain from using this app using any type of application tool or software.\n<br><br>1.3	Attempts to breach security in the Shastho BD app through any type of device, computer, mobile network and attempt to access the app illegally are strictly prohibited.\n<br><br>1.4	 Only a registered account is acceptable to prevent the abuse of the app . Any attempt to create an additional account will be considered invalid.\n<br><br>1.5	The  App is not responsible for any technical errors that are out of its control under any circumstances.\n<br><br>1.6	All the information you provide for registration in the app will be considered accurate and valid in all respects and this information will be stored in a highly confidential manner.\n<br><br>1.7	If you encounter a technical error or difficulty using the  app, please contact us within 24 hours in this mail id info@shasthobd.com .\n<br><br><h4> 2 .Rules of use and conditions:</h4>\n2.1. This is a mobile app intended to connect with the doctors. It will be used only for personal purposes not for commercial purposes .\n<br><br>2.2.  This Shastho BD app will not be used as an emergency clinic and to rely on any information provided by the platform, including testimonials from registered physicians is on your own risk.\n<br><br>2.3.  This Shastho BD app does not provide any official diagnosis or treatment. All information provided by contacting the Shastho BD app that is obtained from the Shastho BD app by a registered physician is for general information purposes only. Under no circumstances does it create a doctor-patient relationship.\n<br><br>2.4.  With this Shastho BD app for personal advice you can talk to a doctor and get medical advice. This  personal advice will not be used for proper diagnosis and physical examination or treatment.If a registered physician participates in a personal online consultation, it will not be considered as your primary care physician by a registered physician. You have agreed not to use this app as an alternative to interacting with your personal physician.\n<br><br>2.5. You need to verify the information about the  doctor\'s qualifications that will be given in theShastho BD app.\n<br><br>2.6.  Shastho BD app services fee are not refundable. If \n       the doctor\'s advice cannot be taken through video      \n      call for any technical reason, it is necessary to \n      contact within 24 hours in this e-mail id info@shasthobd.com . Then our support team will \n      verify your information and contact you within 30 \n      days. Shastho BD app will not be responsible if      \n      you do not communicate within 24 hours.<br><br>2.7.  The Shastho BD app can maintain or remove the  \n       profile of the registered physician in the Shastho \n       BD app at any time at its own discretion. For the \n       purpose of enhancing the quality of service for \n       users and to facilitate informed decision making \n       the app reserve the right to change the profile of \n       the doctor and the users and to exhibit it.<br><br>2.8.  Dedicated physicians are fully responsible for \n      determining the need for more face-to-face \n      consultation. Under no circumstances will the app \n      be liable to exclude any activities that do not \n      detect a faulty diagnosis of a registered physician.<br><br>2.9. Accuracy of all information provided through the \n      Shastho BD app, including any prescriptions \n      issued after consultation by a registered physician \n     all liability rests solely with the registered \n     physician. The Shastho BD app has no liability or \n     responsibility for any interactions that occur \n    outside of the app.<br><br>2.10. All procedures discussed and advertised in the \n        Shastho BD app are for product awareness and \n        instrumentation awareness only. This app does \n        not guarantee the effectiveness of the above \n       mentioned issues. It is up to you to seek the \n       advice of an independent expert to verify this \n       information.<br><br>2.11. All information provided in the app is on an as-    \n        is basis and the platform or any person \n       associated with it does not provide any explicit \n      Warranties regarding the validity of any \n       registered physician\'s license or the accuracy of \n       the app.<br><br>2.12.  This Shastho BD app can also be accessed \n         worldwide and may contain and direct \n         information to questions or services that may      \n         not apply to all countries.<br><br>2.13.  Do not comment which are abusive, obscene, \n         harassing, discriminatory, discriminatory or \n         defamatory material that could tarnish our \n        reputation as a result of which your account may \n        be suspended.<br><br>2.14  Refrain from any activity that harms the  \n         reputation of shastho BD .<br><br>2.15. The Shastho BD app reserves the right to \n        temporarily deactivate your account at its own \n        discretion, subject to security issues and any \n        other reason, including your loyalty showing \n        reasonable grounds.<br><br>2.16.  Bad comments are prohibited and anyone who \n         makes a bad comment will have their account   \n         closed.<br><br>2.17. For the purpose of marketing the Shastho BD  \n        app can reserve and use all the information \n        extract from the platform and share with others \n        provided that your identification will not be \n        disclosed. <br><br>2.18.  Disclosure or posting of personal or    \n         confidential information of others or engaging \n         in such activities may result in suspension of \n        your account.<br><br><h4> 3: Limitations regarding medical services:</h4>3.1. This Shastho BD app cannot be used in emergency \n      medical care. <br><br>3.2. You can only take first aid advice in this shastho \n      BD app. You should consult a licensed physician \n      or specialist before taking any decision or \n      medication after consulting a doctor.<br><br>3.3. Be sure to consult a licensed physician or \n     specialist before making a decision that could \n     jeopardize your own health and the health and \n    safety of your family. This app is not a licensed or \n    regulated medical service provider and does not \n     contain any professional medical advice for illness \n     or condition. This app does not replace any \n     professional medical consultation diagnostic \n     illness system treatment.<br><br>\n	 <h4> 4: Data transfer or sharing:</h4>\n\n    You agree to transfer or share any information you \n    provide in this app to any other organization or \n    affiliate of the shastho BD app in accordance with \n    applicable law.User\'s personal information is \n    protected in accordance with privacy rules.<br><br>\n	<h4> 5: Discharge or impunity</h4>5.1:Compensation for any liability, including claims \n      of copyright and trademark or copyright \n      infringement brought or established against this \n      shastho BD app by any third party which is created \n      for your misconduct than You agree to protect the \n      Platform or Platform related person.<br><br>5.2. No person associated with the Platform is liable \n      for any personal injury or damage caused by your \n      use or misuse of your app to the maximum extent \n      permitted by law.<br><br>\n	  <h4> 6: Changes or amendments to the Terms</h4>6.1. The Platform reserves the right to modify or \n      change the terms at any time at its sole discretion \n      by posting updated terms on the App.<br><br>6.2. It is your responsibility to verify any changes or \n     amendments to the terms. If you do not wish to be \n     bound by the terms than you can log out or quit \n     from the Platform.<br><br><h4> 7: Disclaimer </h4>\n\n     Failure to exercise reluctance to exercise any right      \n     or provision of any right shall be construed as a \n     claim to such right or provision.<br><br><h4> 8: Payment of dues </h4>\n\nAll financial transactions on this platform will be done at your own risk. No debts can be paid except from the gateway of the shastho BD app.<br><br>9: Division\n\n    If for any reason any part of these Terms is \n    deemed invalid, the remainder of the Terms will be \n    deemed to have been fully implemented as far as \n    possible.<br><br> <h4> 10 : Dispute settlement </h4>\n\n     In case of any dispute between the parties \n     concerned, this platform encourages amicable \n      settlement. In case of any dispute or complaint \n     regarding the transaction, please contact this \n     address info@shasthobd.com . If the dispute is \n     not resolved within 30 days, such dispute will be \n     referred to arbitration as per Bangladesh Alisha in \n     2001.<br><br> <h4> 11: Privacy Policy </h4>\n<br><br>\n<strong>The following information will be collected for the  app :</strong>\n<br><br> 11. 1. (1) Full name <br>\n          (2)Password  <br>\n          (3) Gender <br>\n          (4) Date of birth <br> \n          (5) Weight <br>\n          (6) Phone number. <br>\n\n<br><br>11.2. Personal information :\n\n           (1) Image  <br>\n           (2) Blood group <br>\n           (3) Previous personal health information <br>\n          (4) Existing health information  <br>\n           (5) Family medical profile <br>\n           (6) Symptoms. <br>\n           (7) Any other information shared with the \n                platform.<br>\n\n<br><br><h4> 12: Data collection </h4>\n\n<br><br>12.1. Your information with the app services \n         including device ID, device type including RTR \n        model, operating system and other device \n        identifiers with version and mobile network \n        information, location information, computer and \n        connection information tracking and advertising \n        IP addresses from the page viewing statistics \n        app includes the information they collect and \n        other information but not limited to.\n\n<br><br>12.2. Any personal information you have provided in \n        this app for conversation, resolution or shared \n        from any other application. Other information \n        that is requested from you in a timely manner as \n        needed,\n\n<br><br>12.3. Information about transactions in the app and \n       other information about you and the bill on the \n       platform.\n\n<br><br>12.4. Identifier general information or generic \n       information and their aggregates collected to \n       improve design with platforms and services.\n\n<br><br>12.5: Non personal information based on the use of \n        the platform such as third-party service \n        providers such as Google Analytics when you \n        use the platform and other partners may collect \n        personal information, including your IP address, \n        from cookie server log and similar technologies \n        on your mobile device.\n\n<br><br>12.6. Your conversation with the doctor may be \n         preserved for training or the improvement of \n         service.\n\n<br><br>12.7. We use data hosting service providers so your \n        information may be transferred and stored on \n         servers in Bangladesh and beyond . This app \n         maintains control over your information. We \n         use technical and administrative security to \n         protect and secure your information. Some of \n        the security measures we use and firewalls and \n        data encryption control personal access to our   \n        data centers.<br><br>\n		<h4> 13. Mode of using your information: </h4>\n<br><br>13.1. The information collected enables users and  \n                    registered physicians to conduct consultations \n                    and perform app-related tasks. \n<br><br>13.2. Outside of this policy, the app will not share your     \n                    personally identifiable or transaction information \n                    with any person. \n<br><br> 13.3. To verify your account we will sent you opt \n                   massage. All other information will be informed to    \n                   you by sending sms. You can stop it by closing the \n                   account. In case of infringement of privacy by \n                  sending sms the platform will not be responsible.  \n<br><br>\n14. Pharmacy Terms & Conditions\n<br>\n If you continue to browse and use this website, you are agreeing to comply with and be bound by the following terms and conditions of use.\n<br>\nIf you disagree with any part of these terms and conditions, please do not use our website.\n<br>\nShasthobd.com is a platform for their nominated pharmacy or medical store where they (pharmacy & medical store) sales their products using this site. \n<br>Any complaints related to the quality, validity or legality of products will be managed by themself & Shasthobd.com will not take any responsibility. \n<br>\nSales invoice will show the sellers name for any further legal fact.\n<br>\nNeither we nor any of our partners (service providers or nominated stores) provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.\n<br>\nYour use of any information or materials on this website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services or information available through this website meet your specific requirements.\n<br><br>\n15.CANCELLATION & REFUND FOR BELOW SERVICES ARE NOT ELIGIBLE:\n<br>\nOnline Dr.Consultation \n<br>\nLab test & COVID Sample Collection\n<br>\nPhysio & Occupational Therapy \n<br>\nHealth checkup packages\n<br>\nE-Pharmacy\n<br><br>\nThank you\n</p>\n</div>', '01966622262', ' 3rd floor, 15/ka/1, Mirpur Road, Shyamoli, Dhaka-1207', ' dr.shasthobd@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_coupons`
--

CREATE TABLE `tbl_coupons` (
  `id` int(111) NOT NULL,
  `coupon_code` varchar(255) NOT NULL,
  `discount_percent` varchar(255) NOT NULL,
  `discount_type` varchar(30) NOT NULL DEFAULT 'percent',
  `doctor_type` varchar(30) NOT NULL DEFAULT 'all',
  `quantity` int(111) NOT NULL DEFAULT 0,
  `used_quantity` int(111) NOT NULL DEFAULT 0,
  `max_use_per_user` int(111) NOT NULL DEFAULT 1,
  `coupon_status` varchar(255) NOT NULL DEFAULT 'active',
  `expiry_date` date NOT NULL DEFAULT '2021-10-01',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_coupons`
--

INSERT INTO `tbl_coupons` (`id`, `coupon_code`, `discount_percent`, `discount_type`, `doctor_type`, `quantity`, `used_quantity`, `max_use_per_user`, `coupon_status`, `expiry_date`, `created_at`, `updated_at`) VALUES
(6, 'SHASTHOBD', '200', 'fixed', 'General Practitioner', 0, 0, 1, '1', '2021-12-05', '2021-03-30 15:18:45', '2021-03-30 15:18:45'),
(5, '10TKOFF', '10', 'fixed', 'General Practitioner', 0, 0, 1, '1', '2021-05-15', '2021-03-29 17:30:16', '2021-03-29 17:30:16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_doctor`
--

CREATE TABLE `tbl_doctor` (
  `DOCID` bigint(20) NOT NULL,
  `DocName` varchar(200) DEFAULT NULL,
  `DocDegree` varchar(200) DEFAULT '',
  `BmdcReg` varchar(255) DEFAULT '',
  `JsonTime` text NOT NULL,
  `DocAddress` varchar(200) DEFAULT NULL,
  `DocType` varchar(200) DEFAULT NULL,
  `ReasonID` varchar(200) DEFAULT NULL,
  `HospitalID` varchar(300) DEFAULT NULL,
  `SpecialArea` varchar(200) DEFAULT NULL,
  `MobileNum` varchar(200) DEFAULT NULL,
  `Password` varchar(200) DEFAULT NULL,
  `Remarks` varchar(200) DEFAULT '',
  `Active` varchar(50) DEFAULT '',
  `Status` varchar(50) DEFAULT '',
  `StartDuty` varchar(50) DEFAULT '',
  `EndDuty` varchar(50) DEFAULT '',
  `Created_at` datetime(6) DEFAULT current_timestamp(6),
  `Updated_at` datetime(6) DEFAULT current_timestamp(6),
  `Payment` varchar(200) DEFAULT '',
  `followup` varchar(30) NOT NULL DEFAULT 'N',
  `general_payment` varchar(255) NOT NULL DEFAULT '0',
  `followup_payment` varchar(255) NOT NULL DEFAULT '0',
  `report_showing_payment` varchar(255) NOT NULL DEFAULT '0',
  `counseling_payment` varchar(255) NOT NULL DEFAULT '0',
  `DocImage` varchar(200) DEFAULT '',
  `fileName` varchar(255) DEFAULT '',
  `DocSignature` varchar(300) NOT NULL DEFAULT ' ',
  `fileNameSignature` text NOT NULL,
  `Gen_Prac` varchar(50) DEFAULT '',
  `OtherPfID` varchar(50) DEFAULT '',
  `DayOfPractice` varchar(200) DEFAULT '',
  `Weight` varchar(50) DEFAULT '',
  `Gender` varchar(50) DEFAULT '',
  `DOB` date DEFAULT NULL,
  `Email` varchar(200) DEFAULT '',
  `added_by` varchar(255) DEFAULT ' ',
  `ordering` int(111) NOT NULL DEFAULT 1,
  `updated_by` varchar(255) NOT NULL DEFAULT ' '
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_doctor`
--

INSERT INTO `tbl_doctor` (`DOCID`, `DocName`, `DocDegree`, `BmdcReg`, `JsonTime`, `DocAddress`, `DocType`, `ReasonID`, `HospitalID`, `SpecialArea`, `MobileNum`, `Password`, `Remarks`, `Active`, `Status`, `StartDuty`, `EndDuty`, `Created_at`, `Updated_at`, `Payment`, `followup`, `general_payment`, `followup_payment`, `report_showing_payment`, `counseling_payment`, `DocImage`, `fileName`, `DocSignature`, `fileNameSignature`, `Gen_Prac`, `OtherPfID`, `DayOfPractice`, `Weight`, `Gender`, `DOB`, `Email`, `added_by`, `ordering`, `updated_by`) VALUES
(1, 'Dr. Tasnim Tamanna Haque', 'DCDD , Fellowship in Laser Surgery (Thailand)', 'A55582', '{\"Saturday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"},\"Sunday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"},\"Monday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"},\"Tuesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"},\"Wednesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"},\"Thursday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"},\"Friday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:30:00\"}}', '', 'Specialist', '', 'Skinage Dermacare', '7', '01841754624', '#Tasharar0714', '', '1', '1', '00:00:00', '00:00:00', '2020-09-17 17:07:56.000000', '2021-03-13 18:47:34.000000', '10', 'N', '10', '10', '10', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600340876Dr-770x869.jpg', '1600340876Dr-770x869.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '65', 'Female', '2021-03-07', 'dr.tamanna07@gmail.com', '8', 10, 'shasthobd'),
(2, 'Dr. Md. Nazmul Hoque Masum', '–MBBS(DMC),FCPS(Surgery), FICS,FACS(USA)', 'A35555', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Dhaka Medical College', '13', '01717057884', '01717057884', '', '1', '1', '00:00:00', '00:00:00', '2020-09-18 17:53:40.000000', '2021-01-23 21:37:35.000000', '1200', 'N', '1200', '1200', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600430020pic.jpeg', '1600430020pic.jpeg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-18', 'nazmul53@yahoo.com', '8', 10, 'shasthobd'),
(18, 'Dr. Md. Mushfiqur Rahman', 'MS (Cardio-Vascular Surgery), MBBS(SSMC), BCS (Health)', 'A-54585', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'Specialist', '', 'National Institute of Cardiovascular Diseases and Hospital (NICVD)', '17', '01854866095', '01854866095', '', '0', '1', '00:00:00', '00:00:00', '2020-09-20 12:37:57.000000', '2021-01-23 21:35:36.000000', '600', 'N', '600', '600', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600583877Mushfiqur_Rahman__pic.jpg', '1600583877Mushfiqur_Rahman__pic.jpg', '', '', 'N', '', 'Saturday,Monday,Wednesday', '', 'Male', '2020-09-20', 'mushfiq_ssmc@yahoo.com', '8', 10, 'shasthobd'),
(4, 'Dr. Krishna kumar Das', 'MBBS, MCPS (surgery),  FCPS (surgery)', 'A 53335', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Shaheed Tajuddin Ahmad Medical college Hospital,Gazipur', '13,12', '01717583637', '01717583637', '', '1', '1', '00:00:00', '00:00:00', '2020-09-18 19:15:24.000000', '2021-01-23 21:37:52.000000', '600', 'N', '600', '200', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600434924840-20200212200552.jpg', '1600434924840-20200212200552.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-18', 'drkrishna45@gmail.com', '8', 10, 'shasthobd'),
(5, 'Dr.Sharmin Sultana Rijvy', 'BDS(DU), MSS(DU), PGT (OMS & CONS) ', '3926', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"18:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"18:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"18:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"18:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"18:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"18:00:00\"}}', '', 'Specialist', '', 'Technodent Dental Clinic', '16', '01717642526', '01717642526', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 12:58:26.000000', '2021-04-11 15:45:35.000000', '12', 'N', '12', '600', '10', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600498706facebook_1597663815924_6701087733788650891.jpg', '1600498706facebook_1597663815924_6701087733788650891.jpg', 'http://103.108.140.210:8000/uploads/doctorFile/5_1602306859.png', '5_1602306859.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2020-09-19', 'ssrijvy@gmail.com', '8', 10, 'shasthobd'),
(6, 'Dr. Jinnat Ara  Islam                       (Associate Professor Gynae & Obs)', 'DGO (Gynae & Obs), FCPS (Gynae & Obs)', 'A-31367', '{\"Saturday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Tuesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Thursday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'Specialist', '', 'Shaheed Suhrawardy Medical College & Hospital', '2', '01711184306', '01711184306', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 13:14:58.000000', '2021-04-12 03:26:49.000000', '600', 'N', '600', '600', '250', '0', 'https://app.shasthobd.com/applications/docImg/1616838059Jinat-ara-islam-removebg-preview.png', '1616838059Jinat-ara-islam-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1616838059drjinnatarasig.png', '1616838059drjinnatarasig.png', 'N', '', 'Saturday,Monday,Tuesday,Thursday', '', 'Female', '2020-09-19', 'drjinnatara@gmail.com', '8', 10, 'shasthobd'),
(14, 'Pro.Dr.Md. Nurul Gani', '–M.B.B.S, E.C.G.P, Diploma Asthma in (U.K), C- Card(NHF), MD, P hd (Japan)', '', '{\"Saturday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Monday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Wednesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"}}', '', 'Specialist', '', 'Life line medical services ltd ', '1', '01620217442', '01620217442', '', '0', '1', '00:00:00', '00:00:00', '2020-09-19 15:16:51.000000', '2021-01-23 21:35:17.000000', '600', 'N', '600', '600', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600507011IMG_20200818_114857819_2.jpg', '1600507011IMG_20200818_114857819_2.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-09-19', 'dr.n.goni@gmail.com', '8', 10, 'shasthobd'),
(7, 'Dr. Debdulal Debnath    (Associate Professor)', 'MBBS, D-Ortho', '27191', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Northern International Medical College,', '15', '01715591229', '01715591229', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 13:31:54.000000', '2021-03-15 16:12:10.000000', '600', 'N', '600', '600', '250', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600500714image0.jpeg', '1600500714image0.jpeg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-09-19', 'drdebdulal@gmail.com', '8', 10, 'shasthobd'),
(8, 'Dr Nujhat Ahmed', 'MBBS', 'A95561', '{\"Saturday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"},\"Sunday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"},\"Monday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"},\"Tuesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"},\"Wednesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"},\"Thursday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"},\"Friday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"23:00:00\"}}', '', 'General Practitioner', '3,9,1,4,2,6,7,8,5', 'Rowangchori Upazilla health complex,Bandarbans', '', '01620231924', '01620231924', '', '0', '1', '00:00:00', '00:00:00', '2020-09-19 13:43:06.000000', '2021-02-24 14:55:00.000000', '10', 'N', '10', '99', '10', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600501386FB_IMG_1595494760175.jpg', '1600501386FB_IMG_1595494760175.jpg', '', '', 'Y', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '45', 'Female', '2020-09-19', 'hridita.dmc53@gmail.com', '8', 10, 'shasthobd'),
(9, 'Md. Asif Arsalan', 'MPT (Orthopedic) India, Phd (pursuing) Cancer rehabilitation, Faculty of medicine, University of Malaya, Malaysia', '', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Other Professional', '', 'K&K Pain & Rehabilitation center Saidpur', '', '01676584711', '01676584711', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 13:52:19.000000', '2021-03-06 13:47:34.000000', '600', 'N', '600', '600', '250', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600501939pic.jpg', '1600501939pic.jpg', '', '', 'N', '1', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-09-19', 'md.asifarsalan@gmail.com', '8', 10, 'shasthobd'),
(28, 'Dr. Md. Abul Kalam Azad    (Assistant Professor)', 'MBBS,  FCPS(Surgery)', 'A-37485', '{\"Sunday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Tuesday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Thursday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Friday\":{\"StartTime\":\"10:30:00\",\"EndTime\":\"12:00:00\"}}', '', 'Specialist', '', 'Dhaka Medical College Hospital', '12', '01712222182', '01712222182', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 13:58:36.000000', '2021-01-23 21:36:59.000000', '600', 'N', '600', '600', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600675116received_957895258012742.jpeg', '1600675116received_957895258012742.jpeg', '', '', 'N', '', 'Sunday,Tuesday,Thursday,Friday', '', 'Male', '2020-09-21', 'azad9425@gmail.com', '8', 10, 'shasthobd'),
(29, 'Dr. Abdul Matin (Asso. Prof.)', 'MBBS, BCS, MD(Pediatrics)', '', '{\"Saturday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Sunday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Monday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Tuesday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Wednesday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Thursday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Friday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"}}', '', 'Specialist', '', 'Popular Diagnostic Centre Ltd. (Shyamoli Branch)', '3', '01819261278', '01819261278', '', '0', '1', '00:00:00', '00:00:00', '2020-09-21 14:05:04.000000', '2021-01-23 21:36:51.000000', '600', 'N', '600', '600', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600675504134-20190202171259.jpg', '1600675504134-20190202171259.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-21', '', '8', 10, 'shasthobd'),
(11, 'Aysha Siddika', 'MSC ( Food and Nutrition)', '', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"}}', '', 'Other Professional', '', 'Japan Bangladesh Friendship Hospital Dhanmondi', '', '01819450216', '01819450216', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 14:18:02.000000', '2021-01-23 21:38:36.000000', '900', 'N', '900', '900', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/160050348298262514_1702437843238481_3821147508927627264_n.jpg', '160050348298262514_1702437843238481_3821147508927627264_n.jpg', '', '', 'N', '3', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2020-09-19', 'aysha.siddika07@gmail.com', '8', 2, 'shasthobd'),
(13, 'Dr. Utpala Mazumder            (Assistant Professor Gynae & Obs)', 'MBBS, FCPS, MS (Gynae & Obs)', '26038', '{\"Saturday\":{\"StartTime\":\"22:00:00\",\"EndTime\":\"23:30:00\"},\"Sunday\":{\"StartTime\":\"22:00:00\",\"EndTime\":\"23:30:00\"},\"Monday\":{\"StartTime\":\"22:00:00\",\"EndTime\":\"23:30:00\"},\"Tuesday\":{\"StartTime\":\"22:00:00\",\"EndTime\":\"23:30:00\"},\"Wednesday\":{\"StartTime\":\"22:00:00\",\"EndTime\":\"23:30:00\"},\"Thursday\":{\"StartTime\":\"22:00:00\",\"EndTime\":\"23:30:00\"}}', '', 'Specialist', '', 'Dhaka Medical college &  Hospital', '2', '01712505264', '01712505264', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 15:07:15.000000', '2021-03-29 19:23:39.000000', '750', 'N', '750', '750', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600506435166-20190202171301.jpg', '1600506435166-20190202171301.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2020-09-19', '', '8', 10, 'shasthobd'),
(15, 'Dr. A.T.M. Ashadullah            (Assoc. Professor Neurosurgery)', 'Fellowship Training in Neuroendoscopic surgery(Brain & Spine) , Trained in Skull-Base and Micro Neurosurgery from AIIMS,India', 'A- 29079', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:30:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:30:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:30:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:30:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:30:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:30:00\"}}', '', 'Specialist', '', 'National Institute of Neurosciences & Hospital', '8', '01715508550', '01715508550', '', '1', '1', '00:00:00', '00:00:00', '2020-09-19 15:27:38.000000', '2021-02-01 16:43:39.000000', '950', 'N', '950', '950', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600507658Dr._A.T.M._Ashadullah_poc.jpg', '1600507658Dr._A.T.M._Ashadullah_poc.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-09-19', 'asad8550@yahoo.com', '8', 10, 'shasthobd'),
(20, 'Dr. Md. Asraful Habib', 'MBBS, MPH ', 'A-68255', '{\"Saturday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"},\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"},\"Monday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"},\"Wednesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"},\"Friday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"23:00:00\"}}', '', 'General Practitioner', '3,9,1,4,2,6,7,8,5', 'BADAS TB institute, Diabetic Association of Bangladesh ,BIRDEM', '', '01558107101', '01558107101', '', '1', '1', '00:00:00', '00:00:00', '2020-09-20 13:04:35.000000', '2021-03-30 15:24:57.000000', '250', 'N', '250', '98', '51', '0', 'https://app.shasthobd.com/applications/docImg/1615889292HABIB-removebg-preview_(1).png', '1615889292HABIB-removebg-preview_(1).png', '', '', 'Y', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-20', '', '8', 4, 'shasthobd'),
(75, 'DR MD ASRAFUL ALAM', 'MBBS, CO', 'A-49225', '{\"Saturday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"},\"Sunday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"},\"Monday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"},\"Tuesday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"},\"Wednesday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"},\"Thursday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"},\"Friday\":{\"StartTime\":\"13:00:00\",\"EndTime\":\"22:30:00\"}}', '', 'Specialist', '', 'Z H SIKDER WOMEN\'S MEDICAL COLLEGE & HOSPITAL', '9', '01717055320', '01717055320', '', '1', '1', '00:00:00', '00:00:00', '2021-03-16 17:11:20.000000', '2021-03-20 12:47:08.000000', '500', 'N', '500', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2021-03-16', '', '', 10, 'shasthobd'),
(19, 'Dr. A.H.M. Sufian', 'FCGP, CCD, DOC, C-Asthma', 'A-67858', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'General Practitioner', '3,9,1,4,2,6,7,8,5', 'Aabesh Medical Center', '', '01552558200', '01552558200', '', '1', '1', '00:00:00', '00:00:00', '2020-09-20 12:54:56.000000', '2021-03-30 15:25:27.000000', '250', 'N', '250', '99', '50', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600584896107722206_10224401071277249_8295381754979644890_n.jpg', '1600584896107722206_10224401071277249_8295381754979644890_n.jpg', 'http://103.108.140.210:8000/uploads/doctorFile/19_1602305945.png', '19_1602305945.png', 'Y', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-20', 'dr.sufiandawn@gmail.com', '8', 10, 'shasthobd'),
(21, 'Dr.Mohammad Abul Kalam Azad', 'MBBS, FCPS (Medicine), MD (Rheumatology)', 'A-31057', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"}}', '', 'Specialist', '', 'IBN SINA MEDICAL BADDA BRANCH', '1,22', '01911099075', 'Akazad2211', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 12:30:15.000000', '2021-04-01 14:12:10.000000', '750', 'N', '750', '750', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617096683Dr.-Mohammed-Abul-Kalam-Azad-removebg-preview.png', '1617096683Dr.-Mohammed-Abul-Kalam-Azad-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1617096518dr_abu_kalam-removebg-preview.png', '1617096518dr_abu_kalam-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '62', 'Male', '1974-01-10', 'akazadmmc92@gmail.com', '8', 10, 'shasthobd'),
(22, 'Dr. Fatama Akter Chowdhury Chomon', 'MBBS, MS (General Surgery), MRCS (England), MCPS ( Surgery)', 'A-54178', '{\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"}}', '', 'Specialist', '', 'Dhaka Medical College Hospital', '13,30,12', '01841266239', '01841266239', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 12:35:12.000000', '2021-02-03 14:36:44.000000', '750', 'N', '750', '750', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600670112Screenshot_2020-09-20_at_3.09.54_pm.png', '1600670112Screenshot_2020-09-20_at_3.09.54_pm.png', '', '', 'N', '', 'Sunday,Thursday', '', 'Female', '2020-09-21', 'chomon.k61dmc@gmail.com', '8', 10, 'shasthobd'),
(23, 'Dr. Kuntal Roy    (Asst.Professor)', 'MBBS, DCH, FCPS (Pediatrics)', 'A-44243', '{\"Saturday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Sunday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Monday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Tuesday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Wednesday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Thursday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"},\"Friday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"14:00:00\"}}', '', 'Specialist', '', 'Anwer Khan Modern Medical College', '3', '01728567850', '01728567850', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 12:43:52.000000', '2021-02-24 14:12:45.000000', '750', 'N', '750', '750', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600670632Dr._Kuntal_Roy_picture.jpg', '1600670632Dr._Kuntal_Roy_picture.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-21', 'ripon318@yahoo.com', '8', 10, 'shasthobd'),
(25, 'Brigadier General(Retd) Professor Dr. Md. Azizul Islam', 'MBBS, FCPS (Psychiatry), FRCP(uk)', '', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"}}', '', 'Specialist', '', 'Square Hospital Ltd.', '19', '01716898085', '01716898085', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 13:23:42.000000', '2021-01-23 21:36:35.000000', '1200', 'N', '1200', '1200', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/160067302269004845_108848937151152_8262520395983224832_n_(1).jpg', '160067302269004845_108848937151152_8262520395983224832_n_(1).jpg', '', '', 'N', '', 'Saturday,Monday,Thursday', '', 'Male', '2020-09-21', '', '8', 10, 'shasthobd'),
(26, 'Dr. Muhammad Kamrul Hassan       (Physical Medicine, Rehabilitation, Pain, Paralysis & Sports Injury Specialist)', 'MBBS, FCPS (Physical Medicine, Rehabilitation, Pain, Paralysis & Sports Injury Specialist)', 'A-38989', '{\"Saturday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"14:00:00\"},\"Sunday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"14:00:00\"},\"Monday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"14:00:00\"},\"Tuesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"14:00:00\"},\"Wednesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"14:00:00\"},\"Thursday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"14:00:00\"}}', '', 'Specialist', '', 'Ibn Sina Diagnostic & Consultation Center. ( Badda Branch)', '25,26', '01816320739', '01816320739', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 13:40:12.000000', '2021-04-12 03:27:52.000000', '12', 'N', '12', '600', '10', '0', 'https://app.shasthobd.com/applications/docImg/1617263560Dr.-Muhammad-Kamrul-Hassan.jpg', '1617263560Dr.-Muhammad-Kamrul-Hassan.jpg', 'https://api.shasthobd.com/uploads/doctorFile/26_1615100158.png', '26_1615100158.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-09-21', '', '8', 10, 'shasthobd'),
(27, 'Dr. Md. Toufiqur Rahman   (Professor and Head of Cardiology)  ', 'MD (Card), FCPS (Med) FACC (USA), FACP, FASE FSCAI, FRCP, FCCP, FESC, FAHA, FAPSIC', 'A-27454', '{\"Saturday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"},\"Sunday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"},\"Monday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"},\"Tuesday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"},\"Wednesday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"},\"Thursday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"},\"Friday\":{\"StartTime\":\"14:30:00\",\"EndTime\":\"23:00:00\"}}', '', 'Specialist', '', 'Medinova Medical Services Ltd. (Malibagh)', '4', '01777751251', '01777751251', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 13:47:31.000000', '2021-04-01 15:34:06.000000', '1200', 'N', '1200', '1200', '0', '0', 'https://app.shasthobd.com/applications/docImg/1617269646toufiqur_sir-png.png', '1617269646toufiqur_sir-png.png', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-21', 'drtoufq1771@gmail.com', '8', 10, 'shasthobd'),
(30, 'Prof. Dr. Md. Golam Kibria', 'MBBS, MS, (Cardiac Surgery)', 'A-12225', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"18:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"18:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"18:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"18:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"18:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"18:00:00\"}}', '', 'Specialist', '', 'Victoria Healthcare Ltd.', '4', '01819995431', '01819995431', '', '1', '1', '00:00:00', '00:00:00', '2020-09-21 14:38:50.000000', '2021-04-01 15:07:12.000000', '600', 'N', '600', '1200', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617268032Screenshot_20210401-133214-970-removebg-preview_(1).png', '1617268032Screenshot_20210401-133214-970-removebg-preview_(1).png', 'https://app.shasthobd.com/applications/docImg/1617262860drgolamkibriasigpng.png', '1617262860drgolamkibriasigpng.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-09-21', 'mgl.kibria@gmail.com', '8', 10, 'shasthobd'),
(31, 'Dr. Shoib Ahmed', 'MBBS, MPH(BSMMU), CCD(BIRDEM), MRCP(on course),  Fellow NCD (UK)', 'A-73101', '{\"Saturday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"},\"Sunday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"},\"Monday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"},\"Tuesday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"},\"Wednesday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"},\"Thursday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"},\"Friday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:00:00\"}}', '', 'Specialist', '', 'BSMMU-Bangabandhu Sheikh Mujib Medical University', '24', '01914864956', '01914864956', '', '1', '1', '00:00:00', '00:00:00', '2020-09-23 15:34:27.000000', '2021-01-23 21:34:57.000000', '750', 'N', '750', '750', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600853864IMG20200922215305.jpg', '1600853864IMG20200922215305.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-23', 'shuvro03101988@gmail.com', '8', 10, 'shasthobd'),
(32, 'Dr. Md. Tariqul Islam  (Asst. Prof.)     Head & Neck Surgeon', 'MBBS, FCPS(ENT), MS(ENT)', 'A-34638', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'National Institute of Cancer Research & Hospital, Mohakhali, Dhaka', '11', '01714216559', '01714216559', '', '1', '1', '00:00:00', '00:00:00', '2020-09-23 15:47:56.000000', '2020-11-09 11:05:59.000000', '750', 'N', '750', '750', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600854476IMG_20200923_141302.jpg', '1600854476IMG_20200923_141302.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2020-09-23', 'drtariqulislam80153@gmail.com', '8', 10, 'shasthobd'),
(33, 'Sufia Khatun (Helen)', '– IDD, ICU, GDM, Nutritional care Pre-Conception During pregnancy and postpartum etc.', '', '{\"Saturday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Sunday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Tuesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Wednesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Thursday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'Other Professional', '', 'Anwar Khan Modern Medical College Hospital  Dhanmondi, Dhaka', '', '01714244452', '01714244452', '', '1', '1', '00:00:00', '00:00:00', '2020-09-23 17:04:54.000000', '2021-01-23 21:34:44.000000', '600', 'N', '600', '600', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600859094SAVE_20200819_103406.jpg', '1600859094SAVE_20200819_103406.jpg', '', '', 'N', '3', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2020-09-23', 'helensufiakhatun@gmail.com', '8', 10, 'shasthobd'),
(34, 'Jayoti Mukherjee', 'B.Sc , M.sc', '', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Other Professional', '', 'Surecell Medical BD', '', '01755651696', '01755651696', '', '1', '1', '00:00:00', '00:00:00', '2020-09-24 13:55:42.000000', '2021-01-23 21:34:34.000000', '850', 'N', '850', '850', '0', '0', 'http://103.108.140.210:85/shasthobdAdmin/applications/docImg/1600934142IMG_4938.jpeg', '1600934142IMG_4938.jpeg', '', '', 'N', '3', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Female', '2020-09-24', 'jayoti08@gmail.com', '8', 1, 'shasthobd'),
(56, 'DR. GOLAM SAGIR                                              (Asst. Professor )', 'MBBS, FCPS (Medicine), FCPS (Neuro Medicine, Thesis)          ', 'A-36317', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Wednesday\":{\"StartTime\":\"09:00:00\",\"EndTime\":\"15:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Friday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'Specialist', '', 'National Institute of Neurosciences & Hospital', '1,8', '01960343125', '01960343125', '', '1', '1', '00:00:00', '00:00:00', '2021-02-01 16:36:34.000000', '2021-03-23 16:30:47.000000', '12', 'N', '12', '0', '10', '0', 'https://app.shasthobd.com/applications/docImg/1612175794pro_2166.jpg', '1612175794pro_2166.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2021-02-01', '', '8', 10, 'shasthobd'),
(42, 'Demo Doctor', 'mbbs', 'a5523', '{\"Saturday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"},\"Sunday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"},\"Monday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"},\"Tuesday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"},\"Wednesday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"},\"Thursday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"},\"Friday\":{\"StartTime\":\"01:00:00\",\"EndTime\":\"23:30:00\"}}', '', 'Specialist', '', 'test hospital', '4', '01521466045', '01521466045', '', '1', '1', '00:00:00', '00:00:00', '2021-01-07 12:52:45.000000', '2021-04-13 00:41:48.000000', '210', 'N', '210', '10', '10', '210', 'https://app.shasthobd.com/applications/docImg/1618252908300x300.jpg', '1618252908300x300.jpg', 'https://app.shasthobd.com/applications/docImg/1618252908300x80.jpg', '1618252908300x80.jpg', 'N', '1', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2021-01-07', '', '1', 10, 'shasthobd'),
(41, 'Test', 'MBBS,  FCPS ', 'A-00000', '{\"Saturday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Sunday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Monday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Tuesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Wednesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Thursday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Friday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"}}', '', 'Specialist', '', 'A', '1', '01911004334', '01911004334', '', '1', '1', '00:00:00', '00:00:00', '2020-12-30 16:27:58.000000', '2021-03-10 14:45:17.000000', '15', 'N', '15', '14', '12', '0', 'https://api.shasthobd.com/uploads/doctorFile/41_1613468283.png', '41_1613468283.png', 'https://api.shasthobd.com/uploads/doctorFile/41_1614680525.png', '41_1614680525.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '83', 'Male', '2020-12-30', '', '8', 10, 'shasthobd'),
(40, 'Dr. Md.Rezaul Islam (Hira)', 'MBBS , MCPS , FCPS', 'A-29359', '{\"Saturday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"24:00:00\"},\"Sunday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"24:00:00\"},\"Monday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"24:00:00\"},\"Tuesday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"24:00:00\"},\"Wednesday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"24:00:00\"},\"Thursday\":{\"StartTime\":\"11:00:00\",\"EndTime\":\"24:00:00\"}}', '', 'Specialist', '', 'Universal Medical College Hospital', '7', '01711521405', '01711521405', '', '1', '1', '00:00:00', '00:00:00', '2020-12-28 16:08:05.000000', '2021-03-31 16:52:04.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617187924IMG-20201109-WA0039__1_-removebg-preview.png', '1617187924IMG-20201109-WA0039__1_-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1617187924CamScanner_03-31-2021_16.46-removebg-preview.png', '1617187924CamScanner_03-31-2021_16.46-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2020-12-28', 'dr.hiradmc47@yahoo.com', '8', 10, 'shasthobd'),
(43, 'DR. Md. Jobayer Hossain          (Physical Medicine, Rehabilitation, Pain, Paralysis & Sports Injury Specialist)', 'MBBS, MD, FIPM(India) ', 'A-47195', '{\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Monday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Wednesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"16:00:00\"}}', '', 'Specialist', '', 'Dhaka Pain & Spine Center', '25,26', '01842626331', '01842626331', '', '1', '1', '00:00:00', '00:00:00', '2021-01-11 15:26:10.000000', '2021-03-17 12:39:17.000000', '12', 'N', '12', '200', '10', '0', 'https://app.shasthobd.com/applications/docImg/1610357170dr.-jobayer.jpg', '1610357170dr.-jobayer.jpg', '', '', 'N', '', 'Sunday,Monday,Tuesday,Wednesday', '', 'Male', '2021-01-11', 'jobayer.paincare@gmail.com', '8', 10, 'shasthobd'),
(44, 'DR. Sajani Islam                                             (Asst.Professor)', 'MBBS, FCPS ( child )', 'A-36864', '{\"Saturday\":{\"StartTime\":\"17:30:00\",\"EndTime\":\"19:30:00\"},\"Sunday\":{\"StartTime\":\"17:30:00\",\"EndTime\":\"19:30:00\"},\"Monday\":{\"StartTime\":\"17:30:00\",\"EndTime\":\"19:30:00\"},\"Tuesday\":{\"StartTime\":\"17:30:00\",\"EndTime\":\"19:30:00\"},\"Wednesday\":{\"StartTime\":\"17:30:00\",\"EndTime\":\"19:30:00\"},\"Thursday\":{\"StartTime\":\"17:30:00\",\"EndTime\":\"19:30:00\"}}', '', 'Specialist', '', 'Shaheed Suhrawardy Medical College & Hospital', '3', '01717405779', '01717405779', '', '1', '1', '00:00:00', '00:00:00', '2021-01-12 12:55:40.000000', '2021-04-01 13:45:06.000000', '600', 'N', '600', '200', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617190427IMG-20210316-WA0000-removebg-preview.png', '1617190427IMG-20210316-WA0000-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1617190427CamScanner_03-31-2021_17.23_1-removebg-preview.png', '1617190427CamScanner_03-31-2021_17.23_1-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-01-12', 'sajaniislam@gmail.com', '8', 10, 'shasthobd'),
(45, 'Prof. DR. (Col) Khaleda Khanam ', 'MBBS, DGO, FCPS (obs & gynae)', 'A-20235', '{\"Saturday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"20:00:00\"},\"Sunday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"20:00:00\"},\"Monday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"20:00:00\"},\"Tuesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"20:00:00\"},\"Wednesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"20:00:00\"},\"Thursday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"20:00:00\"}}', '', 'Specialist', '', 'Universal Medical College Hospital', '2', '01715023655', '01715023655', '', '1', '1', '00:00:00', '00:00:00', '2021-01-12 13:13:17.000000', '2021-04-01 13:49:33.000000', '600', 'N', '600', '200', '250', '0', 'https://app.shasthobd.com/applications/docImg/16171907201610435597khaleda-585x499-removebg-preview.png', '16171907201610435597khaleda-585x499-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1615803642drkhaleda.png', '1615803642drkhaleda.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-01-12', '', '8', 10, 'shasthobd'),
(46, 'DR. ISMAT ARA BEGUM MUNNI      (Consultant Laser & Cosmetic)', 'MBBS, MPH, FAM(Germany), Diploma on Dermatology (on going)', 'A-478309', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"},\"Friday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"20:00:00\"}}', '', 'Specialist', '', 'Skin Care Center', '7', '01753707070', '01753707070', '', '1', '1', '00:00:00', '00:00:00', '2021-01-21 13:41:36.000000', '2021-04-01 14:48:02.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617266882dr_munni_mam_png.png', '1617266882dr_munni_mam_png.png', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Female', '2021-01-21', 'ismat.munni@gmail.com', '8', 10, 'shasthobd'),
(47, 'DR. CHOWDHURY MD. ANWAR', 'MBBS, FCGP', 'A-31514', '{\"Saturday\":{\"StartTime\":\"16:30:00\",\"EndTime\":\"20:30:00\"},\"Sunday\":{\"StartTime\":\"16:30:00\",\"EndTime\":\"20:30:00\"},\"Monday\":{\"StartTime\":\"16:30:00\",\"EndTime\":\"20:30:00\"},\"Tuesday\":{\"StartTime\":\"16:30:00\",\"EndTime\":\"20:30:00\"},\"Wednesday\":{\"StartTime\":\"16:30:00\",\"EndTime\":\"20:30:00\"},\"Thursday\":{\"StartTime\":\"16:30:00\",\"EndTime\":\"20:30:00\"}}', '', 'Specialist', '', 'BSMMU-Bangabandhu Sheikh Mujib Medical University', '1', '01785857269', '01785857269', '', '1', '1', '00:00:00', '00:00:00', '2021-01-21 13:52:18.000000', '2021-01-23 21:33:01.000000', '500', 'N', '500', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-01-21', '', '8', 10, 'shasthobd'),
(48, 'DR. SANJIDA RAHMAN         (Associate Prof. & Head Of Dept.)', 'MBBS, FCPS', 'A-31824', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"17:00:00\"}}', '', 'Specialist', '', 'Universal Medical College Hospital', '2', '01711446918', '01711446918', '', '1', '1', '00:00:00', '00:00:00', '2021-01-21 13:56:11.000000', '2021-01-23 21:32:52.000000', '600', 'N', '600', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-01-21', '', '8', 10, 'shasthobd'),
(49, 'DR. M. M. ABU DARDA', 'MBBS', 'A-92839', '{\"Saturday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'General Practitioner', '3,9,1,4,2,6,7,8,5', 'Dhaka Health Care Hospital', '', '01752707447', 'mim12345', '', '1', '1', '00:00:00', '00:00:00', '2021-01-21 13:59:17.000000', '2021-03-30 16:17:07.000000', '12', 'N', '12', '0', '10', '0', 'https://app.shasthobd.com/applications/docImg/16158886461600892557160__1_-removebg-preview.png', '16158886461600892557160__1_-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1615892002DR_DARDA-removebg-preview.png', '1615892002DR_DARDA-removebg-preview.png', 'Y', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Male', '2021-01-21', '', '8', 3, 'shasthobd'),
(50, 'DR. AFSANA RAHMAN          (Asst.Prof.)', 'MBBS, FCPS (Medicine)', 'A-37898', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Universal Medical College Hospital', '1', '01750000519', '01750000519', '', '1', '1', '00:00:00', '00:00:00', '2021-01-24 14:18:39.000000', '2021-04-01 13:43:13.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617097704dr_afsana_png_image.png', '1617097704dr_afsana_png_image.png', 'https://app.shasthobd.com/applications/docImg/1617097704drafsanpngsig.png', '1617097704drafsanpngsig.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-01-24', 'afsana_ahnaf@gmail.com', '8', 10, 'shasthobd'),
(51, 'DR. FATEMA ZOHRA                     (Asst. Prof. Psychiatry)', 'MBBS, MD(Psychiatry), FMD(USTC), DHMS (BD)', 'A-55081', '{\"Sunday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"12:30:00\",\"EndTime\":\"17:30:00\"},\"Tuesday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"21:00:00\"},\"Wednesday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'Specialist', '', 'Brahmanbaria Medical College Hospital', '19', '01918069995', '01918069995', '', '1', '1', '00:00:00', '00:00:00', '2021-01-28 12:23:47.000000', '2021-04-12 03:33:41.000000', '12', 'N', '12', '0', '10', '0', 'https://app.shasthobd.com/applications/docImg/16172655521611815027IMG-20210127-WA0008-removebg-preview.png', '16172655521611815027IMG-20210127-WA0008-removebg-preview.png', '', '', 'N', '', 'Sunday,Monday,Tuesday,Wednesday', '', 'Female', '2021-01-28', 'fatema.zohra86@yahoo.com', '8', 10, 'shasthobd'),
(52, 'M. A. BASHAR', 'Hons.(Psychology), MS( Clinical Psychology)', 'N/A', '{\"Saturday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"19:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Other Professional', '', 'INSIGHT PSYCHOSOCIAL RESEARCH & CARE', '', '01914270225', '01914270225', '', '1', '1', '00:00:00', '00:00:00', '2021-01-28 12:45:56.000000', '2021-04-17 19:40:03.000000', '1200', 'N', '1200', '0', '0', '0', 'https://app.shasthobd.com/applications/docImg/161709845752_1616421818-removebg-preview.png', '161709845752_1616421818-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1617098457CamScanner_03-30-2021_15.55-removebg-preview.png', '1617098457CamScanner_03-30-2021_15.55-removebg-preview.png', 'N', '4', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '65', 'Male', '1987-05-16', 'bashar_m40@yahoo.com', '8', 10, 'shasthobd'),
(53, 'DR. SHARMIN KARIM', 'MBBS, MD(Psychiatry)', 'A-42353', '{\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"}}', '', 'Specialist', '', 'NATIONAL INSTITUTE OF MENTAL HEALTH & HOSPITAL', '19', '01720533963', '01720533963', '', '1', '1', '00:00:00', '00:00:00', '2021-01-28 12:54:16.000000', '2021-04-01 14:34:20.000000', '750', 'N', '750', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1617266060IMG-20210316-WA0007-removebg-preview.png', '1617266060IMG-20210316-WA0007-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/161726606053_1615210413__1_-removebg-preview.png', '161726606053_1615210413__1_-removebg-preview.png', 'N', '', 'Sunday,Tuesday,Thursday', '', 'Female', '2021-01-28', 'sonu.impala@gmail.com', '8', 10, 'shasthobd'),
(54, 'DR. FAIZ AHMAD KHONDAKER', 'MBBS, FCPS(Medicine), MD(Hepatology)', 'A-30862', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"16:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"16:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"16:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"16:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"16:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"16:00:00\"}}', '', 'Specialist', '', 'Shaheed Suhrawardy Medical College & Hospital', '28,1', '01711571879', '01711571879', '', '1', '1', '00:00:00', '00:00:00', '2021-01-28 13:05:19.000000', '2021-04-01 13:47:19.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/161718739463063866_422160558515028_1868477607469645824_n-removebg-preview.png', '161718739463063866_422160558515028_1868477607469645824_n-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1617187394CamScanner_03-31-2021_16.40-removebg-preview.png', '1617187394CamScanner_03-31-2021_16.40-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-01-28', 'faizprofessional74@gmail.com', '8', 10, 'shasthobd'),
(55, 'DR. MOUSUMI SANYAL               ( Asst. Professor )', 'MBBS, FCPS (Medicine), MRCP (uk)', 'A- 54035', '{\"Saturday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"13:00:00\"},\"Sunday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"13:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:30:00\"},\"Tuesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"13:00:00\"},\"Wednesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"13:00:00\"},\"Thursday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"13:00:00\"}}', '', 'Specialist', '', 'CENTRAL POLICE HOSPITAL', '1', '01786520968', '01786520968', '', '1', '1', '00:00:00', '00:00:00', '2021-01-31 16:44:59.000000', '2021-04-12 03:40:46.000000', '12', 'N', '12', '0', '10', '0', 'https://app.shasthobd.com/applications/docImg/1616405849IMG-20210322-WA0003-removebg-preview.png', '1616405849IMG-20210322-WA0003-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1616405524IMG_20210322_152738398_HDR_2-removebg-preview.png', '1616405524IMG_20210322_152738398_HDR_2-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-01-31', '', '8', 10, 'shasthobd'),
(57, 'DR. MUNNI MAMTAZ          (Assoc.Prof.)', 'MBBS, FCPS(General Surgery), MS(Plastic Surgery)', '', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', 'dhaka', 'Specialist', '', 'Tairunnessa Memorial Medical College & Hospital', '13,30,12', '01749422709', '01749422709', '', '1', '1', '00:00:00', '00:00:00', '2021-02-03 14:33:01.000000', '2021-02-03 14:33:01.285848', '500', 'N', '500', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-02-03', '', '8', 10, ' ');
INSERT INTO `tbl_doctor` (`DOCID`, `DocName`, `DocDegree`, `BmdcReg`, `JsonTime`, `DocAddress`, `DocType`, `ReasonID`, `HospitalID`, `SpecialArea`, `MobileNum`, `Password`, `Remarks`, `Active`, `Status`, `StartDuty`, `EndDuty`, `Created_at`, `Updated_at`, `Payment`, `followup`, `general_payment`, `followup_payment`, `report_showing_payment`, `counseling_payment`, `DocImage`, `fileName`, `DocSignature`, `fileNameSignature`, `Gen_Prac`, `OtherPfID`, `DayOfPractice`, `Weight`, `Gender`, `DOB`, `Email`, `added_by`, `ordering`, `updated_by`) VALUES
(58, 'DR. MOUSHUMI AFRIN EVA            (Family Physician, Diabetologist & Clinical Nutritionist)', 'MBBS, M.PHIL, MPH, CCD, FMD', 'A-57358', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Other Professional', '', 'Holy Family Red Crescent Medical College Hospital', '', '01839373127', 'irfan2012', '', '1', '1', '00:00:00', '00:00:00', '2021-02-10 01:47:03.000000', '2021-04-01 14:19:41.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1612901486facebook_1612900868138_6764996562836191617.jpg', '1612901486facebook_1612900868138_6764996562836191617.jpg', 'https://app.shasthobd.com/applications/docImg/16172651811612900419IMG_20210204_180030-removebg-preview.png', '16172651811612900419IMG_20210204_180030-removebg-preview.png', 'N', '3', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '65', 'Female', '2021-03-03', 'drmoushumi3@gmail.com', '8', 10, 'shasthobd'),
(59, 'DR. MOUSHUMI AFRIN EVA            (Family Physician, Diabetologist & Clinical Nutritionist)', 'MBBS, M.PHIL, MPH, CCD, FMD', 'A-57358', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Holy Family Red Crescent Medical College Hospital', '6,31', '01839373127', '01839373127', '', '1', '1', '00:00:00', '00:00:00', '2021-02-10 01:53:39.000000', '2021-04-01 14:17:55.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1612901462facebook_1612900868138_6764996562836191617.jpg', '1612901462facebook_1612900868138_6764996562836191617.jpg', 'https://app.shasthobd.com/applications/docImg/16172649191612900419IMG_20210204_180030-removebg-preview.png', '16172649191612900419IMG_20210204_180030-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Female', '2021-02-10', '', '8', 10, 'shasthobd'),
(60, 'DR. PAUL SHUBHRA PRAKASH        (Jr.Consultant Rajshahi Medical College)', 'MBBS, MD(Pediatrics)', 'A-41808', '{\"Saturday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Rajshahi Medical College Hospital', '3', '01795021093', '01795021093', '', '1', '1', '00:00:00', '00:00:00', '2021-02-15 16:22:13.000000', '2021-02-15 16:30:27.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/161338453361771084_2299660353482632_6969560288689389568_n.jpg', '161338453361771084_2299660353482632_6969560288689389568_n.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-02-15', 'shuvro.paul@gmail.com', '8', 10, 'shasthobd'),
(61, 'DR. MD. RAKIBUL HASAN RASHED       (Consultant Rajshahi Medical College)', 'MBBS, BCS, MD(Cardiology)', 'A-39807', '{\"Saturday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"15:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Rajshahi Medical College Hospital', '4', '01786337788', '01786337788', '', '1', '1', '00:00:00', '00:00:00', '2021-02-15 16:27:30.000000', '2021-02-15 16:29:07.000000', '600', 'N', '600', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-02-15', '', '8', 10, 'shasthobd'),
(62, 'DR. KARTIK CHANDRA GHOSH                 (Bangabandhu Sheikh Mujib Medical University', 'MBBS, MPH, MS(Urology)', '', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Bangabandhu Sheikh Mujib Medical University', '14', '01711147172', '01711147172', '', '1', '1', '00:00:00', '00:00:00', '2021-02-15 16:35:42.000000', '2021-02-15 16:39:08.000000', '600', 'N', '600', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-02-15', 'kcghoshurodoc@gmail.com', '8', 9, 'shasthobd'),
(63, 'DR. MD.NURU HUDY      (Asst.Registrar) AJHARY', 'MBBS, BCS, D-CARD, CCD, DMU', 'A-55609', '{\"Saturday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"17:00:00\"},\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"17:00:00\"},\"Monday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"17:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"17:00:00\"},\"Wednesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"17:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"17:00:00\"}}', 'Mohammadpur, Dhaka', 'Specialist', '', 'National Institute of Cardiovascular Diseases and Hospital (NICVD)', '4', '01911150650', '01911150650', '', '1', '1', '00:00:00', '00:00:00', '2021-02-17 16:54:17.000000', '2021-03-17 12:04:56.000000', '600', 'N', '600', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '90', 'Male', '2021-02-17', 'mnhudy@gmail.com', '8', 10, 'shasthobd'),
(64, 'DR. ASM. MAHAMUDUZZAMAN              (Asst. Professor)', 'MBBS, DCH, MD(Child)', 'A-30046', '{\"Saturday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Shaheed Suhrawardy Medical College & Hospital', '3', '01711132076', '01711132076', '', '1', '1', '00:00:00', '00:00:00', '2021-02-17 17:18:46.000000', '2021-02-17 17:19:55.000000', '750', 'N', '750', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-02-17', 'shoyebdr@gmail.com', '8', 10, 'shasthobd'),
(65, 'DR. MD. KABIR ALAM               (Asst. Professor)', 'MBBS, BCS, MD(Pediatric Nephrology)', 'A-25136', '{\"Saturday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:30:00\"},\"Sunday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:30:00\"},\"Monday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:30:00\"},\"Tuesday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:30:00\"},\"Wednesday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:30:00\"},\"Thursday\":{\"StartTime\":\"21:00:00\",\"EndTime\":\"23:30:00\"}}', 'DHAKA', 'Specialist', '', 'national institute of kidney diseases & urology', '24', '01825043107', '01825043107', '', '1', '1', '00:00:00', '00:00:00', '2021-02-17 17:59:40.000000', '2021-02-17 17:59:40.582534', '750', 'N', '750', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-02-17', 'dr.kabiralam@gmail.com', '8', 10, ' '),
(66, 'DR. TAHMINA KHANDKAR MUNMUN                      (Jr. Consultant)', 'MBBS, MCPS (Pediatrics), MD (Pediatric Nephrology) ', 'A-43081', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"21:30:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"21:30:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"21:30:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"21:30:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"21:30:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"21:30:00\"}}', '', 'Specialist', '', 'national institute of kidney diseases & urology', '3,24', '01993845782', '01993845782', '', '1', '1', '00:00:00', '00:00:00', '2021-02-17 18:08:48.000000', '2021-03-07 19:04:13.000000', '600', 'N', '600', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-02-17', 'munmundr@yahoo.com', '8', 7, 'shasthobd'),
(67, 'DR. REZWANA ASHRAF                                             (Asst. Professor)', 'MBBS, DCH, MD(Pediatric Nephrology)', '', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"19:00:00\"}}', '', 'Specialist', '', 'national institute of kidney diseases & urology', '3,24', '01716637063', '01716637063', '', '1', '1', '00:00:00', '00:00:00', '2021-02-17 18:31:43.000000', '2021-02-17 18:32:30.000000', '600', 'N', '600', '0', '250', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-02-17', '', '8', 8, 'shasthobd'),
(68, 'DR. MD. SHAH NEWAZ', 'MBBS, MCPS (Medicine), DTCD(Chest)', 'A-17695', '{\"Saturday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"11:00:00\"},\"Sunday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"11:00:00\"},\"Monday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"11:00:00\"},\"Tuesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"11:00:00\"},\"Wednesday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"11:00:00\"},\"Thursday\":{\"StartTime\":\"10:00:00\",\"EndTime\":\"11:00:00\"}}', '', 'Specialist', '', 'PADMA PATH LAB', '1,5', '01911398419', '01911398419', '', '1', '1', '00:00:00', '00:00:00', '2021-02-17 18:44:29.000000', '2021-04-01 13:46:50.000000', '600', 'N', '600', '0', '250', '0', '', '', 'https://app.shasthobd.com/applications/docImg/1615627670drshahnewaz.png', '1615627670drshahnewaz.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-02-17', '', '8', 10, 'shasthobd'),
(69, 'DR. AHSAN FIROZ', 'MBBS, MPH, FRSH (London)', '', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'BSMMU-Bangabandhu Sheikh Mujib Medical University', '31,7', '01716251751', '01716251751', '', '1', '1', '00:00:00', '00:00:00', '2021-03-06 12:50:31.000000', '2021-03-11 16:30:35.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/161501343150456950_2112624442128322_4204120525712130048_n.jpg', '161501343150456950_2112624442128322_4204120525712130048_n.jpg', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-03-06', '', '8', 10, 'shasthobd'),
(70, 'DR. SUMAYA AKTER                                      (Asst.Professor)', 'MBBS,  FCPS ( Gynae & Obs)', 'A-44813', '{\"Saturday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Sunday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Monday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"19:00:00\"},\"Tuesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Wednesday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"18:00:00\"}}', '', 'Specialist', '', 'Popular Medical College', '2', '01711231534', '01711231534', '', '1', '1', '00:00:00', '00:00:00', '2021-03-06 16:56:03.000000', '2021-04-12 03:37:16.000000', '12', 'N', '12', '0', '10', '0', 'https://api.shasthobd.com/uploads/doctorFile/70_1617105303.png', '70_1617105303.png', 'https://app.shasthobd.com/applications/docImg/1615453521new_sig-removebg-preview.png', '1615453521new_sig-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '70', 'Female', '1982-08-31', 'sumaya.akter@yahoo.com', '8', 6, 'shasthobd'),
(71, 'DR. INDRANI NAG', 'MBBS , MCPS , FCPS (Gynae & Obs) O', 'A-37331', '{\"Saturday\":{\"StartTime\":\"09:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"09:00:00\",\"EndTime\":\"21:30:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"09:00:00\",\"EndTime\":\"21:30:00\"},\"Wednesday\":{\"StartTime\":\"09:00:00\",\"EndTime\":\"21:30:00\"},\"Thursday\":{\"StartTime\":\"09:00:00\",\"EndTime\":\"21:30:00\"}}', '', 'Specialist', '', 'Badda General Hospital', '2', '01712534645', '01712534645', '', '1', '1', '00:00:00', '00:00:00', '2021-03-11 19:38:33.000000', '2021-03-29 17:45:36.000000', '12', 'N', '12', '0', '10', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-03-11', 'nagindrani818@gmail.com', '8', 5, 'shasthobd'),
(72, 'DR. REZOANA MUNIR', 'MBBS', 'A-42285', '{\"Saturday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"},\"Sunday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"},\"Monday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"},\"Tuesday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"},\"Wednesday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"},\"Thursday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"},\"Friday\":{\"StartTime\":\"08:00:00\",\"EndTime\":\"16:00:00\"}}', '', 'General Practitioner', '3,9,1,4,2,6,7,8,5', 'Shastho BD', '', '01714061993', '01714061993', '', '1', '1', '00:00:00', '00:00:00', '2021-03-15 15:55:48.000000', '2021-03-30 18:26:45.000000', '12', 'N', '12', '0', '10', '0', 'https://app.shasthobd.com/applications/docImg/1615802148PP_sumi.jpg', '1615802148PP_sumi.jpg', 'https://api.shasthobd.com/uploads/doctorFile/72_1617107205.png', '72_1617107205.png', 'Y', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '', 'Female', '2021-03-15', '', '8', 1, 'shasthobd'),
(73, 'DR. MD. SIAM MOAZZEM', 'MBBS, FCPS ( Medicine, Final part), MRCP (Final part)', 'A-66743', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"16:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Dhaka Medical college &  Hospital', '1', '01763200363', '01763200363', '', '1', '1', '00:00:00', '00:00:00', '2021-03-15 16:49:10.000000', '2021-03-25 13:06:48.000000', '12', 'N', '12', '0', '10', '0', 'https://app.shasthobd.com/applications/docImg/1615805350127218410_107109491243400_2249473126765455100_o-removebg-preview.png', '1615805350127218410_107109491243400_2249473126765455100_o-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1615805591IMG_20210315_162314887-removebg-preview.png', '1615805591IMG_20210315_162314887-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-03-15', 'siam.moazzem@gmail.com', '8', 10, 'shasthobd'),
(74, 'DR. MD. MAHMUDUL HASAN', 'MBBS, MPH, CCD', 'A-55211', '{\"Saturday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Sunday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Tuesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Wednesday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"},\"Thursday\":{\"StartTime\":\"18:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'General Practitioner', '3,9,1,4,2,6,7,8,5', 'DHAKA SHISHU HOSPITAL', '', '01716064990', '01716064990', '', '1', '1', '00:00:00', '00:00:00', '2021-03-15 18:34:30.000000', '2021-03-30 15:24:08.000000', '250', 'N', '250', '0', '50', '0', '', '', '', '', 'Y', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Male', '2021-03-15', '', '8', 2, 'shasthobd'),
(76, 'DR.AFRIN SHARMIN                                      (Asst. Professor)', 'MBBS, FCPS (Plastic Surgery), Clinical fellowship in breast, Advance training in cleft surgery) ', 'A-40808', '{\"Saturday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"},\"Thursday\":{\"StartTime\":\"20:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Z H SIKDER WOMEN\'S MEDICAL COLLEGE & HOSPITAL', '30,32', '01714008081', '01714008081', '', '1', '1', '00:00:00', '00:00:00', '2021-03-20 14:57:35.000000', '2021-03-20 14:58:11.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1616230655dr_sharmin_apu_png.png', '1616230655dr_sharmin_apu_png.png', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-03-20', 'afrinarimi@gmail.com', '8', 4, 'shasthobd'),
(77, 'DR. SAMSUNNAHAR DINA                                      ( Consultant Paediatrics)', 'MBBS , FCPS ( Paediatrics )', 'A-51686', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"},\"Thursday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"21:00:00\"}}', '', 'Specialist', '', 'Better Life Hospital', '3', '01758081332', '01758081332', '', '1', '1', '00:00:00', '00:00:00', '2021-03-22 15:56:52.000000', '2021-04-01 13:59:13.000000', '600', 'N', '600', '0', '250', '0', 'https://app.shasthobd.com/applications/docImg/1616407012IMG-20210322-WA0001-removebg-preview.png', '1616407012IMG-20210322-WA0001-removebg-preview.png', 'https://app.shasthobd.com/applications/docImg/1616407012CamScanner_03-22-2021_15.47_1-removebg-preview.png', '1616407012CamScanner_03-22-2021_15.47_1-removebg-preview.png', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday', '', 'Female', '2021-03-22', 'mmrkhan82@gmail.com', '8', 3, 'shasthobd'),
(78, 'DR. M A HALIM KHAN', 'MBBS', '', '{\"Saturday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Sunday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Monday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Tuesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Wednesday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"},\"Friday\":{\"StartTime\":\"17:00:00\",\"EndTime\":\"22:00:00\"}}', '', 'Specialist', '', 'Shaheed Suhrawardy Medical College & Hospital', '6', '01712560552', '01712560552', '', '1', '1', '00:00:00', '00:00:00', '2021-04-11 17:22:02.000000', '2021-04-11 17:22:02.518745', '12', 'N', '12', '0', '10', '0', '', '', '', '', 'N', '', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Friday', '', 'Male', '2021-04-11', '', '8', 10, ' ');

--
-- Triggers `tbl_doctor`
--
DELIMITER $$
CREATE TRIGGER `doctor_delete_record` AFTER DELETE ON `tbl_doctor` FOR EACH ROW INSERT into tbl_doctor_log VALUES 
(null,'Delete',OLD.DOCID,OLD.DocName,OLD.BmdcReg,OLD.JsonTime,OLD.MobileNum,OLD.Password,OLD.Payment,OLD.SpecialArea,OLD.fileName,OLD.Gen_Prac,OLD.DayOfPractice,NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_doctor_log`
--

CREATE TABLE `tbl_doctor_log` (
  `id` int(111) NOT NULL,
  `action` varchar(35) NOT NULL,
  `DOCID` int(111) DEFAULT NULL,
  `DocName` varchar(255) DEFAULT NULL,
  `BmdcReg` varchar(255) DEFAULT NULL,
  `JsonTime` text DEFAULT NULL,
  `MobileNum` varchar(255) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Payment` varchar(255) DEFAULT NULL,
  `SpecialArea` varchar(255) DEFAULT NULL,
  `fileName` varchar(255) DEFAULT NULL,
  `Gen_Prac` varchar(255) DEFAULT NULL,
  `DayOfPractice` varchar(300) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_doctor_log`
--

INSERT INTO `tbl_doctor_log` (`id`, `action`, `DOCID`, `DocName`, `BmdcReg`, `JsonTime`, `MobileNum`, `Password`, `Payment`, `SpecialArea`, `fileName`, `Gen_Prac`, `DayOfPractice`, `created_at`) VALUES
(3, 'Delete', 36, 'Dr.Khaled Al Mounsur', '', '{\"Saturday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Sunday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Monday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Tuesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Wednesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Thursday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"},\"Friday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"24:00:00\"}}', '01778620942', '01778620942', '10', '14', '1602666789milon.jpg', 'N', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '2020-12-28 15:33:51'),
(2, 'Delete', 37, 'Test Doc', '12345', '{\"Saturday\":{\"StartTime\":\"02:00:00\",\"EndTime\":\"23:30:00\"},\"Sunday\":{\"StartTime\":\"02:00:00\",\"EndTime\":\"23:30:00\"},\"Monday\":{\"StartTime\":\"02:00:00\",\"EndTime\":\"23:30:00\"}}', '0171111111', '123', '99', '', '', 'Y', 'Saturday,Sunday,Monday', '2020-10-31 12:47:10'),
(4, 'Delete', 39, 'Test doc', 'Abcd', '{\"Saturday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"},\"Sunday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"},\"Monday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"},\"Tuesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"},\"Wednesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"},\"Thursday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"},\"Friday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"23:30:00\"}}', '01521466045', '01521466045', '10', '4', '1608208368Human_icon-icons.com_71855.png', 'N', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '2020-12-28 15:35:01'),
(5, 'Delete', 38, 'test', '0000', '{\"Saturday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"},\"Sunday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"},\"Monday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"},\"Tuesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"},\"Wednesday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"},\"Thursday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"},\"Friday\":{\"StartTime\":\"00:30:00\",\"EndTime\":\"15:00:00\"}}', '01717487990', '01717487990', '10', '1', '1604857785WP_20140330_005.jpg', 'N', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '2020-12-30 16:24:30'),
(6, 'Delete', 24, 'Dr. Zebun Nessa   (Snr.Consultant)', 'A–18464', '{\"Saturday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Sunday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Monday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Tuesday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Wednesday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Thursday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"},\"Friday\":{\"StartTime\":\"23:00:00\",\"EndTime\":\"24:00:00\"}}', '01922340244', '01922340244', '600', '2', '', 'N', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '2021-01-12 13:19:41'),
(7, 'Delete', 35, 'Dr. Md. Abul Kalam Azad', 'A-37485', '{\"Saturday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"},\"Sunday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"},\"Monday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"},\"Tuesday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"},\"Wednesday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"},\"Thursday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"},\"Friday\":{\"StartTime\":\"22:30:00\",\"EndTime\":\"23:30:00\"}}', '01712222182', '01712222182', '750', '12', '1600935496received_957895258012742.jpeg', 'N', 'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday', '2021-01-31 16:55:04');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_doctype`
--

CREATE TABLE `tbl_doctype` (
  `id` int(111) NOT NULL,
  `docType` varchar(255) NOT NULL DEFAULT ' ',
  `docTypeName` varchar(255) NOT NULL DEFAULT ' ',
  `edata` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_doctype`
--

INSERT INTO `tbl_doctype` (`id`, `docType`, `docTypeName`, `edata`) VALUES
(1, 'Specialist', 'Specialist', '2020-09-15 13:40:25'),
(2, 'General Practitioner', 'General Practitioner', '2020-09-15 13:40:25'),
(3, 'Other Professional', 'Other Professional', '2020-09-15 13:40:25');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_guide`
--

CREATE TABLE `tbl_guide` (
  `id` int(111) NOT NULL,
  `description` varchar(255) NOT NULL,
  `short_description` varchar(255) NOT NULL,
  `link` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_guide`
--

INSERT INTO `tbl_guide` (`id`, `description`, `short_description`, `link`) VALUES
(1, '', '', 'https://youtu.be/Ug2CQP8G93g');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_hospital`
--

CREATE TABLE `tbl_hospital` (
  `OID` bigint(20) NOT NULL,
  `HospitalName` varchar(200) DEFAULT NULL,
  `DateTime` datetime(6) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_hospital`
--

INSERT INTO `tbl_hospital` (`OID`, `HospitalName`, `DateTime`) VALUES
(1, 'LAB AID BANGLADESH', NULL),
(2, 'Anwar Khan Modern Medical College', NULL),
(3, 'Dhaka Medical College', NULL),
(4, 'Northern International Medical College ', NULL),
(5, 'Rowangchori Upazilla Health Complex,Bandarbans', NULL),
(6, 'Rangpur Medical College', '2020-09-12 17:19:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_instant_payment`
--

CREATE TABLE `tbl_instant_payment` (
  `id` int(111) NOT NULL,
  `amount` int(111) NOT NULL DEFAULT 100,
  `added_by` varchar(255) DEFAULT ' ',
  `updated_by` varchar(255) NOT NULL DEFAULT ' ',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_instant_payment`
--

INSERT INTO `tbl_instant_payment` (`id`, `amount`, `added_by`, `updated_by`, `created_at`, `update_at`) VALUES
(1, 100, 'das', ' ', '2020-10-03 17:15:04', '2020-10-03 17:15:04');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_labtest_trace`
--

CREATE TABLE `tbl_labtest_trace` (
  `id` int(111) NOT NULL,
  `patient_id` int(111) NOT NULL,
  `labtest_id` int(111) NOT NULL,
  `fileName` varchar(255) NOT NULL DEFAULT ' ',
  `filePath` varchar(255) NOT NULL DEFAULT ' ',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `fileName2` varchar(255) NOT NULL DEFAULT ' ',
  `filePath2` varchar(255) NOT NULL DEFAULT ' '
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_labtest_trace`
--

INSERT INTO `tbl_labtest_trace` (`id`, `patient_id`, `labtest_id`, `fileName`, `filePath`, `created_at`, `updated_at`, `fileName2`, `filePath2`) VALUES
(1, 1, 1, ' ', ' ', '2020-12-14 17:22:17', '2020-12-14 17:22:17', ' ', ' '),
(2, 1, 2, ' ', ' ', '2020-12-16 19:23:29', '2020-12-16 19:23:29', ' ', ' '),
(3, 5, 3, ' ', ' ', '2020-12-20 22:10:19', '2020-12-20 22:10:19', ' ', ' '),
(4, 5, 4, ' ', ' ', '2020-12-20 22:19:21', '2020-12-20 22:19:21', ' ', ' '),
(5, 1, 5, ' ', ' ', '2020-12-20 22:20:08', '2020-12-20 22:20:08', ' ', ' '),
(6, 5, 6, ' ', ' ', '2020-12-20 22:33:52', '2020-12-20 22:33:52', ' ', ' '),
(7, 3, 7, ' ', ' ', '2020-12-22 12:05:13', '2020-12-22 12:05:13', ' ', ' '),
(8, 1, 8, ' ', ' ', '2020-12-26 20:11:07', '2020-12-26 20:11:07', ' ', ' '),
(9, 11, 9, ' ', ' ', '2021-01-05 19:07:25', '2021-01-05 19:07:25', ' ', ' '),
(10, 10, 10, ' ', ' ', '2021-01-18 16:42:27', '2021-01-18 16:42:27', ' ', ' '),
(11, 10, 11, ' ', ' ', '2021-02-04 01:07:45', '2021-02-04 01:07:45', ' ', ' '),
(12, 11, 13, ' ', ' ', '2021-02-04 15:35:18', '2021-02-04 15:35:18', ' ', ' '),
(13, 11, 14, ' ', ' ', '2021-04-14 13:55:48', '2021-04-14 13:55:48', ' ', ' '),
(14, 11, 15, ' ', ' ', '2021-04-14 13:56:25', '2021-04-14 13:56:25', ' ', ' '),
(15, 10, 16, ' ', ' ', '2021-05-05 11:37:18', '2021-05-05 11:37:18', ' ', ' ');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_menu`
--

CREATE TABLE `tbl_menu` (
  `menu_id` int(11) NOT NULL,
  `menu_name` varchar(255) NOT NULL,
  `icon_class` varchar(255) DEFAULT NULL,
  `status` tinyint(4) NOT NULL,
  `notification` int(111) NOT NULL DEFAULT 0,
  `ordering` int(111) NOT NULL DEFAULT 1,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_menu`
--

INSERT INTO `tbl_menu` (`menu_id`, `menu_name`, `icon_class`, `status`, `notification`, `ordering`, `edate`) VALUES
(1, 'User Manipulation', 'pe-7s-door-lock', 1, 0, 1, '2020-07-14 17:00:00'),
(2, 'Adding Section', 'pe-7s-add-user', 1, 0, 3, '2020-07-14 03:00:00'),
(3, 'Admin Menu', 'pe-7s-scissors', 1, 1, 2, '2020-07-16 00:00:00'),
(4, 'Viewing (Active)', 'pe-7s-display1', 1, 0, 4, '2020-07-16 00:00:00'),
(6, 'Push Notification', 'pe-7s-bell', 1, 0, 6, '2020-10-20 00:00:00'),
(7, 'Viewing (In-Active)', 'pe-7s-display2', 1, 0, 5, '2021-01-19 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_notification`
--

CREATE TABLE `tbl_notification` (
  `id` int(111) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `message_id` varchar(255) NOT NULL,
  `added_by` varchar(255) NOT NULL,
  `edate` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_notification_tokens`
--

CREATE TABLE `tbl_notification_tokens` (
  `id` int(111) NOT NULL,
  `token` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_notification_tokens`
--

INSERT INTO `tbl_notification_tokens` (`id`, `token`, `created_at`, `updated_at`) VALUES
(3, 'djFMTfxBQxyRixXj-RQk-h:APA91bE6j6tlVidExw8FvwFKJpspPgsoongd4N3x4muharUG0w0qrbR99bybspFOcXhEBJ20TXyzzlJqR62s1XMEdTczLLzio5RGA4vP_h3AaxQy-cZwyuMorV5PJY83re54-LbvAZ3B', '2020-10-18 17:29:19', '2020-10-18 17:29:19');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_otherprofessional`
--

CREATE TABLE `tbl_otherprofessional` (
  `OID` bigint(20) NOT NULL,
  `Professional` varchar(200) DEFAULT NULL,
  `ImagePath` varchar(200) DEFAULT NULL,
  `Active` int(111) NOT NULL DEFAULT 1,
  `Updated_by` varchar(255) DEFAULT NULL,
  `Updated_at` date DEFAULT NULL,
  `Created_at` date DEFAULT NULL,
  `Added_by` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_otherprofessional`
--

INSERT INTO `tbl_otherprofessional` (`OID`, `Professional`, `ImagePath`, `Active`, `Updated_by`, `Updated_at`, `Created_at`, `Added_by`) VALUES
(1, 'Physiotherapy & Rehabilitation', 'http://103.108.140.210:8000/uploads/appImg/ph.jpg', 1, NULL, NULL, NULL, NULL),
(2, 'Sports injury care', 'http://103.108.140.210:8000/uploads/appImg/ph.jpg', 1, NULL, NULL, NULL, NULL),
(3, 'Nutritionist', 'http://103.108.140.210:8000/uploads/appImg/nt.jpg', 1, NULL, NULL, NULL, NULL),
(4, 'Psychologist', 'http://103.108.140.210:8000/uploads/appImg/mn.jpg', 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_otp`
--

CREATE TABLE `tbl_otp` (
  `id` int(111) NOT NULL,
  `otp` int(111) NOT NULL,
  `number` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_otp`
--

INSERT INTO `tbl_otp` (`id`, `otp`, `number`, `type`, `created_at`, `updated_at`) VALUES
(12, 1234, '01521466045', '', '2020-10-09 16:40:41', '2020-10-09 16:40:41'),
(9, 4995, '01309173151', '', '2020-10-09 16:16:40', '2020-10-09 16:16:40'),
(8, 8875, '01521466045', '', '2020-10-09 16:10:54', '2020-10-09 16:10:54'),
(10, 7533, '01309173151', '', '2020-10-09 16:22:24', '2020-10-09 16:22:24'),
(11, 2849, '01521466045', '', '2020-10-09 16:26:31', '2020-10-09 16:26:31'),
(13, 8985, '01309173151', '', '2020-10-09 16:40:58', '2020-10-09 16:40:58'),
(14, 8985, '01309173151', '', '2020-10-09 16:43:12', '2020-10-09 16:43:12'),
(15, 0, '01309173151', '', '2020-10-09 17:39:36', '2020-10-09 17:39:36'),
(16, 6254, '01309173151', '', '2020-10-09 22:26:00', '2020-10-09 22:26:00'),
(17, 107, '01309173151', '', '2020-10-09 22:26:19', '2020-10-09 22:26:19'),
(18, 7239, '01309173151', '', '2020-10-09 22:29:54', '2020-10-09 22:29:54'),
(19, 3476, '01309173151', '', '2020-10-09 22:30:49', '2020-10-09 22:30:49'),
(20, 4215, '01857099875', '', '2020-10-09 23:09:23', '2020-10-09 23:09:23'),
(21, 2444, '01521466045', '', '2020-10-09 23:16:48', '2020-10-09 23:16:48'),
(22, 4664, '01521466045', '', '2020-10-10 15:40:18', '2020-10-10 15:40:18'),
(23, 3277, '01558926125', '', '2020-10-10 16:22:01', '2020-10-10 16:22:01'),
(24, 2103, '01521466045', '', '2020-10-11 01:44:17', '2020-10-11 01:44:17'),
(25, 7714, '01515207007', '', '2020-10-11 07:39:23', '2020-10-11 07:39:23'),
(26, 6982, '01911441441', '', '2020-10-11 18:49:38', '2020-10-11 18:49:38'),
(27, 7151, '01911441441', '', '2020-10-11 18:52:13', '2020-10-11 18:52:13'),
(28, 1321, '01911004334', '', '2020-10-11 19:00:30', '2020-10-11 19:00:30'),
(29, 3173, '01911004334', '', '2020-10-13 16:07:49', '2020-10-13 16:07:49'),
(30, 6339, '01819210643', '', '2020-10-14 18:05:03', '2020-10-14 18:05:03'),
(31, 8840, '01748702672', NULL, '2020-10-21 21:37:47', '2020-10-21 21:37:47'),
(32, 8840, '01521466045', NULL, '2020-10-21 21:38:34', '2020-10-21 21:38:34'),
(33, 410, '01748702672', NULL, '2020-10-21 21:39:50', '2020-10-21 21:39:50'),
(34, 5802, '01748702672', NULL, '2020-10-21 21:41:51', '2020-10-21 21:41:51'),
(35, 8840, '01521466045', NULL, '2020-10-21 21:43:30', '2020-10-21 21:43:30'),
(36, 8840, '01521466045', NULL, '2020-10-21 21:45:30', '2020-10-21 21:45:30'),
(37, 7950, '01748702672', NULL, '2020-10-21 22:24:00', '2020-10-21 22:24:00'),
(38, 6098, '01857099875', NULL, '2020-10-21 22:34:50', '2020-10-21 22:34:50'),
(39, 3825, '01515207007', NULL, '2020-10-22 12:09:25', '2020-10-22 12:09:25'),
(40, 8813, '01911004334', NULL, '2020-10-22 21:34:52', '2020-10-22 21:34:52'),
(41, 7233, '01911441441', NULL, '2020-10-22 21:40:29', '2020-10-22 21:40:29'),
(42, 4920, '01712494813', NULL, '2020-10-22 22:00:30', '2020-10-22 22:00:30'),
(43, 1543, '01712494813', NULL, '2020-10-22 22:03:34', '2020-10-22 22:03:34'),
(44, 5149, '01712494813', NULL, '2020-10-22 22:05:34', '2020-10-22 22:05:34'),
(45, 1686, '01772183272', NULL, '2020-10-23 01:33:05', '2020-10-23 01:33:05'),
(46, 6622, '01748702672', NULL, '2020-10-23 22:59:45', '2020-10-23 22:59:45'),
(47, 5938, '01748702672', NULL, '2020-10-23 23:00:27', '2020-10-23 23:00:27'),
(48, 4118, '01911004334', NULL, '2020-10-24 03:49:37', '2020-10-24 03:49:37'),
(49, 1393, '9154191496', NULL, '2020-10-24 18:09:36', '2020-10-24 18:09:36'),
(50, 57, '01717139404', NULL, '2020-10-26 17:15:59', '2020-10-26 17:15:59'),
(51, 750, '01717139404', NULL, '2020-10-26 17:17:42', '2020-10-26 17:17:42'),
(52, 5841, '01717139404', NULL, '2020-10-26 17:18:32', '2020-10-26 17:18:32'),
(53, 613, '01832059790', NULL, '2020-10-26 20:29:44', '2020-10-26 20:29:44'),
(54, 4394, '01911004304', NULL, '2020-10-27 23:40:08', '2020-10-27 23:40:08'),
(55, 7176, '01640845552', NULL, '2020-10-31 00:18:51', '2020-10-31 00:18:51'),
(56, 8639, '01717487990', NULL, '2020-11-07 03:47:01', '2020-11-07 03:47:01'),
(57, 9849, '01740483311', NULL, '2020-11-12 23:37:18', '2020-11-12 23:37:18'),
(58, 6538, '01740483311', NULL, '2020-11-12 23:38:06', '2020-11-12 23:38:06'),
(59, 6806, '01717436111', NULL, '2020-12-13 23:52:41', '2020-12-13 23:52:41'),
(60, 8332, '01717436111', NULL, '2020-12-13 23:54:07', '2020-12-13 23:54:07'),
(61, 1258, '01846843843', NULL, '2020-12-17 22:06:42', '2020-12-17 22:06:42'),
(62, 1954, '01811486879', NULL, '2020-12-18 09:32:44', '2020-12-18 09:32:44'),
(63, 5177, '01767225585', NULL, '2020-12-20 16:46:43', '2020-12-20 16:46:43'),
(64, 260, '01715159847', NULL, '2020-12-25 02:51:50', '2020-12-25 02:51:50'),
(65, 1339, '01712579586', NULL, '2020-12-26 15:06:30', '2020-12-26 15:06:30'),
(66, 7768, '01712579586', NULL, '2020-12-26 15:08:51', '2020-12-26 15:08:51'),
(67, 3574, '01712579586', NULL, '2020-12-26 15:09:32', '2020-12-26 15:09:32'),
(68, 8384, '01819210643', NULL, '2020-12-26 17:39:33', '2020-12-26 17:39:33'),
(69, 634, '01819210643', NULL, '2020-12-26 17:40:12', '2020-12-26 17:40:12'),
(70, 2939, '01946982725', NULL, '2020-12-27 12:46:07', '2020-12-27 12:46:07'),
(71, 7431, '01767039396', NULL, '2020-12-30 16:22:36', '2020-12-30 16:22:36'),
(72, 9506, '01521466045', NULL, '2020-12-30 17:09:49', '2020-12-30 17:09:49'),
(73, 6807, '.-1--1.----', NULL, '2021-01-09 10:49:11', '2021-01-09 10:49:11'),
(74, 7267, '01911745974', NULL, '2021-01-09 23:04:34', '2021-01-09 23:04:34'),
(75, 2888, '01911745974', NULL, '2021-01-09 23:06:04', '2021-01-09 23:06:04'),
(76, 6068, '01701290000', NULL, '2021-01-10 15:42:36', '2021-01-10 15:42:36'),
(77, 7795, '01628122828', NULL, '2021-01-11 01:42:58', '2021-01-11 01:42:58'),
(78, 5580, '01745597744', NULL, '2021-01-13 13:52:19', '2021-01-13 13:52:19'),
(79, 446, '01673899273', NULL, '2021-01-21 19:29:34', '2021-01-21 19:29:34'),
(80, 6703, '01632549323', NULL, '2021-01-21 19:38:02', '2021-01-21 19:38:02'),
(81, 2039, '01701034858', NULL, '2021-01-21 19:38:15', '2021-01-21 19:38:15'),
(82, 971, '01701034858', NULL, '2021-01-21 19:56:57', '2021-01-21 19:56:57'),
(83, 9797, '01701034858', NULL, '2021-01-21 20:02:03', '2021-01-21 20:02:03'),
(84, 7483, '01701034858', NULL, '2021-01-21 20:04:47', '2021-01-21 20:04:47'),
(85, 9141, '01571790082', NULL, '2021-01-23 12:25:34', '2021-01-23 12:25:34'),
(86, 7841, '01795788597', NULL, '2021-01-23 17:16:47', '2021-01-23 17:16:47'),
(87, 2886, '01795788597', NULL, '2021-01-23 18:38:09', '2021-01-23 18:38:09'),
(88, 3585, '01673899273', NULL, '2021-01-25 16:54:41', '2021-01-25 16:54:41'),
(89, 6034, '01715597557', NULL, '2021-01-26 00:43:45', '2021-01-26 00:43:45'),
(90, 7080, '01715597557', NULL, '2021-01-26 00:51:02', '2021-01-26 00:51:02'),
(91, 477, '01715597557', NULL, '2021-01-26 01:52:34', '2021-01-26 01:52:34'),
(92, 5493, '01715597557', NULL, '2021-01-27 02:06:25', '2021-01-27 02:06:25'),
(93, 7059, '01778620942', NULL, '2021-02-02 20:50:56', '2021-02-02 20:50:56'),
(94, 1446, '01953322977', NULL, '2021-02-04 16:16:18', '2021-02-04 16:16:18'),
(95, 5365, '01316949501', NULL, '2021-02-04 17:04:20', '2021-02-04 17:04:20'),
(96, 8778, '01917430611', NULL, '2021-02-04 22:16:48', '2021-02-04 22:16:48'),
(97, 8943, '01712092622', NULL, '2021-02-04 22:17:15', '2021-02-04 22:17:15'),
(98, 7577, '01886696904', NULL, '2021-02-05 13:22:53', '2021-02-05 13:22:53'),
(99, 3173, '01712856524', NULL, '2021-02-08 09:53:18', '2021-02-08 09:53:18'),
(100, 7562, '01317750914', NULL, '2021-02-08 12:14:05', '2021-02-08 12:14:05'),
(101, 5636, '01837658000', NULL, '2021-02-09 13:44:13', '2021-02-09 13:44:13'),
(102, 8916, '01768265878', NULL, '2021-02-10 17:29:54', '2021-02-10 17:29:54'),
(103, 2495, '01571790082', NULL, '2021-02-11 20:51:42', '2021-02-11 20:51:42'),
(104, 938, '01795021093', NULL, '2021-02-11 22:32:56', '2021-02-11 22:32:56'),
(105, 5682, '01712529772', NULL, '2021-02-14 16:51:23', '2021-02-14 16:51:23'),
(106, 1869, '01874075515', NULL, '2021-02-16 15:18:22', '2021-02-16 15:18:22'),
(107, 5708, '01958405364', NULL, '2021-02-16 22:22:29', '2021-02-16 22:22:29'),
(108, 7302, '01746106550', NULL, '2021-02-16 22:24:07', '2021-02-16 22:24:07'),
(109, 8431, '01989851349', NULL, '2021-02-20 13:35:28', '2021-02-20 13:35:28'),
(110, 5633, '01989851349', NULL, '2021-02-20 13:37:00', '2021-02-20 13:37:00'),
(111, 4807, '01944200539', NULL, '2021-02-21 23:29:21', '2021-02-21 23:29:21'),
(112, 968, '01759325275', NULL, '2021-02-23 08:05:05', '2021-02-23 08:05:05'),
(113, 5031, '9773858035', NULL, '2021-02-23 16:47:49', '2021-02-23 16:47:49'),
(114, 6862, '9773858035', NULL, '2021-02-23 16:49:11', '2021-02-23 16:49:11'),
(115, 6516, '01309173151', NULL, '2021-02-27 22:55:38', '2021-02-27 22:55:38'),
(116, 6919, '01753707070', NULL, '2021-02-27 23:55:44', '2021-02-27 23:55:44'),
(117, 902, '1753707070', NULL, '2021-03-01 18:46:52', '2021-03-01 18:46:52'),
(118, 5242, '1753707070', NULL, '2021-03-01 18:51:47', '2021-03-01 18:51:47'),
(119, 8251, '1753707070', NULL, '2021-03-01 18:53:59', '2021-03-01 18:53:59'),
(120, 6639, '01833754504', NULL, '2021-03-01 18:58:09', '2021-03-01 18:58:09'),
(121, 7060, '01737794746', NULL, '2021-03-02 19:09:45', '2021-03-02 19:09:45'),
(122, 2984, '01737794746', NULL, '2021-03-02 21:20:49', '2021-03-02 21:20:49'),
(123, 8709, '01521466045', NULL, '2021-03-02 21:21:04', '2021-03-02 21:21:04'),
(124, 8473, '01521466045', NULL, '2021-03-02 21:22:52', '2021-03-02 21:22:52'),
(125, 3509, '0143916210', NULL, '2021-03-03 00:11:10', '2021-03-03 00:11:10'),
(126, 1510, '01403916210', NULL, '2021-03-03 00:11:24', '2021-03-03 00:11:24'),
(127, 6990, '01403916210', NULL, '2021-03-03 00:12:30', '2021-03-03 00:12:30'),
(128, 5583, '6504992804', NULL, '2021-03-03 01:40:43', '2021-03-03 01:40:43'),
(129, 2333, '01711958087', NULL, '2021-03-07 22:59:32', '2021-03-07 22:59:32'),
(130, 2587, '01676052521', NULL, '2021-03-09 00:19:40', '2021-03-09 00:19:40'),
(131, 4000, '01918069995', NULL, '2021-03-09 17:27:10', '2021-03-09 17:27:10'),
(132, 5392, '01752707447', NULL, '2021-03-10 21:35:04', '2021-03-10 21:35:04'),
(133, 481, '01752707447', NULL, '2021-03-10 22:13:17', '2021-03-10 22:13:17'),
(134, 5222, '01752707447', NULL, '2021-03-10 22:15:47', '2021-03-10 22:15:47'),
(135, 3382, '01877585773', NULL, '2021-03-13 16:58:40', '2021-03-13 16:58:40'),
(136, 6021, '01740483311', NULL, '2021-03-14 14:10:56', '2021-03-14 14:10:56'),
(137, 7355, '01740483311', NULL, '2021-03-14 21:27:37', '2021-03-14 21:27:37'),
(138, 949, '01718626683', NULL, '2021-03-16 01:24:47', '2021-03-16 01:24:47'),
(139, 803, '01303382096', NULL, '2021-03-17 10:29:14', '2021-03-17 10:29:14'),
(140, 360, '01913673100', NULL, '2021-03-18 21:51:31', '2021-03-18 21:51:31'),
(141, 787, '01704492716', NULL, '2021-03-20 20:54:03', '2021-03-20 20:54:03'),
(142, 7225, '01715001069', NULL, '2021-03-20 22:40:40', '2021-03-20 22:40:40'),
(143, 8395, '01719143488', NULL, '2021-03-22 16:06:04', '2021-03-22 16:06:04'),
(144, 7676, '01910810411', NULL, '2021-03-23 16:39:41', '2021-03-23 16:39:41'),
(145, 6017, '01958048595', NULL, '2021-03-23 21:28:00', '2021-03-23 21:28:00'),
(146, 4295, '01958048595', NULL, '2021-03-23 21:29:19', '2021-03-23 21:29:19'),
(147, 8624, '01738853592', NULL, '2021-03-23 21:40:14', '2021-03-23 21:40:14'),
(148, 3144, '01795747408', NULL, '2021-03-24 18:56:10', '2021-03-24 18:56:10'),
(149, 5216, '01701034858', NULL, '2021-03-25 13:05:44', '2021-03-25 13:05:44'),
(150, 1250, '01710572006', NULL, '2021-03-26 21:40:30', '2021-03-26 21:40:30'),
(151, 447, '01966622262', NULL, '2021-03-27 17:54:36', '2021-03-27 17:54:36'),
(152, 4523, '01966622262', NULL, '2021-03-27 17:57:37', '2021-03-27 17:57:37'),
(153, 6863, '01911004334', NULL, '2021-03-27 18:01:17', '2021-03-27 18:01:17'),
(154, 8220, '01941036411', NULL, '2021-03-29 14:24:01', '2021-03-29 14:24:01'),
(155, 7750, '01533752445', NULL, '2021-03-29 23:06:01', '2021-03-29 23:06:01'),
(156, 3425, '01966622262', NULL, '2021-04-01 19:06:56', '2021-04-01 19:06:56'),
(157, 2245, '01966622262', NULL, '2021-04-01 19:10:32', '2021-04-01 19:10:32'),
(158, 2226, '01814750500', NULL, '2021-04-04 17:55:52', '2021-04-04 17:55:52'),
(159, 5832, '01814750500', NULL, '2021-04-04 17:57:30', '2021-04-04 17:57:30'),
(160, 8523, '01745448905', NULL, '2021-04-06 18:11:38', '2021-04-06 18:11:38'),
(161, 2889, '01745448905', NULL, '2021-04-06 18:14:34', '2021-04-06 18:14:34'),
(162, 5531, '01745448905', NULL, '2021-04-06 18:19:10', '2021-04-06 18:19:10'),
(163, 986, '01745448905', NULL, '2021-04-06 18:23:45', '2021-04-06 18:23:45'),
(164, 1261, '01745448905', NULL, '2021-04-06 18:24:37', '2021-04-06 18:24:37'),
(165, 6407, '01745448905', NULL, '2021-04-06 18:25:25', '2021-04-06 18:25:25'),
(166, 4096, '01716815811', NULL, '2021-04-06 22:20:02', '2021-04-06 22:20:02'),
(167, 6469, '01716815811', NULL, '2021-04-06 22:20:25', '2021-04-06 22:20:25'),
(168, 7230, '01814867542', NULL, '2021-04-06 22:22:32', '2021-04-06 22:22:32'),
(169, 5214, '01814867542', NULL, '2021-04-06 22:23:38', '2021-04-06 22:23:38'),
(170, 8028, '01814867542', NULL, '2021-04-06 22:25:19', '2021-04-06 22:25:19'),
(171, 6579, '01745448905', NULL, '2021-04-07 10:37:27', '2021-04-07 10:37:27'),
(172, 2926, '01745448905', NULL, '2021-04-07 10:44:07', '2021-04-07 10:44:07'),
(173, 6651, '01745448905', NULL, '2021-04-07 10:46:58', '2021-04-07 10:46:58'),
(174, 1550, '01745448905', NULL, '2021-04-07 15:02:55', '2021-04-07 15:02:55'),
(175, 7380, '01745448905', NULL, '2021-04-07 15:09:30', '2021-04-07 15:09:30'),
(176, 6370, '01745448905', NULL, '2021-04-07 15:20:10', '2021-04-07 15:20:10'),
(177, 459, '01745448905', NULL, '2021-04-07 15:21:45', '2021-04-07 15:21:45'),
(178, 3752, '01712411759', NULL, '2021-04-08 09:57:49', '2021-04-08 09:57:49'),
(179, 7469, '01712411759', NULL, '2021-04-08 10:04:35', '2021-04-08 10:04:35'),
(180, 8756, '01819885403', NULL, '2021-04-08 10:55:42', '2021-04-08 10:55:42'),
(181, 1504, '01712411759', NULL, '2021-04-08 14:24:26', '2021-04-08 14:24:26'),
(182, 4611, '01712411759', NULL, '2021-04-08 14:24:30', '2021-04-08 14:24:30'),
(183, 7301, '01716815811', NULL, '2021-04-08 14:38:41', '2021-04-08 14:38:41'),
(184, 8428, '01814867542', NULL, '2021-04-08 14:39:34', '2021-04-08 14:39:34'),
(185, 2497, '01814867542', NULL, '2021-04-08 14:40:48', '2021-04-08 14:40:48'),
(186, 4323, '01708487545', NULL, '2021-04-09 11:30:21', '2021-04-09 11:30:21'),
(187, 3959, '01708487545', NULL, '2021-04-09 11:31:39', '2021-04-09 11:31:39'),
(188, 8844, '01712824122', NULL, '2021-04-10 01:29:30', '2021-04-10 01:29:30'),
(189, 8334, '01712824122', NULL, '2021-04-10 10:22:59', '2021-04-10 10:22:59'),
(190, 2872, '01521466045', NULL, '2021-04-10 14:33:17', '2021-04-10 14:33:17'),
(191, 434, '01767039396', NULL, '2021-04-10 14:34:07', '2021-04-10 14:34:07'),
(192, 5871, '01521466045', NULL, '2021-04-10 15:00:35', '2021-04-10 15:00:35'),
(193, 9388, '01767039396', NULL, '2021-04-10 15:04:12', '2021-04-10 15:04:12'),
(194, 5655, '01914968626', NULL, '2021-04-10 15:22:33', '2021-04-10 15:22:33'),
(195, 8805, '01914968626', NULL, '2021-04-10 15:24:14', '2021-04-10 15:24:14'),
(196, 9127, '01767039396', NULL, '2021-04-10 15:24:45', '2021-04-10 15:24:45'),
(197, 5925, '01914968626', NULL, '2021-04-10 15:27:11', '2021-04-10 15:27:11'),
(198, 5427, '01767039396', NULL, '2021-04-10 17:58:30', '2021-04-10 17:58:30'),
(199, 9849, '01521466045', NULL, '2021-04-10 17:58:50', '2021-04-10 17:58:50'),
(200, 7577, '01521466045', NULL, '2021-04-11 17:05:30', '2021-04-11 17:05:30'),
(201, 6444, '01521466045', NULL, '2021-04-11 17:17:00', '2021-04-11 17:17:00'),
(202, 6182, '01521466045', NULL, '2021-04-11 17:26:44', '2021-04-11 17:26:44'),
(203, 8854, '01521466045', NULL, '2021-04-11 17:31:37', '2021-04-11 17:31:37'),
(204, 2253, '01521466045', NULL, '2021-04-11 17:45:03', '2021-04-11 17:45:03'),
(205, 776, '01711669062', NULL, '2021-04-11 17:57:26', '2021-04-11 17:57:26'),
(206, 1190, '01711669062', NULL, '2021-04-11 18:04:39', '2021-04-11 18:04:39'),
(207, 535, '01732528018', NULL, '2021-04-11 21:27:03', '2021-04-11 21:27:03'),
(208, 1310, '01740563828', NULL, '2021-04-11 21:55:48', '2021-04-11 21:55:48'),
(209, 4484, '01740563828', NULL, '2021-04-11 21:56:45', '2021-04-11 21:56:45'),
(210, 8990, '01521466045', NULL, '2021-04-12 00:47:46', '2021-04-12 00:47:46'),
(211, 6031, '01521466045', NULL, '2021-04-12 04:29:02', '2021-04-12 04:29:02'),
(212, 8132, '01521466045', NULL, '2021-04-12 05:10:40', '2021-04-12 05:10:40'),
(213, 9009, '01521466045', NULL, '2021-04-12 11:37:57', '2021-04-12 11:37:57'),
(214, 6307, '01673855250', NULL, '2021-04-12 22:04:32', '2021-04-12 22:04:32'),
(215, 6161, '01673855250', NULL, '2021-04-12 22:05:24', '2021-04-12 22:05:24'),
(216, 4156, '01673855250', NULL, '2021-04-12 22:06:33', '2021-04-12 22:06:33'),
(217, 5077, '01673855250', NULL, '2021-04-12 22:07:08', '2021-04-12 22:07:08'),
(218, 9950, '01673963716', NULL, '2021-04-14 03:23:01', '2021-04-14 03:23:01'),
(219, 4339, '01312347075', NULL, '2021-04-17 04:09:17', '2021-04-17 04:09:17'),
(220, 8962, '01521466045', NULL, '2021-04-17 19:29:31', '2021-04-17 19:29:31'),
(221, 3622, '01521466045', NULL, '2021-04-17 19:32:50', '2021-04-17 19:32:50'),
(222, 6355, '01673963716', NULL, '2021-04-17 19:53:49', '2021-04-17 19:53:49'),
(223, 3320, '01701034858', NULL, '2021-04-20 12:44:26', '2021-04-20 12:44:26'),
(224, 2415, '01600194208', NULL, '2021-05-09 02:50:29', '2021-05-09 02:50:29'),
(225, 4942, '01768848495', NULL, '2021-05-10 23:28:52', '2021-05-10 23:28:52'),
(226, 3417, '01734134418', NULL, '2021-05-11 15:58:03', '2021-05-11 15:58:03'),
(227, 7580, '01734134418', NULL, '2021-05-11 15:59:25', '2021-05-11 15:59:25'),
(228, 3025, '01725823761', NULL, '2021-05-11 23:34:01', '2021-05-11 23:34:01'),
(229, 5376, '01725823761', NULL, '2021-05-11 23:36:09', '2021-05-11 23:36:09'),
(230, 7297, '01737439008', NULL, '2021-05-16 20:07:09', '2021-05-16 20:07:09'),
(231, 3104, '01774136190', NULL, '2021-05-17 09:27:13', '2021-05-17 09:27:13'),
(232, 2677, '01777664786', NULL, '2021-05-24 15:31:27', '2021-05-24 15:31:27'),
(233, 5335, '07761363887', NULL, '2021-05-24 19:39:53', '2021-05-24 19:39:53'),
(234, 7843, '01312359202', NULL, '2021-05-28 10:36:17', '2021-05-28 10:36:17'),
(235, 4442, '01312359202', NULL, '2021-05-28 10:36:17', '2021-05-28 10:36:17'),
(236, 7827, '01312359202', NULL, '2021-05-28 10:49:12', '2021-05-28 10:49:12'),
(237, 5038, '01312359202', NULL, '2021-05-28 10:50:12', '2021-05-28 10:50:12'),
(238, 8549, '01825042220', NULL, '2021-05-28 11:34:34', '2021-05-28 11:34:34'),
(239, 6995, '01747453677', NULL, '2021-06-03 16:32:02', '2021-06-03 16:32:02'),
(240, 8406, '01717487990', NULL, '2021-06-05 01:37:23', '2021-06-05 01:37:23'),
(241, 7092, '01777325653', NULL, '2021-06-06 08:07:44', '2021-06-06 08:07:44'),
(242, 8587, '01770279593', NULL, '2021-06-11 12:00:59', '2021-06-11 12:00:59'),
(243, 6972, '01757346086', NULL, '2021-06-12 08:41:29', '2021-06-12 08:41:29');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_patient`
--

CREATE TABLE `tbl_patient` (
  `OID` bigint(20) NOT NULL,
  `Name` varchar(200) DEFAULT ' ',
  `Address` varchar(200) DEFAULT ' ',
  `Mobile` varchar(200) DEFAULT NULL,
  `Password` varchar(200) DEFAULT NULL,
  `Weight` varchar(200) DEFAULT ' ',
  `Gender` varchar(200) DEFAULT ' ',
  `Dob` date DEFAULT current_timestamp(),
  `Email` varchar(200) DEFAULT ' ',
  `Active` int(111) NOT NULL DEFAULT 1,
  `Created_at` datetime DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_patient`
--

INSERT INTO `tbl_patient` (`OID`, `Name`, `Address`, `Mobile`, `Password`, `Weight`, `Gender`, `Dob`, `Email`, `Active`, `Created_at`, `Updated_at`) VALUES
(3, 'Das', NULL, '01767039396', '123456', '67', 'Male', '1995-11-11', 'das@gmail.com', 1, '2020-08-27 07:08:39', '2020-08-27 07:08:39'),
(5, 'Md. Tushar', NULL, '01748702672', '123456', '80', 'Male', '2020-09-01', NULL, 1, '2020-09-01 12:47:30', '2020-10-21 22:24:28'),
(8, 'test1', 'N/A', '01748702673', 'test123', '80', 'Male', '2020-09-01', NULL, 1, '2020-09-01 14:51:52', '2020-09-12 11:58:16'),
(9, 'SS', 'Dhaka', '01673954869', '01673954869', '75', 'Male', '1982-12-31', NULL, 1, '2020-09-02 17:09:27', '2020-09-02 17:25:26'),
(10, 'test patient', NULL, '01673963716', '01673963716', '89', 'Male', '1986-11-24', NULL, 1, '2020-09-05 19:59:08', '2021-03-27 02:21:41'),
(11, 'Anik Ansary Ricko', 'Mohammad pur, Dhaka', '01841597744', '111110', '86', 'Male', '1991-02-04', 'anikansary44@gmail', 1, '2020-09-07 10:58:06', '2021-04-14 13:27:35'),
(12, 'Md Mizanur Rahman', 'Rajshahi, Bangladesh', '01712579586', '1234567', '65', 'Male', '1977-10-08', 'miganurchapai1977@gmail.com', 1, '2020-09-17 06:58:57', '2021-02-20 21:09:52'),
(14, 'Chandra moni sagar', 'Dhaka', '01857099875', 'sagar0000', '62', 'Male', '2016-03-10', NULL, 1, '2020-10-09 23:11:02', '2020-10-21 22:35:30'),
(16, 'Nishad', NULL, '01558926125', '123456', '52', 'Male', '2016-10-10', NULL, 1, '2020-10-10 16:23:24', '2020-10-10 16:23:24'),
(18, 'Yasin', NULL, '01515207007', '123456', '58', 'Male', '1994-10-11', NULL, 1, '2020-10-11 07:40:21', '2020-10-22 12:09:59'),
(19, 'MD Raihan Uddin', 'Nijhumbag, South Tangra, Sharulia, Demra, Dhaka.', '01911441441', '558043', '85', 'Male', '1989-10-10', 'mdhafuddin@outlook.com', 1, '2020-10-11 19:02:18', '2020-10-22 21:41:02'),
(20, 'mounsur', NULL, '01911004334', '01911004334', '86', 'Male', '1986-11-24', NULL, 1, '2020-10-13 16:09:47', '2021-03-27 18:01:51'),
(21, 'Noorhan', NULL, '01819210643', '58845884', '110', 'Male', '2019-06-30', NULL, 1, '2020-10-14 18:07:28', '2021-02-08 15:22:19'),
(22, 'Md. Mahadee Hasan', NULL, '01712494813', 'Mh03760376', '74', 'Male', '1987-01-01', 'mahadee1803@gmail.com', 1, '2020-10-22 22:02:40', '2020-10-22 22:05:57'),
(23, 'Safiul Islam', 'h-17, R-06, Shakertek, mohammadpur', '01772183272', '727068sa', '75', 'Male', '1986-11-23', NULL, 1, '2020-10-23 01:35:23', '2020-10-23 01:35:23'),
(24, 'Ali Faisal Dip', 'Dhaka', '01717139404', 'Paatshala22', '74', 'Male', '1988-02-01', 'afaisal.dip@gmail.com', 1, '2020-10-26 17:20:56', '2020-10-26 17:20:56'),
(25, 'salim ullah', 'cox,sbazir', '01640845552', '7176', '55', 'Male', '1985-01-04', 'salimullah286@gmail.com', 1, '2020-10-31 00:23:06', '2020-10-31 00:23:06'),
(26, 'Md Nur Amin Anayet', 'Mehedibag Main Road, North Adabor, Dhaka. House: 23 Orpi Building', '01717487990', 'online@990', '96', 'Male', '2000-08-20', 'aunkur232@gmail.com', 1, '2020-11-07 03:50:21', '2021-06-05 01:37:45'),
(27, 'Md Rezaul Karim', 'Rajshahi', '01740483311', 'Reza@483311', '78', 'Male', '1996-02-10', 'rkreza24@gmail.com', 1, '2020-11-12 23:39:19', '2021-03-14 21:28:05'),
(28, 'Amanullah Chowdhury', NULL, '01717436111', '435577', '90', 'Male', '2020-12-13', 'aman.tanim@gmail.com', 1, '2020-12-13 23:57:59', '2020-12-13 23:57:59'),
(29, 'Hossain Ahmod', '10', '01846843843', 'Hossain Ahmod', '4085', 'Male', '2020-12-17', 'ahmodhossain558@gmail.com', 1, '2020-12-17 22:08:22', '2020-12-17 22:08:22'),
(30, 'Hrijoya Dey', NULL, '01811486879', 'JOY@bangla86', '11', 'Female', '2019-01-25', NULL, 1, '2020-12-18 09:34:20', '2020-12-18 09:34:20'),
(31, 'Shamima', 'rajshahi', '01767225585', 'markazrajshahi', '98', 'Female', '1972-12-20', NULL, 1, '2020-12-20 16:51:09', '2020-12-20 16:51:09'),
(32, 'Shoikot', '27/4,Dhakeshori Road Lalbagh Dhaka-1211.', '01715159847', 'masrooralam', '78', 'Male', '1989-04-20', 'shoikot369@gmail.com', 1, '2020-12-25 02:55:05', '2020-12-25 02:55:05'),
(33, 'Md.Azizur Rahman', NULL, '01946982725', 'sasthobd', '58', 'Male', '1995-01-01', NULL, 1, '2020-12-27 12:49:09', '2020-12-27 12:49:09'),
(34, 'Ruhul Amin', NULL, '01911745974', '111611', '71', 'Male', '1987-03-03', NULL, 1, '2021-01-09 23:08:27', '2021-01-09 23:08:27'),
(35, 'Syful', NULL, '01701290000', 'Skrp@1234', '95', 'Male', '1991-08-04', NULL, 1, '2021-01-10 15:44:11', '2021-01-10 15:44:11'),
(36, 'A.A.Riko', 'Panchagarh', '01745597744', '01745597744', '85', 'Male', '1991-02-04', NULL, 1, '2021-01-13 13:54:15', '2021-01-13 13:54:15'),
(39, 'Md. Mahade Hasan', 'Rajshahi', '01571790082', 'm123456++', '75', 'Male', '1995-09-16', 'mahadeak47@gmail.com', 1, '2021-01-23 12:28:33', '2021-02-11 20:52:06'),
(40, 'sabbir hossain', 'lalbagh', '01673899273', '123456', '62', 'Male', '1989-06-10', NULL, 1, '2021-01-25 16:57:47', '2021-01-25 16:57:47'),
(41, 'Sultana', NULL, '01715597557', '7557', '65', 'Female', '1989-06-26', NULL, 1, '2021-01-27 02:08:22', '2021-01-27 02:08:22'),
(42, 'khaled al mounsur', 'adabor, dhaka', '01778620942', '01673963716', '85', 'Male', '1986-11-24', 'khaledalmounsur@gmail.com', 1, '2021-02-02 20:54:15', '2021-02-02 20:54:15'),
(43, 'Safiul Islam', NULL, '01316949501', '727068', '75', 'Male', '1986-11-23', NULL, 1, '2021-02-04 17:05:22', '2021-02-04 17:05:22'),
(44, 'Md Abdur Rahman Shohag', '8/6 Salimullah Road Mohammadpur Dhaka', '01712092622', 'rokeyamo', '83', 'Male', '1988-01-10', 'sohag.pu.ece@gmail.com', 1, '2021-02-04 22:20:10', '2021-02-04 22:20:10'),
(45, 'shaonmridha', NULL, '01886696904', 'shaon2021', '75', 'Male', '1987-08-07', NULL, 1, '2021-02-05 13:24:14', '2021-02-05 13:24:14'),
(46, 'Sobuj Ahmad', NULL, '01712856524', 'dree2609', '71', 'Male', '1984-10-30', 'siraji.ahmad09@gmail.com', 1, '2021-02-08 09:56:09', '2021-02-08 09:56:09'),
(47, 'Repon dewan', 'vill-bauysar, post-noya para 1542', '01317750914', 'ripon123', '65', 'Male', '1986-10-10', 'dini10071@gmail.com', 1, '2021-02-08 12:24:14', '2021-02-08 12:24:14'),
(48, 'Tanim', 'Dhanmondi, Dhaka', '01837658000', '8910', '62', 'Male', '1989-10-31', 'tanim.chyctg@gmail.com', 1, '2021-02-09 13:47:30', '2021-02-09 13:47:30'),
(49, 'Debzoyti paul arpi', NULL, '01768265878', 'Ma143Arpi', '65', 'Female', '2001-01-01', NULL, 1, '2021-02-10 17:32:45', '2021-02-10 17:32:45'),
(50, 'Paul, Shubhra Prakash', NULL, '01795021093', 'P@ediatrician#', '80', 'Male', '1981-11-28', 'shuvro.paul@gmail.com', 1, '2021-02-11 22:34:21', '2021-02-11 22:34:21'),
(51, 'zia', NULL, '01712529772', '01712529772', '73', 'Male', '1984-01-15', 'joyalom0987@gmail.com', 1, '2021-02-14 16:56:11', '2021-02-14 16:56:11'),
(52, 'Md Ovee', NULL, '01874075515', 'ovee1234', '81', 'Male', '1986-03-19', 'masterovee@gmail.com', 1, '2021-02-16 15:19:46', '2021-02-16 15:19:46'),
(53, 'Mazhar Hossain', 'Bogura', '01746106550', '65945', '70', 'Female', '1965-08-06', 'mazhardinajpur@gmail.com', 1, '2021-02-16 22:31:04', '2021-02-16 22:31:04'),
(54, 'Md.Musharaf Hosen', 'Sreemangal, Moulvibazar', '01759325275', 'sayefft819', '55', 'Male', '1985-05-22', 'himelmusharaf9@gmail.com', 1, '2021-02-23 08:17:32', '2021-02-23 08:17:32'),
(55, 'Hridoy', NULL, '01309173151', '123456', '80', 'Male', '2021-02-27', NULL, 1, '2021-02-27 22:56:34', '2021-02-27 22:56:34'),
(56, 'ismat', 'house#5/11, Flat C6, Lalmatia Block F,Dhaka', '01833754504', '19november', '64', 'Female', '1974-05-04', 'ismat.munni@gmail.com', 1, '2021-03-01 19:06:06', '2021-03-01 19:06:06'),
(57, 'Shohel Shikdar', 'Silicon Roseline 7 B,Road 17, House 1017, Baitul Aman Housing Society, Adabar. Dhaka', '01711958087', 'Shohel@123', '85', 'Male', '1987-01-01', 'shohelshikdar1@gmail.com', 1, '2021-03-07 23:01:16', '2021-03-07 23:01:16'),
(58, 'Abu Darda', 'shyamoli, Dhaka', '01752707447', 'tamanna123', '85', 'Male', '1993-12-01', 'adarda228@gmail.com', 1, '2021-03-10 21:40:45', '2021-03-10 21:40:45'),
(59, 'Shahadat H Shahal', NULL, '01877585773', 'sadhashahalw6@', '70', 'Male', '2003-05-15', 'shahadatw6@gmail.com', 1, '2021-03-13 17:00:11', '2021-03-13 17:00:11'),
(60, 'Md. Ali Jinnah', 'Panchagarh', '01718626683', '01718626683', '69', 'Male', '1952-02-07', NULL, 1, '2021-03-16 01:27:55', '2021-03-16 01:27:55'),
(61, 'Selim reza', 'vill.Dasgram post.Chandihat thana.Baraigrà Dist.Natore', '01303382096', 'selim123***', '60', 'Male', '1987-02-19', 'selim304383@gmail.com', 1, '2021-03-17 10:35:11', '2021-03-17 10:35:11'),
(62, 'Umme Afruz', NULL, '01913673100', '1loveAllah', '64', 'Female', '1996-11-25', NULL, 1, '2021-03-18 21:53:40', '2021-03-18 21:53:40'),
(63, 'Uzzal Ali', 'natore', '01704492716', '12481632@', '61', 'Male', '1998-12-16', 'uzzalali207@gmail.com', 1, '2021-03-20 20:55:35', '2021-03-20 20:55:35'),
(64, 'Sabbir Razin Humayun', NULL, '01715001069', 'hulk1986', '88', 'Male', '1986-08-26', NULL, 1, '2021-03-20 22:42:27', '2021-03-20 22:42:27'),
(65, 'Mohammad siam', 'Dhanmondi', '01719143488', 'mohammad1000', '63', 'Male', '1995-02-18', 'siamkhan327@gmail.com', 1, '2021-03-22 16:07:12', '2021-03-22 16:07:12'),
(66, 'Shuvo Sarder', 'gaibandha', '01910810411', 'Shuvoshammi', '74', 'Male', '1993-07-09', 'shuvo125914@gmail.com', 1, '2021-03-23 16:41:30', '2021-03-23 16:41:30'),
(67, 'Dr Rezoana Munir', 'House C5, BAEC Housing, Rd#2, Banani, Dhaka', '01958048595', 'sumi@munir', '56', 'Female', '1979-12-09', 'tstariq2007@gmail.com', 1, '2021-03-23 21:34:32', '2021-03-23 21:34:32'),
(68, 'Ebrahim', NULL, '01738853592', 'qwerty', '165', 'Male', '1967-03-23', NULL, 1, '2021-03-23 21:41:10', '2021-03-23 21:41:10'),
(69, 'nusrat', NULL, '01795747408', 'health', '51', 'Female', '1993-12-20', NULL, 1, '2021-03-24 18:58:12', '2021-03-24 18:58:12'),
(71, 'Md Jamil Raihan Bin Islam', 'Dhaka', '01710572006', 'marin', '76', 'Male', '1985-12-07', 'ma_marin@yahoo.com', 1, '2021-03-26 21:42:49', '2021-03-26 21:42:49'),
(72, 'NAYEEM BHUIYAN', 'Gouripur,Daudhkandi,Cumilla', '01533752445', 'nb160762', '60', 'Male', '2000-03-21', 'nayeembhuiyan746@gmail.com', 1, '2021-03-29 23:09:11', '2021-03-29 23:09:11'),
(73, 'sbd', NULL, '01966622262', '01966622262', NULL, NULL, NULL, NULL, 1, '2021-04-01 19:11:21', '2021-04-01 19:11:21'),
(74, 'Saiful Alam', 'Sylhet', '01711669062', '4605', '75', 'Male', '2001-01-01', 'saifulalam4605@gmail.com', 1, '2021-04-11 18:01:53', '2021-04-11 18:05:11'),
(75, 'Shayon Raaz Raaz', 'Nabagram gopalpur tangail', '01732528018', 'Shayon Raaz Raaz', '67', 'Male', '1995-02-02', 'shayonraazraaz@gmail.com', 1, '2021-04-11 21:32:41', '2021-04-11 21:32:41'),
(76, 'rahat', NULL, '01740563828', '123', NULL, NULL, NULL, NULL, 1, '2021-04-11 21:57:17', '2021-04-11 21:57:17'),
(78, 'sarfarj', NULL, '01673855250', '123', NULL, NULL, NULL, NULL, 1, '2021-04-12 22:07:48', '2021-04-12 22:07:48'),
(79, 'Ariful Islam', 'Sadar, Jashore.', '01312347075', '01312347075arif', '67', 'Male', '1990-10-28', 'arifulislamjsr7@gmail.com', 1, '2021-04-17 04:13:07', '2021-05-19 14:12:19'),
(80, 'Vivek Das', NULL, '01701034858', '123456', NULL, NULL, NULL, NULL, 1, '2021-04-20 12:45:15', '2021-04-20 12:45:15'),
(81, 'Anik SarKar', NULL, '01600194208', 'Anik@4687', NULL, NULL, NULL, NULL, 1, '2021-05-09 02:51:33', '2021-05-09 02:51:33'),
(82, 'ahsan habib', NULL, '01725823761', '823761', NULL, NULL, NULL, NULL, 1, '2021-05-11 23:38:30', '2021-05-11 23:38:30'),
(83, 'mamun', NULL, '01737439008', '01737439008', NULL, NULL, NULL, NULL, 1, '2021-05-16 20:08:16', '2021-05-16 20:08:16'),
(84, 'SUJAN CHANDRA RAY', NULL, '01774136190', '11115275', NULL, NULL, NULL, NULL, 1, '2021-05-17 09:28:19', '2021-05-17 09:28:19'),
(85, 'Md Rana Miah', NULL, '01777664786', 'rana12345rana', NULL, NULL, NULL, NULL, 1, '2021-05-24 15:32:35', '2021-05-24 15:32:35'),
(86, 'Jasmin Akter', NULL, '01825042220', '8549', NULL, NULL, NULL, NULL, 1, '2021-05-28 11:38:03', '2021-05-28 11:38:03'),
(87, 'Md Bablu Miah', NULL, '01747453677', 'Bablu1234', NULL, NULL, NULL, NULL, 1, '2021-06-03 16:33:20', '2021-06-03 16:33:20'),
(88, 'Md Sazzad Ahmed Sojib', NULL, '01777325653', '12345', NULL, NULL, NULL, NULL, 1, '2021-06-06 08:09:35', '2021-06-06 08:09:35'),
(89, 'Md.Humayun Kobir', NULL, '01770279593', '294700', NULL, NULL, NULL, NULL, 1, '2021-06-11 12:02:00', '2021-06-11 12:02:00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_patientfile`
--

CREATE TABLE `tbl_patientfile` (
  `OID` bigint(20) NOT NULL,
  `PatientID` varchar(50) DEFAULT NULL,
  `PFile` varchar(200) DEFAULT NULL,
  `fileName` varchar(255) DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_patientfile`
--

INSERT INTO `tbl_patientfile` (`OID`, `PatientID`, `PFile`, `fileName`, `Created_at`, `Updated_at`) VALUES
(61, '9', 'http://103.108.140.210:8000/uploads/patientFile/9_1602675739.png', '9_1602675739.png', '2020-10-14 17:42:24', '2020-10-14 17:42:24'),
(89, '1', 'https://api.shasthobd.com/uploads/patientFile/1_1617865157.jpg', '1_1617865157.jpg', '2021-04-08 12:59:17', '2021-04-08 12:59:17'),
(107, '10', 'https://api.shasthobd.com/uploads/patientFile/10_1618608116.png', '10_1618608116.png', '2021-04-17 03:21:56', '2021-04-17 03:21:56'),
(105, '11', 'https://api.shasthobd.com/uploads/patientFile/11_1618385458.png', '11_1618385458.png', '2021-04-14 13:30:58', '2021-04-14 13:30:58'),
(13, '8', 'http://103.108.140.210:8000/uploads/patientFile/8_1598972282.png', '8_1598972282.png', '2020-09-01 14:58:03', NULL),
(94, '3', 'https://api.shasthobd.com/uploads/patientFile/3_1618212562.png', '3_1618212562.png', '2021-04-12 13:29:22', '2021-04-12 13:29:22'),
(54, '5', 'http://103.108.140.210:8000/uploads/patientFile/5_1602322899.png', '5_1602322899.png', '2020-10-10 15:41:39', '2020-10-10 15:41:39'),
(55, '16', 'http://103.108.140.210:8000/uploads/patientFile/16_1602342254.png', '16_1602342254.png', '2020-10-10 21:04:15', '2020-10-10 21:04:15'),
(56, '14', 'http://103.108.140.210:8000/uploads/patientFile/14_1602348451.png', '14_1602348451.png', '2020-10-10 22:47:32', '2020-10-10 22:47:32'),
(57, '18', 'http://103.108.140.210:8000/uploads/patientFile/18_1602380677.png', '18_1602380677.png', '2020-10-11 07:44:37', '2020-10-11 07:44:37'),
(63, '19', 'http://103.108.140.210:8000/uploads/patientFile/19_1603380582.png', '19_1603380582.png', '2020-10-22 21:29:47', '2020-10-22 21:29:47'),
(74, '21', 'https://api.shasthobd.com/uploads/patientFile/21_1612776216.png', '21_1612776216.png', '2021-02-08 15:23:36', '2021-02-08 15:23:36'),
(64, '23', 'http://103.108.140.210:8000/uploads/patientFile/23_1603395808.png', '23_1603395808.png', '2020-10-23 01:43:29', '2020-10-23 01:43:29'),
(65, '25', 'http://103.108.140.210:8000/uploads/patientFile/25_1604083763.png', '25_1604083763.png', '2020-10-31 00:49:23', '2020-10-31 00:49:23'),
(66, '12', 'http://103.108.140.210:8000/uploads/patientFile/12_1604560094.png', '12_1604560094.png', '2020-11-05 13:08:14', '2020-11-05 13:08:14'),
(68, '17', 'https://api.shasthobd.com/uploads/patientFile/17_1608202128.png', '17_1608202128.png', '2020-12-17 16:48:48', '2020-12-17 16:48:48'),
(72, '32', 'http://103.108.140.210:8000/uploads/patientFile/32_1608843622.png', '32_1608843622.png', '2020-12-25 03:00:24', '2020-12-25 03:00:24'),
(73, '38', 'https://api.shasthobd.com/uploads/patientFile/38_1611238422.png', '38_1611238422.png', '2021-01-21 20:13:42', '2021-01-21 20:13:42'),
(87, '70', 'https://api.shasthobd.com/uploads/patientFile/70_1617842907.png', '70_1617842907.png', '2021-04-08 06:48:27', '2021-04-08 06:48:27'),
(95, '40', 'https://api.shasthobd.com/uploads/patientFile/40_1618220981.png', '40_1618220981.png', '2021-04-12 15:49:41', '2021-04-12 15:49:41'),
(108, '83', 'https://api.shasthobd.com/uploads/patientFile/83_1621174271.png', '83_1621174271.png', '2021-05-16 20:11:11', '2021-05-16 20:11:11'),
(109, '79', 'https://api.shasthobd.com/uploads/patientFile/79_1621411924.png', '79_1621411924.png', '2021-05-19 14:12:04', '2021-05-19 14:12:04');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_patientreport`
--

CREATE TABLE `tbl_patientreport` (
  `OID` bigint(20) NOT NULL,
  `PatientID` varchar(50) DEFAULT NULL,
  `RelativeID` int(111) NOT NULL DEFAULT 0,
  `ReportFile` varchar(200) DEFAULT NULL,
  `fileName` varchar(255) NOT NULL,
  `ReportName` varchar(200) DEFAULT NULL,
  `ReportDate` date DEFAULT current_timestamp(),
  `Created_at` datetime DEFAULT NULL,
  `Updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_patientreport`
--

INSERT INTO `tbl_patientreport` (`OID`, `PatientID`, `RelativeID`, `ReportFile`, `fileName`, `ReportName`, `ReportDate`, `Created_at`, `Updated_at`) VALUES
(1, '10', 0, 'http://103.108.140.210:8000/uploads/patientFile/14_1602264198.png', '14_1602264198.png', 'Cbc', '2020-10-09', '2020-10-09 23:23:19', '2020-10-09 23:23:19'),
(2, '14', 0, 'http://103.108.140.210:8000/uploads/patientFile/3_1602265598.png', '3_1602265598.png', 'test', '2020-10-09', '2020-10-09 23:46:38', '2020-10-09 23:46:38'),
(3, '18', 0, 'http://103.108.140.210:8000/uploads/patientFile/15_1602324759.png', '15_1602324759.png', 'selfi', '2020-10-09', '2020-10-10 16:12:39', '2020-10-10 16:12:39'),
(4, '5', 0, 'http://103.108.140.210:8000/uploads/patientFile/5_1605946602.png', '5_1605946602.png', 'hhh', '2020-10-09', '2020-11-21 14:16:43', '2020-11-21 14:16:43'),
(5, '10', 0, 'http://103.108.140.210:8000/uploads/patientFile/10_1606501916.png', '10_1606501916.png', 'A', '2020-11-28', '2020-11-28 00:31:56', '2020-11-28 00:31:56'),
(6, '10', 0, 'http://103.108.140.210:8000/uploads/patientFile/10_1607627662.png', '10_1607627662.png', 'aaa', '2020-12-11', '2020-12-11 01:14:25', '2020-12-11 01:14:25'),
(7, '19', 0, 'http://103.108.140.210:8000/uploads/patientFile/19_1607628883.png', '19_1607628883.png', 'abc', '2020-12-11', '2020-12-11 01:34:48', '2020-12-11 01:34:48'),
(8, '17', 0, 'https://api.shasthobd.com/uploads/patientFile/17_1608202239.png', '17_1608202239.png', 'madadona', '2020-12-17', '2020-12-17 16:50:39', '2020-12-17 16:50:39'),
(9, '17', 0, 'https://api.shasthobd.com/uploads/patientFile/17_1608202266.png', '17_1608202266.png', 'maradona 2', '2020-12-17', '2020-12-17 16:51:06', '2020-12-17 16:51:06'),
(10, '11', 0, 'http://103.108.140.210:8000/uploads/patientFile/11_1609326284.png', '11_1609326284.png', 'agag', '2020-12-30', '2020-12-30 17:04:45', '2020-12-30 17:04:45'),
(11, '11', 0, 'http://103.108.140.210:8000/uploads/patientFile/11_1609331141.png', '11_1609331141.png', '2', '2020-12-30', '2020-12-30 18:25:42', '2020-12-30 18:25:42'),
(12, '11', 0, 'http://103.108.140.210:8000/uploads/patientFile/11_1609657942.png', '11_1609657942.png', '3', '2021-01-03', '2021-01-03 13:12:22', '2021-01-03 13:12:22'),
(13, '3', 0, 'https://api.shasthobd.com/uploads/patientFile/3_1610003430.png', '3_1610003430.png', '1', '2021-01-07', '2021-01-07 13:10:30', '2021-01-07 13:10:30'),
(14, '10', 0, 'https://api.shasthobd.com/uploads/patientFile/10_1610185299.png', '10_1610185299.png', '1', '2021-01-09', '2021-01-09 15:41:39', '2021-01-09 15:41:39'),
(15, '3', 0, 'https://api.shasthobd.com/uploads/patientFile/3_1612085554.png', '3_1612085554.png', 'test', '2021-01-31', '2021-01-31 15:32:34', '2021-01-31 15:32:34'),
(16, '41', 0, 'https://api.shasthobd.com/uploads/patientFile/41_1614193911.png', '41_1614193911.png', '1', '2021-02-25', '2021-02-25 01:11:51', '2021-02-25 01:11:51'),
(17, '41', 0, 'https://api.shasthobd.com/uploads/patientFile/41_1614193945.png', '41_1614193945.png', '2', '2021-02-25', '2021-02-25 01:12:25', '2021-02-25 01:12:25'),
(18, '41', 0, 'https://api.shasthobd.com/uploads/patientFile/41_1614194595.png', '41_1614194595.png', '3', '2021-02-25', '2021-02-25 01:23:15', '2021-02-25 01:23:15'),
(19, '51', 0, 'https://api.shasthobd.com/uploads/patientFile/51_1614595738.png', '51_1614595738.png', '1', '2021-03-01', '2021-03-01 16:48:58', '2021-03-01 16:48:58'),
(20, '10', 0, 'https://api.shasthobd.com/uploads/patientFile/10_1614743954.png', '10_1614743954.png', '1', '2021-03-03', '2021-03-03 09:59:14', '2021-03-03 09:59:14'),
(21, '3', 11, 'https://api.shasthobd.com/uploads/patientReport/3_11_1616325592.png', '3_11_1616325592.png', '13', '2021-03-21', '2021-03-21 17:19:52', '2021-03-21 17:19:52'),
(22, '3', 11, 'https://api.shasthobd.com/uploads/patientReport/3_11_1616414031.png', '3_11_1616414031.png', '1', '2021-03-22', '2021-03-22 17:53:51', '2021-03-22 17:53:51'),
(23, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616573137.png', '3_0_1616573137.png', '1', '2021-03-24', '2021-03-24 14:05:37', '2021-03-24 14:05:37'),
(24, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616573160.png', '3_0_1616573160.png', '1', '2021-03-24', '2021-03-24 14:06:00', '2021-03-24 14:06:00'),
(25, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616573332.png', '3_0_1616573332.png', '1', '2021-03-24', '2021-03-24 14:08:52', '2021-03-24 14:08:52'),
(26, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616573352.png', '3_0_1616573352.png', '2', '2021-03-24', '2021-03-24 14:09:12', '2021-03-24 14:09:12'),
(27, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616574339.png', '3_0_1616574339.png', '1', '2021-03-24', '2021-03-24 14:25:39', '2021-03-24 14:25:39'),
(28, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616574353.png', '3_0_1616574353.png', '2', '2021-03-24', '2021-03-24 14:25:53', '2021-03-24 14:25:53'),
(29, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616574371.png', '3_0_1616574371.png', '3', '2021-03-24', '2021-03-24 14:26:11', '2021-03-24 14:26:11'),
(30, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575178.png', '3_0_1616575178.png', '1', '2021-03-24', '2021-03-24 14:39:38', '2021-03-24 14:39:38'),
(31, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575204.png', '3_0_1616575204.png', '3', '2021-03-24', '2021-03-24 14:40:04', '2021-03-24 14:40:04'),
(32, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575213.png', '3_0_1616575213.png', '4', '2021-03-24', '2021-03-24 14:40:13', '2021-03-24 14:40:13'),
(33, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575227.png', '3_0_1616575227.png', '5', '2021-03-24', '2021-03-24 14:40:27', '2021-03-24 14:40:27'),
(34, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575261.png', '3_0_1616575261.png', '1', '2021-03-24', '2021-03-24 14:41:01', '2021-03-24 14:41:01'),
(35, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575659.png', '3_0_1616575659.png', '1', '2021-03-24', '2021-03-24 14:47:39', '2021-03-24 14:47:39'),
(36, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616575733.png', '3_0_1616575733.png', '1', '2021-03-24', '2021-03-24 14:48:53', '2021-03-24 14:48:53'),
(37, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616576043.png', '3_0_1616576043.png', '1', '2021-03-24', '2021-03-24 14:54:03', '2021-03-24 14:54:03'),
(38, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1616576070.png', '3_0_1616576070.png', '2', '2021-03-24', '2021-03-24 14:54:30', '2021-03-24 14:54:30'),
(39, '3', 17, 'https://api.shasthobd.com/uploads/patientReport/3_17_1616576109.png', '3_17_1616576109.png', '1', '2021-03-24', '2021-03-24 14:55:09', '2021-03-24 14:55:09'),
(40, '3', 25, 'https://api.shasthobd.com/uploads/patientReport/3_25_1616773110.png', '3_25_1616773110.png', '1', '2021-03-26', '2021-03-26 21:38:30', '2021-03-26 21:38:30'),
(41, '3', 25, 'https://api.shasthobd.com/uploads/patientReport/3_25_1616773125.png', '3_25_1616773125.png', '2', '2021-03-26', '2021-03-26 21:38:45', '2021-03-26 21:38:45'),
(42, '3', 25, 'https://api.shasthobd.com/uploads/patientReport/3_25_1616773139.png', '3_25_1616773139.png', '3', '2021-03-26', '2021-03-26 21:38:59', '2021-03-26 21:38:59'),
(43, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1616842816.png', '11_0_1616842816.png', '1', '2021-03-27', '2021-03-27 17:00:16', '2021-03-27 17:00:16'),
(44, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1616842960.png', '11_0_1616842960.png', '1', '2021-03-27', '2021-03-27 17:02:40', '2021-03-27 17:02:40'),
(45, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1616842985.png', '11_0_1616842985.png', '2', '2021-03-27', '2021-03-27 17:03:05', '2021-03-27 17:03:05'),
(46, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1616843099.png', '11_0_1616843099.png', '1', '2021-03-27', '2021-03-27 17:04:59', '2021-03-27 17:04:59'),
(47, '3', 6, 'https://api.shasthobd.com/uploads/patientReport/3_6_1617865342.jpg', '3_6_1617865342.jpg', '1', '2021-04-08', '2021-04-08 13:02:22', '2021-04-08 13:02:22'),
(48, '3', 6, 'https://api.shasthobd.com/uploads/patientReport/3_6_1617865703.jpg', '3_6_1617865703.jpg', '2', '2021-04-08', '2021-04-08 13:08:23', '2021-04-08 13:08:23'),
(49, '3', 7, 'https://api.shasthobd.com/uploads/patientReport/3_7_1617865713.jpg', '3_7_1617865713.jpg', '1', '2021-04-08', '2021-04-08 13:08:33', '2021-04-08 13:08:33'),
(50, '3', 25, 'https://api.shasthobd.com/uploads/patientReport/3_25_1617865752.png', '3_25_1617865752.png', '1', '2021-04-08', '2021-04-08 13:09:12', '2021-04-08 13:09:12'),
(51, '3', 19, 'https://api.shasthobd.com/uploads/patientReport/3_19_1617865777.png', '3_19_1617865777.png', '1', '2021-04-08', '2021-04-08 13:09:37', '2021-04-08 13:09:37'),
(52, '3', 19, 'https://api.shasthobd.com/uploads/patientReport/3_19_1617865847.png', '3_19_1617865847.png', '2', '2021-04-08', '2021-04-08 13:10:47', '2021-04-08 13:10:47'),
(53, '3', 19, 'https://api.shasthobd.com/uploads/patientReport/3_19_1618389924.png', '3_19_1618389924.png', '1', '2021-04-14', '2021-04-14 14:45:24', '2021-04-14 14:45:24'),
(54, '3', 19, 'https://api.shasthobd.com/uploads/patientReport/3_19_1618389961.png', '3_19_1618389961.png', '2', '2021-04-14', '2021-04-14 14:46:01', '2021-04-14 14:46:01'),
(55, '3', 19, 'https://api.shasthobd.com/uploads/patientReport/3_19_1618389993.png', '3_19_1618389993.png', '3', '2021-04-14', '2021-04-14 14:46:33', '2021-04-14 14:46:33'),
(56, '11', 31, 'https://api.shasthobd.com/uploads/patientReport/11_31_1618408483.png', '11_31_1618408483.png', '1', '2021-04-14', '2021-04-14 19:54:43', '2021-04-14 19:54:43'),
(57, '3', 1, 'https://api.shasthobd.com/uploads/patientReport/3_1_1618596238.jpg', '3_1_1618596238.jpg', '1', '2021-04-17', '2021-04-17 00:03:58', '2021-04-17 00:03:58'),
(58, '3', 0, 'https://api.shasthobd.com/uploads/patientReport/3_0_1618597005.jpg', '3_0_1618597005.jpg', '2', '2021-04-17', '2021-04-17 00:16:45', '2021-04-17 00:16:45'),
(59, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1618601035.png', '11_0_1618601035.png', '1', '2021-04-17', '2021-04-17 01:23:55', '2021-04-17 01:23:55'),
(60, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1618601053.png', '11_0_1618601053.png', '2', '2021-04-17', '2021-04-17 01:24:13', '2021-04-17 01:24:13'),
(61, '11', 0, 'https://api.shasthobd.com/uploads/patientReport/11_0_1618601174.png', '11_0_1618601174.png', '3', '2021-04-17', '2021-04-17 01:26:14', '2021-04-17 01:26:14'),
(62, '11', 31, 'https://api.shasthobd.com/uploads/patientReport/11_31_1618601194.png', '11_31_1618601194.png', '1', '2021-04-17', '2021-04-17 01:26:34', '2021-04-17 01:26:34'),
(63, '10', 0, 'https://api.shasthobd.com/uploads/patientReport/10_0_1618607903.png', '10_0_1618607903.png', '1', '2021-04-17', '2021-04-17 03:18:23', '2021-04-17 03:18:23'),
(64, '10', 0, 'https://api.shasthobd.com/uploads/patientReport/10_0_1618607934.png', '10_0_1618607934.png', '2', '2021-04-17', '2021-04-17 03:18:54', '2021-04-17 03:18:54'),
(65, '10', 0, 'https://api.shasthobd.com/uploads/patientReport/10_0_1618607958.png', '10_0_1618607958.png', '3', '2021-04-17', '2021-04-17 03:19:18', '2021-04-17 03:19:18'),
(66, '80', 0, 'https://api.shasthobd.com/uploads/patientReport/80_0_1618901310.png', '80_0_1618901310.png', '1', '2021-04-20', '2021-04-20 12:48:30', '2021-04-20 12:48:30');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_patient_activity_instant`
--

CREATE TABLE `tbl_patient_activity_instant` (
  `id` int(111) NOT NULL,
  `patientID` int(111) NOT NULL,
  `doctorID` int(111) NOT NULL,
  `txn_id` varchar(300) NOT NULL DEFAULT ' ',
  `reasonID` varchar(255) NOT NULL DEFAULT '0',
  `amount` varchar(255) NOT NULL DEFAULT '0',
  `paid_amount` varchar(255) NOT NULL DEFAULT '0',
  `cupon_code` varchar(255) NOT NULL DEFAULT '0 ',
  `cupon_percent` varchar(255) NOT NULL DEFAULT '0 ',
  `service_quantity` int(111) NOT NULL DEFAULT 1,
  `service_available` int(111) NOT NULL DEFAULT 1,
  `service_used` int(111) NOT NULL DEFAULT 0,
  `service_status` varchar(255) NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_patient_activity_instant`
--

INSERT INTO `tbl_patient_activity_instant` (`id`, `patientID`, `doctorID`, `txn_id`, `reasonID`, `amount`, `paid_amount`, `cupon_code`, `cupon_percent`, `service_quantity`, `service_available`, `service_used`, `service_status`, `created_at`, `updated_at`) VALUES
(12, 5, 20, '789087666698765', '0', '10.00', '9.80', '10percentOFF', '10', 1, 1, 1, 'done', '2020-10-09 10:20:43', '2020-10-10 19:13:57'),
(15, 15, 8, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-10-10 15:43:58', '2020-10-10 19:13:57'),
(10, 3, 14, '213wqdqwe312e1', '0', '100', '90', '10percentOFF', '10', 1, 1, 1, 'done', '2020-10-08 01:37:49', '2020-10-10 14:16:54'),
(13, 14, 20, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-10-09 23:16:18', '2020-10-10 19:13:57'),
(14, 3, 20, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-10-09 23:53:31', '2020-10-10 19:13:57'),
(16, 15, 8, 'txn234554321', '0', '10', '10', '0', '0', 1, 1, 1, 'active', '2020-10-10 16:04:29', '2020-10-10 16:09:21'),
(17, 16, 8, '789087666698', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-10 16:27:05', '2020-10-10 16:27:05'),
(18, 16, 8, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'active', '2020-10-10 16:37:00', '2020-10-10 19:13:57'),
(19, 5, 19, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-10 21:38:47', '2020-10-10 21:38:47'),
(20, 5, 19, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-10 21:44:19', '2020-10-10 21:44:19'),
(21, 3, 8, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-11 00:27:51', '2020-10-11 00:27:51'),
(22, 3, 8, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-11 00:31:14', '2020-10-11 00:31:14'),
(23, 3, 8, '789087666698765', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-11 00:50:41', '2020-10-11 00:50:41'),
(24, 17, 8, 'BGW29052020101108856', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-11 01:46:26', '2020-10-11 01:46:26'),
(25, 18, 19, 'BGW36952020101161269', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-11 07:48:54', '2020-10-11 07:48:54'),
(26, 14, 20, 'BGW10492020101161374', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-10-11 07:49:43', '2020-10-11 07:56:53'),
(27, 10, 1, 'BGW62612020101356158', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-13 14:02:55', '2020-10-13 14:02:55'),
(28, 11, 1, 'BGW26012020101450652', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-14 13:17:18', '2020-10-14 13:17:18'),
(29, 10, 36, 'BGW71832020101465140', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-14 15:19:33', '2020-10-14 15:19:33'),
(30, 20, 36, 'BGW87212020101467162', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-14 15:37:05', '2020-10-14 15:37:05'),
(31, 14, 19, 'BGW79692020101471833', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-10-14 16:15:38', '2020-10-14 16:21:31'),
(32, 9, 36, 'BGW17312020101482024', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-14 17:44:45', '2020-10-14 17:44:45'),
(33, 14, 19, 'BGW28002020101802809', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-10-18 00:28:48', '2020-10-22 12:24:13'),
(34, 19, 36, 'BGW361920201022124884', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-10-22 21:22:29', '2020-10-22 21:22:29'),
(35, 10, 19, 'BGW62882020110901343', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-11-09 00:15:04', '2020-11-10 19:41:52'),
(36, 19, 38, 'BGW64842020121103856', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-12-11 01:33:33', '2020-12-11 01:33:33'),
(37, 17, 36, 'BGW89072020121741868', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-12-17 16:36:13', '2020-12-17 16:41:56'),
(38, 3, 39, 'BGW36832020121751436', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2020-12-17 18:40:56', '2020-12-17 18:40:56'),
(39, 30, 23, 'BGW77952020121810833', '0', '750.00', '735.00', '0', '0', 1, 1, 0, 'active', '2020-12-18 09:45:06', '2020-12-18 09:45:06'),
(40, 11, 41, 'NG36802020123051356', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-12-30 16:52:43', '2021-01-03 15:49:59'),
(41, 11, 41, 'BGW67022020123057903', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2020-12-30 18:02:55', '2021-01-10 17:01:39'),
(42, 11, 41, 'BGW38392021010330175', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-01-03 13:11:20', '2021-01-03 14:07:13'),
(43, 3, 42, 'NG65182021010734014', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-01-07 14:02:11', '2021-01-31 15:54:45'),
(44, 3, 42, 'NG32042021010739065', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-01-07 15:07:40', '2021-02-01 23:53:57'),
(45, 10, 41, 'NG56232021010902709', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-01-09 01:12:35', '2021-01-10 15:59:30'),
(46, 3, 41, 'NG87462021011501893', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-01-15 00:35:00', '2021-01-15 00:35:00'),
(47, 11, 41, 'BGT72932021011635694', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-01-16 13:47:19', '2021-01-16 14:00:52'),
(48, 11, 41, 'BGT46302021011637640', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-01-16 14:10:58', '2021-02-23 15:26:59'),
(49, 11, 41, 'BGT45742021011930898', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-01-19 13:20:35', '2021-01-19 15:09:09'),
(50, 11, 41, 'BGT56862021011938760', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-01-19 15:13:13', '2021-01-19 15:24:21'),
(51, 3, 41, 'NG37132021012171040', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-01-21 20:11:42', '2021-01-21 20:11:42'),
(52, 10, 41, 'NG37212021012749761', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-01-27 16:02:30', '2021-01-27 18:52:54'),
(53, 11, 41, 'BGT79172021012769546', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-01-27 19:25:00', '2021-01-27 21:03:06'),
(54, 10, 41, 'NG27862021012832978', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-01-28 13:25:37', '2021-01-28 14:13:21'),
(55, 3, 42, 'BGT12812021020191071', '0', '10.00', '9.80', '50', '50', 1, 1, 1, 'done', '2021-02-01 23:30:37', '2021-04-20 13:13:22'),
(56, 3, 42, 'BGT72362021020192934', '0', '10.00', '9.80', '50', '50', 1, 1, 1, 'done', '2021-02-02 00:00:02', '2021-02-02 00:06:03'),
(57, 10, 41, 'NG48302021020904789', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-02-09 01:18:52', '2021-02-09 03:59:54'),
(58, 10, 41, 'NG92162021020907540', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-02-09 04:06:07', '2021-02-09 05:27:26'),
(59, 10, 41, 'NG69202021020907637', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-02-09 04:20:43', '2021-02-09 04:31:52'),
(60, 10, 41, 'NG28092021020950903', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-02-09 15:34:41', '2021-02-23 15:00:26'),
(61, 3, 42, 'BGT53852021021544690', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-02-15 14:42:11', '2021-02-24 22:54:38'),
(62, 3, 42, 'BGT31252021021553586', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-02-15 16:23:42', '2021-02-22 18:22:04'),
(63, 10, 41, 'NG34152021021562142', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-02-15 17:59:53', '2021-02-23 15:07:01'),
(64, 10, 41, 'NG18952021021648386', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-02-16 15:54:02', '2021-02-23 13:45:51'),
(65, 11, 41, 'BGT28252021021658053', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-02-16 17:53:41', '2021-02-25 00:59:49'),
(66, 10, 41, 'NG38382021022085028', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-02-20 20:03:50', '2021-02-23 14:00:02'),
(67, 41, 41, 'NG20422021022504008', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-02-25 01:07:23', '2021-02-25 01:07:23'),
(68, 11, 41, 'BGT69142021022767433', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-02-27 17:34:03', '2021-02-27 18:28:03'),
(69, 51, 41, 'NG25732021030162264', '0', '15.00', '14.70', '0', '0', 1, 1, 1, 'done', '2021-03-01 16:39:50', '2021-03-01 17:08:42'),
(70, 51, 41, 'NG59192021030256407', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-02 16:17:05', '2021-03-02 16:31:43'),
(71, 10, 41, 'NG24752021030322142', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-03-03 09:42:37', '2021-03-03 09:42:37'),
(72, 10, 41, 'NG22332021030323611', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-03 09:57:50', '2021-03-03 10:30:36'),
(73, 51, 59, 'NG75772021030363891', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-03 16:33:35', '2021-03-03 16:33:35'),
(74, 51, 59, 'NG77942021030365677', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2021-03-03 16:52:45', '2021-03-03 16:52:45'),
(75, 10, 59, 'BGT75532021030367443', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-03 17:12:05', '2021-03-03 17:12:05'),
(76, 11, 59, 'BGT97112021030368679', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-03 17:25:10', '2021-03-03 17:25:10'),
(77, 51, 70, 'NG63412021030699783', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-06 20:50:51', '2021-03-06 21:20:45'),
(78, 51, 63, 'NG479120210306104612', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-06 21:27:37', '2021-03-06 21:27:37'),
(79, 51, 40, 'NG51332021030727948', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-07 11:17:56', '2021-03-07 12:11:23'),
(80, 51, 40, 'NG85282021030728808', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-07 11:24:31', '2021-03-07 11:24:31'),
(81, 51, 26, 'BGT91372021030741136', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-07 13:01:54', '2021-03-07 13:19:16'),
(82, 51, 53, 'BGT77632021030886565', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-08 19:21:47', '2021-03-08 19:30:19'),
(83, 51, 7, 'BGT34512021030899920', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-08 20:55:33', '2021-03-08 21:03:12'),
(84, 51, 51, 'BGT18622021030976607', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-09 17:31:07', '2021-03-09 17:38:30'),
(85, 51, 45, 'BGT55332021030988986', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-09 18:53:43', '2021-03-09 18:56:57'),
(86, 51, 46, 'BGT64412021031052376', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-10 12:02:27', '2021-03-10 12:07:58'),
(87, 51, 68, 'BGT31622021031353735', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-13 13:06:30', '2021-03-13 13:20:40'),
(88, 51, 44, 'BGT121720210313108055', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-13 20:16:56', '2021-03-13 20:20:32'),
(89, 27, 1, 'BGT258620210314100530', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-03-14 21:33:35', '2021-03-15 19:14:48'),
(90, 51, 43, 'BGT61452021031741254', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-17 12:45:32', '2021-03-17 12:55:33'),
(91, 51, 55, 'BGT47472021032176658', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-21 17:42:32', '2021-03-21 17:49:45'),
(92, 51, 59, 'BGT43552021032190385', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-21 19:27:56', '2021-03-21 20:00:34'),
(93, 51, 59, 'BGT57582021032192604', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-03-21 19:43:03', '2021-03-21 20:09:46'),
(94, 51, 59, 'BGT69532021032197460', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-03-21 20:18:21', '2021-03-21 20:23:17'),
(95, 11, 41, 'BGT71792021032263858', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-03-22 16:26:39', '2021-03-22 16:26:39'),
(96, 3, 42, 'BGT21722021032281283', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-03-22 19:01:25', '2021-03-22 19:15:42'),
(97, 11, 52, 'BGT65272021032288317', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-22 19:52:53', '2021-03-22 19:52:53'),
(98, 11, 52, 'BGT27322021032289123', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2021-03-22 19:58:18', '2021-03-22 19:58:18'),
(99, 11, 54, 'BGT12382021032295063', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-22 20:42:12', '2021-03-22 20:52:29'),
(100, 3, 42, 'NG41422021032340366', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2021-03-23 13:23:18', '2021-03-23 13:23:18'),
(101, 11, 56, 'BGT80022021032424039', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-24 10:39:26', '2021-03-24 10:39:26'),
(102, 11, 50, 'BGT32932021032443041', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-24 13:23:16', '2021-03-24 13:35:32'),
(103, 11, 30, 'BGT16832021032485441', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-24 20:05:51', '2021-03-24 20:18:14'),
(104, 11, 68, 'BGT80232021032542691', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-25 13:07:19', '2021-03-25 13:31:50'),
(105, 3, 42, 'BGT249720210326101254', '0', '10.00', '9.80', '0', '0', 1, 1, 1, 'done', '2021-03-26 21:26:12', '2021-03-26 21:36:31'),
(106, 11, 41, 'BGT98732021032771115', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-03-27 16:48:13', '2021-03-27 16:48:13'),
(107, 11, 41, 'BGT99812021032771478', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-03-27 16:51:32', '2021-03-27 16:51:32'),
(108, 11, 77, 'BGT21392021032982460', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-29 19:58:44', '2021-03-29 20:11:04'),
(109, 11, 77, 'BGT17482021032984220', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-29 20:13:48', '2021-03-29 20:18:40'),
(110, 11, 49, 'BGT45262021033133273', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-31 11:50:55', '2021-03-31 12:07:54'),
(111, 9, 42, 'BGT53142021033134855', '0', '10.00', '9.80', '0', '0', 1, 1, 0, 'active', '2021-03-31 12:02:50', '2021-03-31 12:02:50'),
(112, 11, 72, 'BGT92872021033143563', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-03-31 13:09:50', '2021-03-31 13:30:23'),
(113, 11, 72, 'BGT70902021040160384', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-04-01 15:39:47', '2021-04-04 18:20:16'),
(114, 11, 6, 'BGT79312021041079460', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-04-10 17:08:03', '2021-04-10 18:48:15'),
(115, 11, 5, 'BGT89112021041166141', '0', '12.00', '11.76', '0', '0', 1, 1, 0, 'active', '2021-04-11 15:47:37', '2021-04-11 15:47:37'),
(116, 11, 78, 'BGT695420210411108768', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-04-11 21:03:41', '2021-04-11 21:07:48'),
(117, 11, 26, 'BGT65922021041248772', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-04-12 12:38:13', '2021-04-12 13:49:44'),
(118, 11, 51, 'BGT31032021041275322', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-04-12 16:02:16', '2021-04-12 17:05:43'),
(119, 11, 70, 'BGT43502021041293641', '0', '12.00', '11.76', '0', '0', 1, 1, 1, 'done', '2021-04-12 18:26:31', '2021-04-12 19:21:13'),
(120, 11, 41, 'BGT38432021041453828', '0', '15.00', '14.70', '0', '0', 1, 1, 0, 'active', '2021-04-14 13:01:30', '2021-04-14 13:01:30');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_permission`
--

CREATE TABLE `tbl_permission` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `sub_menu_id` int(11) DEFAULT NULL,
  `can_view` tinyint(4) NOT NULL,
  `added_by` varchar(255) DEFAULT NULL,
  `user_id` int(111) DEFAULT NULL,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_permission`
--

INSERT INTO `tbl_permission` (`id`, `role_id`, `menu_id`, `sub_menu_id`, `can_view`, `added_by`, `user_id`, `edate`) VALUES
(303, 1, 7, 25, 1, 'admin', 1, '2021-03-29 00:00:00'),
(302, 1, 7, 24, 1, 'admin', 1, '2021-03-29 00:00:00'),
(301, 1, 6, 15, 1, 'admin', 1, '2021-03-29 00:00:00'),
(300, 1, 4, 23, 1, 'admin', 1, '2021-03-29 00:00:00'),
(299, 1, 4, 22, 1, 'admin', 1, '2021-03-29 00:00:00'),
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
(321, 2, 7, 25, 1, 'admin', 1, '2021-03-29 00:00:00'),
(320, 2, 7, 24, 1, 'admin', 1, '2021-03-29 00:00:00'),
(319, 2, 6, 15, 1, 'admin', 1, '2021-03-29 00:00:00'),
(318, 2, 4, 23, 1, 'admin', 1, '2021-03-29 00:00:00'),
(298, 1, 4, 18, 1, 'admin', 1, '2021-03-29 00:00:00'),
(297, 1, 4, 17, 1, 'admin', 1, '2021-03-29 00:00:00'),
(296, 1, 4, 16, 1, 'admin', 1, '2021-03-29 00:00:00'),
(295, 1, 4, 14, 1, 'admin', 1, '2021-03-29 00:00:00'),
(294, 1, 3, 20, 1, 'admin', 1, '2021-03-29 00:00:00'),
(317, 2, 4, 22, 1, 'admin', 1, '2021-03-29 00:00:00'),
(316, 2, 4, 18, 1, 'admin', 1, '2021-03-29 00:00:00'),
(315, 2, 4, 17, 1, 'admin', 1, '2021-03-29 00:00:00'),
(293, 1, 3, 19, 1, 'admin', 1, '2021-03-29 00:00:00'),
(292, 1, 2, 27, 1, 'admin', 1, '2021-03-29 00:00:00'),
(314, 2, 4, 16, 1, 'admin', 1, '2021-03-29 00:00:00'),
(313, 2, 4, 14, 1, 'admin', 1, '2021-03-29 00:00:00'),
(312, 2, 2, 27, 1, 'admin', 1, '2021-03-29 00:00:00'),
(291, 1, 2, 21, 1, 'admin', 1, '2021-03-29 00:00:00'),
(290, 1, 2, 13, 1, 'admin', 1, '2021-03-29 00:00:00'),
(289, 1, 2, 2, 1, 'admin', 1, '2021-03-29 00:00:00'),
(288, 1, 1, 4, 1, 'admin', 1, '2021-03-29 00:00:00'),
(287, 1, 1, 1, 1, 'admin', 1, '2021-03-29 00:00:00'),
(286, 1, 7, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(285, 1, 6, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(284, 1, 4, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(283, 1, 3, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(282, 1, 2, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(281, 1, 1, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(311, 2, 2, 21, 1, 'admin', 1, '2021-03-29 00:00:00'),
(310, 2, 2, 13, 1, 'admin', 1, '2021-03-29 00:00:00'),
(309, 2, 2, 2, 1, 'admin', 1, '2021-03-29 00:00:00'),
(308, 2, 7, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(307, 2, 6, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(306, 2, 4, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(305, 2, 2, NULL, 1, 'admin', 1, '2021-03-29 00:00:00'),
(304, 1, 7, 26, 1, 'admin', 1, '2021-03-29 00:00:00'),
(322, 2, 7, 26, 1, 'admin', 1, '2021-03-29 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_prescriptionfile`
--

CREATE TABLE `tbl_prescriptionfile` (
  `Id` bigint(20) NOT NULL,
  `DOCID` varchar(50) DEFAULT NULL,
  `PatientID` varchar(50) DEFAULT NULL,
  `RelativeID` varchar(35) NOT NULL DEFAULT '0',
  `AppointmentID` varchar(255) NOT NULL DEFAULT '0',
  `RefNo` bigint(20) DEFAULT NULL,
  `FilePath` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_prescriptionfile`
--

INSERT INTO `tbl_prescriptionfile` (`Id`, `DOCID`, `PatientID`, `RelativeID`, `AppointmentID`, `RefNo`, `FilePath`, `created_at`, `updated_at`) VALUES
(7, '14', '3', '0', '0', 469991, 'http://103.108.140.210:8000/uploads/prescriptions/469991.pdf', '2020-10-10 11:26:33', '2020-10-10 11:26:33'),
(10, '20', '14', '0', '0', 331002, 'http://103.108.140.210:8000/uploads/prescriptions/331002.pdf', '2020-10-11 07:56:53', '2020-10-11 07:56:53'),
(11, '20', '14', '0', '0', 639427, 'http://103.108.140.210:8000/uploads/prescriptions/639427.pdf', '2020-10-14 16:21:25', '2020-10-14 16:21:25'),
(12, '2', '1', '0', '0', 645891, 'http://103.108.140.210:8000/uploads/prescriptions/645891.pdf', '2020-10-17 12:40:26', '2020-10-17 12:40:26'),
(13, '8', '14', '0', '0', 868073, 'http://103.108.140.210:8000/uploads/prescriptions/868073.pdf', '2020-10-22 12:24:12', '2020-10-22 12:24:12'),
(14, '38', '10', '0', '0', 86413, 'http://103.108.140.210:8000/uploads/prescriptions/86413.pdf', '2020-11-10 19:41:51', '2020-11-10 19:41:51'),
(15, '36', '17', '0', '0', 845432, 'https://api.shasthobd.com/uploads/prescriptions/845432.pdf', '2020-12-17 16:41:56', '2020-12-17 16:41:56'),
(16, '41', '11', '0', '0', 122391, 'https://api.shasthobd.com/uploads/prescriptions/122391.pdf', '2021-01-03 14:07:12', '2021-01-03 14:07:12'),
(17, '41', '11', '0', '0', 729117, 'https://api.shasthobd.com/uploads/prescriptions/729117.pdf', '2021-01-03 15:49:59', '2021-01-03 15:49:59'),
(18, '41', '10', '0', '0', 153693, 'https://api.shasthobd.com/uploads/prescriptions/153693.pdf', '2021-01-10 15:59:29', '2021-01-10 15:59:29'),
(19, '41', '11', '0', '0', 886582, 'https://api.shasthobd.com/uploads/prescriptions/886582.pdf', '2021-01-10 17:01:38', '2021-01-10 17:01:38'),
(20, '42', '3', '0', '0', 658633, 'https://api.shasthobd.com/uploads/prescriptions/658633.pdf', '2021-01-12 18:22:40', '2021-01-12 18:22:40'),
(21, '42', '3', '0', '0', 385674, 'https://api.shasthobd.com/uploads/prescriptions/385674.pdf', '2021-01-12 18:56:05', '2021-01-12 18:56:05'),
(22, '42', '3', '0', '0', 380253, 'https://api.shasthobd.com/uploads/prescriptions/380253.pdf', '2021-01-12 18:58:50', '2021-01-12 18:58:50'),
(23, '41', '11', '0', '0', 433163, 'https://api.shasthobd.com/uploads/prescriptions/433163.pdf', '2021-01-16 14:00:52', '2021-01-16 14:00:52'),
(24, '41', '11', '0', '0', 27775, 'https://api.shasthobd.com/uploads/prescriptions/27775.pdf', '2021-01-19 15:09:08', '2021-01-19 15:09:08'),
(25, '41', '11', '0', '0', 461142, 'https://api.shasthobd.com/uploads/prescriptions/461142.pdf', '2021-01-19 15:24:20', '2021-01-19 15:24:20'),
(26, '41', '10', '0', '0', 707896, 'https://api.shasthobd.com/uploads/prescriptions/707896.pdf', '2021-01-27 18:52:53', '2021-01-27 18:52:53'),
(27, '41', '11', '0', '0', 434873, 'https://api.shasthobd.com/uploads/prescriptions/434873.pdf', '2021-01-27 21:03:05', '2021-01-27 21:03:05'),
(28, '41', '10', '0', '0', 345416, 'https://api.shasthobd.com/uploads/prescriptions/345416.pdf', '2021-01-28 14:13:16', '2021-01-28 14:13:16'),
(29, '42', '3', '0', '0', 249239, 'https://api.shasthobd.com/uploads/prescriptions/249239.pdf', '2021-01-31 15:54:44', '2021-01-31 15:54:44'),
(30, '42', '3', '0', '0', 641115, 'https://api.shasthobd.com/uploads/prescriptions/641115.pdf', '2021-02-01 23:53:56', '2021-02-01 23:53:56'),
(31, '42', '3', '0', '0', 25881, 'https://api.shasthobd.com/uploads/prescriptions/25881.pdf', '2021-02-02 00:02:24', '2021-02-02 00:02:24'),
(32, '42', '3', '0', '0', 657147, 'https://api.shasthobd.com/uploads/prescriptions/657147.pdf', '2021-02-02 00:06:02', '2021-02-02 00:06:02'),
(33, '41', '10', '0', '0', 822405, 'https://api.shasthobd.com/uploads/prescriptions/822405.pdf', '2021-02-09 03:59:53', '2021-02-09 03:59:53'),
(34, '41', '10', '0', '0', 277642, 'https://api.shasthobd.com/uploads/prescriptions/277642.pdf', '2021-02-09 04:31:52', '2021-02-09 04:31:52'),
(35, '41', '10', '0', '0', 498333, 'https://api.shasthobd.com/uploads/prescriptions/498333.pdf', '2021-02-09 05:27:26', '2021-02-09 05:27:26'),
(36, '41', '10', '0', '0', 886060, 'https://api.shasthobd.com/uploads/prescriptions/886060.pdf', '2021-02-09 17:49:25', '2021-02-09 17:49:25'),
(37, '42', '3', '0', '0', 296928, 'https://api.shasthobd.com/uploads/prescriptions/296928.pdf', '2021-02-14 14:21:50', '2021-02-14 14:21:50'),
(38, '42', '3', '0', '0', 10142664, 'https://api.shasthobd.com/uploads/prescriptions/10142664.pdf', '2021-02-15 17:23:34', '2021-02-15 17:23:34'),
(39, '41', '10', '0', '0', 103610271, 'https://api.shasthobd.com/uploads/prescriptions/103610271.pdf', '2021-02-15 18:20:29', '2021-02-15 18:20:29'),
(40, '42', '3', '0', '0', 101456444, 'https://api.shasthobd.com/uploads/prescriptions/101456444.pdf', '2021-02-20 15:33:45', '2021-02-20 15:33:45'),
(41, '41', '10', '0', '0', 103656136, 'https://api.shasthobd.com/uploads/prescriptions/103656136.pdf', '2021-02-20 19:57:01', '2021-02-20 19:57:01'),
(42, '41', '10', '0', '0', 106917716, 'https://api.shasthobd.com/uploads/prescriptions/106917716.pdf', '2021-02-20 20:06:50', '2021-02-20 20:06:50'),
(43, '42', '3', '0', '0', 102902551, 'https://api.shasthobd.com/uploads/prescriptions/102902551.pdf', '2021-02-22 18:22:04', '2021-02-22 18:22:04'),
(44, '41', '10', '0', '0', 104433216, 'https://api.shasthobd.com/uploads/prescriptions/104433216.pdf', '2021-02-23 13:45:50', '2021-02-23 13:45:50'),
(45, '41', '10', '0', '0', 106873791, 'https://api.shasthobd.com/uploads/prescriptions/106873791.pdf', '2021-02-23 14:00:01', '2021-02-23 14:00:01'),
(46, '41', '10', '0', '0', 10017410, 'https://api.shasthobd.com/uploads/prescriptions/10017410.pdf', '2021-02-23 15:00:26', '2021-02-23 15:00:26'),
(47, '41', '10', '0', '0', 103651422, 'https://api.shasthobd.com/uploads/prescriptions/103651422.pdf', '2021-02-23 15:07:00', '2021-02-23 15:07:00'),
(48, '41', '11', '0', '0', 88680303, 'https://api.shasthobd.com/uploads/prescriptions/88680303.pdf', '2021-02-23 15:26:59', '2021-02-23 15:26:59'),
(49, '42', '3', '0', '0', 101141323, 'https://api.shasthobd.com/uploads/prescriptions/101141323.pdf', '2021-02-24 22:54:37', '2021-02-24 22:54:37'),
(50, '41', '11', '0', '0', 105813646, 'https://api.shasthobd.com/uploads/prescriptions/105813646.pdf', '2021-02-25 00:59:48', '2021-02-25 00:59:48'),
(51, '41', '11', '0', '0', 108125299, 'https://api.shasthobd.com/uploads/prescriptions/108125299.pdf', '2021-02-27 18:28:03', '2021-02-27 18:28:03'),
(52, '41', '51', '0', '0', 109736009, 'https://api.shasthobd.com/uploads/prescriptions/109736009.pdf', '2021-03-01 17:08:42', '2021-03-01 17:08:42'),
(53, '41', '51', '0', '0', 110653605, 'https://api.shasthobd.com/uploads/prescriptions/110653605.pdf', '2021-03-02 16:31:43', '2021-03-02 16:31:43'),
(54, '41', '10', '0', '0', 112888840, 'https://api.shasthobd.com/uploads/prescriptions/112888840.pdf', '2021-03-03 10:30:36', '2021-03-03 10:30:36'),
(55, '70', '51', '0', '0', 117177225, 'https://api.shasthobd.com/uploads/prescriptions/117177225.pdf', '2021-03-06 21:20:45', '2021-03-06 21:20:45'),
(56, '40', '51', '0', '0', 119155975, 'https://api.shasthobd.com/uploads/prescriptions/119155975.pdf', '2021-03-07 12:11:23', '2021-03-07 12:11:23'),
(57, '26', '51', '0', '0', 120356732, 'https://api.shasthobd.com/uploads/prescriptions/120356732.pdf', '2021-03-07 13:19:15', '2021-03-07 13:19:15'),
(58, '53', '51', '0', '0', 121996692, 'https://api.shasthobd.com/uploads/prescriptions/121996692.pdf', '2021-03-08 19:30:18', '2021-03-08 19:30:18'),
(59, '7', '51', '0', '0', 122653254, 'https://api.shasthobd.com/uploads/prescriptions/122653254.pdf', '2021-03-08 21:03:12', '2021-03-08 21:03:12'),
(60, '51', '51', '0', '0', 123771762, 'https://api.shasthobd.com/uploads/prescriptions/123771762.pdf', '2021-03-09 17:38:29', '2021-03-09 17:38:29'),
(61, '45', '51', '0', '0', 124555797, 'https://api.shasthobd.com/uploads/prescriptions/124555797.pdf', '2021-03-09 18:56:56', '2021-03-09 18:56:56'),
(62, '46', '51', '0', '0', 125468590, 'https://api.shasthobd.com/uploads/prescriptions/125468590.pdf', '2021-03-10 12:07:58', '2021-03-10 12:07:58'),
(63, '68', '51', '0', '0', 126916964, 'https://api.shasthobd.com/uploads/prescriptions/126916964.pdf', '2021-03-13 13:20:40', '2021-03-13 13:20:40'),
(64, '44', '51', '0', '0', 127470184, 'https://api.shasthobd.com/uploads/prescriptions/127470184.pdf', '2021-03-13 20:20:31', '2021-03-13 20:20:31'),
(65, '1', '27', '0', '0', 12829322, 'https://api.shasthobd.com/uploads/prescriptions/12829322.pdf', '2021-03-15 19:14:48', '2021-03-15 19:14:48'),
(66, '43', '51', '0', '0', 129692161, 'https://api.shasthobd.com/uploads/prescriptions/129692161.pdf', '2021-03-17 12:55:32', '2021-03-17 12:55:32'),
(67, '55', '51', '0', '0', 13064311, 'https://api.shasthobd.com/uploads/prescriptions/13064311.pdf', '2021-03-21 17:49:45', '2021-03-21 17:49:45'),
(68, '59', '51', '0', '0', 131620679, 'https://api.shasthobd.com/uploads/prescriptions/131620679.pdf', '2021-03-21 20:00:34', '2021-03-21 20:00:34'),
(69, '59', '51', '0', '0', 132217820, 'https://api.shasthobd.com/uploads/prescriptions/132217820.pdf', '2021-03-21 20:09:46', '2021-03-21 20:09:46'),
(70, '59', '51', '0', '0', 133716051, 'https://api.shasthobd.com/uploads/prescriptions/133716051.pdf', '2021-03-21 20:23:17', '2021-03-21 20:23:17'),
(71, '42', '3', '0', '0', 135672273, 'https://api.shasthobd.com/uploads/prescriptions/135672273.pdf', '2021-03-22 19:03:32', '2021-03-22 19:03:32'),
(72, '42', '3', '11', '135', 135568236, 'https://api.shasthobd.com/uploads/prescriptions/135568236.pdf', '2021-03-22 19:15:41', '2021-03-22 19:15:41'),
(73, '54', '11', '0', '138', 138186694, 'https://api.shasthobd.com/uploads/prescriptions/138186694.pdf', '2021-03-22 20:52:28', '2021-03-22 20:52:28'),
(74, '50', '11', '0', '141', 141258690, 'https://api.shasthobd.com/uploads/prescriptions/141258690.pdf', '2021-03-24 13:35:32', '2021-03-24 13:35:32'),
(75, '30', '11', '0', '142', 142986284, 'https://api.shasthobd.com/uploads/prescriptions/142986284.pdf', '2021-03-24 20:18:13', '2021-03-24 20:18:13'),
(76, '68', '11', '0', '143', 143241614, 'https://api.shasthobd.com/uploads/prescriptions/143241614.pdf', '2021-03-25 13:31:49', '2021-03-25 13:31:49'),
(77, '42', '3', '25', '144', 144117898, 'https://api.shasthobd.com/uploads/prescriptions/144117898.pdf', '2021-03-26 21:29:57', '2021-03-26 21:29:57'),
(78, '42', '3', '25', '144', 14497746, 'https://api.shasthobd.com/uploads/prescriptions/14497746.pdf', '2021-03-26 21:36:31', '2021-03-26 21:36:31'),
(79, '77', '11', '0', '147', 147673776, 'https://api.shasthobd.com/uploads/prescriptions/147673776.pdf', '2021-03-29 20:11:03', '2021-03-29 20:11:03'),
(80, '77', '11', '0', '148', 148248769, 'https://api.shasthobd.com/uploads/prescriptions/148248769.pdf', '2021-03-29 20:18:40', '2021-03-29 20:18:40'),
(81, '49', '11', '0', '149', 149748726, 'https://api.shasthobd.com/uploads/prescriptions/149748726.pdf', '2021-03-31 12:07:53', '2021-03-31 12:07:53'),
(82, '72', '11', '0', '151', 151973529, 'https://api.shasthobd.com/uploads/prescriptions/151973529.pdf', '2021-03-31 13:30:20', '2021-03-31 13:30:20'),
(83, '72', '11', '0', '152', 15225899, 'https://api.shasthobd.com/uploads/prescriptions/15225899.pdf', '2021-04-04 18:20:16', '2021-04-04 18:20:16'),
(84, '6', '11', '0', '153', 153803618, 'https://api.shasthobd.com/uploads/prescriptions/153803618.pdf', '2021-04-10 18:48:14', '2021-04-10 18:48:14'),
(85, '78', '11', '0', '155', 155594342, 'https://api.shasthobd.com/uploads/prescriptions/155594342.pdf', '2021-04-11 21:07:47', '2021-04-11 21:07:47'),
(86, '26', '11', '0', '156', 156207135, 'https://api.shasthobd.com/uploads/prescriptions/156207135.pdf', '2021-04-12 13:49:44', '2021-04-12 13:49:44'),
(87, '51', '11', '0', '157', 157975348, 'https://api.shasthobd.com/uploads/prescriptions/157975348.pdf', '2021-04-12 17:05:43', '2021-04-12 17:05:43'),
(88, '70', '11', '0', '158', 158922673, 'https://api.shasthobd.com/uploads/prescriptions/158922673.pdf', '2021-04-12 19:21:12', '2021-04-12 19:21:12'),
(89, '42', '3', '0', '95', 95363992, 'https://api.shasthobd.com/uploads/prescriptions/95363992.pdf', '2021-04-20 13:13:21', '2021-04-20 13:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_prescription_trace`
--

CREATE TABLE `tbl_prescription_trace` (
  `id` int(111) NOT NULL,
  `patient_id` int(111) NOT NULL,
  `prescription_id` int(111) NOT NULL,
  `fileName` varchar(255) NOT NULL DEFAULT ' ',
  `filePath` varchar(255) NOT NULL DEFAULT ' ',
  `fileName2` varchar(255) NOT NULL DEFAULT ' ',
  `filePath2` varchar(255) NOT NULL DEFAULT ' ',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_prescription_trace`
--

INSERT INTO `tbl_prescription_trace` (`id`, `patient_id`, `prescription_id`, `fileName`, `filePath`, `fileName2`, `filePath2`, `created_at`, `updated_at`) VALUES
(1, 2, 3, ' ', ' ', ' ', ' ', '2020-12-08 19:15:02', '2020-12-08 19:15:02'),
(2, 2, 4, ' ', ' ', ' ', ' ', '2020-12-16 19:32:39', '2020-12-16 19:32:39'),
(3, 5, 5, ' ', ' ', ' ', ' ', '2020-12-16 21:22:51', '2020-12-16 21:22:51'),
(4, 5, 6, ' ', ' ', ' ', ' ', '2020-12-16 22:06:43', '2020-12-16 22:06:43'),
(5, 3, 9, ' ', ' ', ' ', ' ', '2020-12-18 13:28:28', '2020-12-18 13:28:28'),
(6, 2, 10, ' ', ' ', ' ', ' ', '2020-12-20 22:13:09', '2020-12-20 22:13:09'),
(7, 5, 11, ' ', ' ', ' ', ' ', '2020-12-20 22:33:19', '2020-12-20 22:33:19'),
(8, 2, 13, ' ', ' ', ' ', ' ', '2020-12-26 20:11:51', '2020-12-26 20:11:51'),
(9, 2, 14, ' ', ' ', ' ', ' ', '2020-12-26 20:11:58', '2020-12-26 20:11:58'),
(10, 2, 15, ' ', ' ', ' ', ' ', '2020-12-26 20:12:04', '2020-12-26 20:12:04'),
(11, 2, 16, ' ', ' ', ' ', ' ', '2020-12-26 20:12:26', '2020-12-26 20:12:26'),
(12, 14, 17, ' ', ' ', ' ', ' ', '2020-12-26 20:26:48', '2020-12-26 20:26:48'),
(13, 10, 19, ' ', ' ', ' ', ' ', '2021-01-18 16:37:54', '2021-01-18 16:37:54'),
(14, 10, 21, ' ', ' ', ' ', ' ', '2021-02-04 01:21:52', '2021-02-04 01:21:52'),
(15, 11, 24, ' ', ' ', ' ', ' ', '2021-04-14 13:57:32', '2021-04-14 13:57:32'),
(16, 10, 25, ' ', ' ', ' ', ' ', '2021-05-05 11:38:55', '2021-05-05 11:38:55');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_reason`
--

CREATE TABLE `tbl_reason` (
  `OID` bigint(20) NOT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `DateTime` datetime(6) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_reason`
--

INSERT INTO `tbl_reason` (`OID`, `reason`, `DateTime`) VALUES
(1, 'Cold & Flu', NULL),
(2, 'Fever', NULL),
(3, 'Asthama', NULL),
(4, 'Cough', NULL),
(5, 'Vomiting', NULL),
(6, 'Headaches', NULL),
(7, 'Rashes', NULL),
(8, 'UTIs', NULL),
(9, 'Chest Pain', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_relativepatient`
--

CREATE TABLE `tbl_relativepatient` (
  `OID` bigint(20) NOT NULL,
  `PatientID` varchar(50) DEFAULT NULL,
  `RelativeName` varchar(200) DEFAULT ' ',
  `DOB` date DEFAULT NULL,
  `Gender` varchar(50) DEFAULT NULL,
  `Relation` varchar(50) DEFAULT NULL,
  `Mobile` varchar(50) DEFAULT ' ',
  `BloodGroup` varchar(50) DEFAULT NULL,
  `ActiveStatus` tinyint(4) NOT NULL DEFAULT 1,
  `Created_at` date DEFAULT NULL,
  `Updated_at` date DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_relativepatient`
--

INSERT INTO `tbl_relativepatient` (`OID`, `PatientID`, `RelativeName`, `DOB`, `Gender`, `Relation`, `Mobile`, `BloodGroup`, `ActiveStatus`, `Created_at`, `Updated_at`) VALUES
(1, '5', 'ttt', '2020-09-02', 'Male', 'Relative', '01017487026', 'B-', 1, '2020-09-01', '2020-09-01'),
(2, '5', 'fff', '2020-09-02', 'Female', 'Sibling', '01555555555', 'AB+', 1, '2020-09-01', '2020-09-01'),
(3, '1', 'Sha Jahan version 3', NULL, 'Male', 'Choto vai', '420420', NULL, 1, '2020-09-01', '2020-09-01'),
(4, '1', 'Sha Jahan version 3', NULL, 'Male', 'Choto vai', '420420', NULL, 1, '2020-09-01', '2020-09-01'),
(5, '1', 'Sha Jahan version 3', NULL, 'Male', 'Choto vai', '420420', NULL, 1, '2020-09-01', '2020-09-01'),
(6, '3', 'test', '2021-01-30', 'Male', 'Parent', '01767039396', 'B+', 0, '2021-01-30', '2021-03-23'),
(7, '3', 'test', '2021-01-30', 'Male', 'Friend', '12345678901', 'AB+', 0, '2021-01-30', '2021-03-23'),
(8, '3', 'abc', '2021-01-30', 'Male', 'Spouse', '12345678901', 'B+', 0, '2021-01-30', '2021-03-23'),
(9, '3', 'abc', '2021-01-30', 'Male', 'Spouse', '12345678901', 'B+', 0, '2021-01-30', '2021-03-23'),
(10, '3', 'abc', '2021-01-30', 'Male', 'Spouse', '12345678901', 'B+', 0, '2021-01-30', '2021-03-23'),
(11, '3', 'Sagar', '2000-02-01', 'Male', 'Relative', '01701034858', 'B+', 0, '2021-02-01', '2021-03-23'),
(12, '10', 'Z', '1982-02-13', 'Female', 'Relative', '00000000000', 'B+', 0, '2021-02-13', '2021-03-27'),
(13, '10', 'a', '2019-03-03', 'Male', 'Other', '01778620942', 'A+', 0, '2021-03-03', '2021-03-27'),
(14, '10', 'a', '2020-03-04', 'Male', 'Other', '01715597557', 'A+', 0, '2021-03-04', '2021-03-27'),
(15, '27', 'Jannatul Ferdous Riya', '2000-11-17', 'Female', 'Spouse', '01307346087', 'A+', 1, '2021-03-14', '2021-03-14'),
(16, '3', 'Test App', '2021-03-07', NULL, NULL, NULL, NULL, 0, NULL, '2021-03-23'),
(17, '3', 'Mr', '2021-03-23', 'Male', 'Friend', '01701034858', 'B+', 0, '2021-03-23', '2021-03-29'),
(18, '3', 'Golam mostofa', '2021-03-23', 'Male', 'Relative', '01700000000', 'B+', 0, '2021-03-23', '2021-04-08'),
(19, '3', 'Vivek', '2021-03-23', 'Male', 'Relative', '01767039396', 'B+', 1, '2021-03-23', '2021-03-23'),
(20, '3', 'Bilash', '2021-03-23', 'Male', 'Relative', '01767039396', 'B+', 1, '2021-03-23', '2021-03-23'),
(21, '3', 'tes', '2021-03-23', 'Male', 'Spouse', '12589855555', 'B+', 0, '2021-03-23', '2021-03-23'),
(22, '3', 'test2', '2021-03-23', 'Male', 'Parent', '12345678901', 'A+', 0, '2021-03-23', '2021-03-23'),
(23, '3', 'nishat', '2021-03-15', 'Male', 'Parent', '12345678901', 'B+', 0, '2021-03-23', '2021-03-23'),
(24, '70', 'abcd', '2021-03-26', 'Male', 'Parent', '12345678912', 'B+', 1, '2021-03-26', '2021-03-26'),
(25, '3', 'Cm Sagar', '2021-03-26', 'Male', 'Relative', '01234567891', 'B+', 1, '2021-03-26', '2021-03-26'),
(26, '10', 'New', '2021-03-27', 'Male', 'Other', '00000000000', 'A+', 0, '2021-03-27', '2021-03-27'),
(27, '10', 'New 2', '2021-03-27', 'Male', 'Sibling', '12345678911', 'B-', 0, '2021-03-27', '2021-03-27'),
(28, '10', 'New 2', '2021-03-27', 'Male', 'Sibling', '12345678911', 'B-', 0, '2021-03-27', '2021-03-27'),
(29, '10', 'b', '2021-03-27', 'Male', 'Relative', '00000000000', 'AB+', 1, '2021-03-27', '2021-03-27'),
(30, '10', 'a', '2021-03-28', 'Male', 'Relative', '00000000000', 'B-', 1, '2021-03-28', '2021-03-28'),
(31, '11', 'a', '2021-04-14', 'Male', 'Other', '00000000000', 'B+', 1, '2021-04-14', '2021-04-14'),
(32, '10', 'a', '2021-04-17', 'Others', 'Other', '00000000000', NULL, 1, '2021-04-17', '2021-04-17'),
(33, '3', 'Test', '2021-04-19', 'Male', 'Other', '01345854497', NULL, 1, '2021-04-19', '2021-04-19');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sliders`
--

CREATE TABLE `tbl_sliders` (
  `id` int(11) NOT NULL,
  `img` text NOT NULL,
  `fileName` text NOT NULL,
  `edate` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_sliders`
--

INSERT INTO `tbl_sliders` (`id`, `img`, `fileName`, `edate`) VALUES
(1, 'https://app.shasthobd.com/applications/slider/shastho_bd_Banner-wb1.jpg', 'slide1.jpg', '2020-09-14 13:23:24'),
(5, 'https://app.shasthobd.com/applications/slider/shastho_bd_Banner-wb3.jpg', 'shastho_bd_Banner-wb3.jpg', '2021-02-07 00:00:00'),
(4, 'https://app.shasthobd.com/applications/slider/shastho_bd_Banner-wb2.jpg', 'shastho_bd_Banner-wb2.jpg', '2021-02-07 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sms_log`
--

CREATE TABLE `tbl_sms_log` (
  `id` int(111) NOT NULL,
  `response_code_doc` varchar(255) DEFAULT NULL,
  `url_doc` text DEFAULT NULL,
  `response_code_patient` varchar(255) DEFAULT NULL,
  `url_patient` text DEFAULT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp(),
  `updated_at` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_sms_log`
--

INSERT INTO `tbl_sms_log` (`id`, `response_code_doc`, `url_doc`, `response_code_patient`, `url_patient`, `created_at`, `updated_at`) VALUES
(1, NULL, 'SMS SUBMITTED: ID - C20005375ff6d1a748f24', '', '', '2021-01-07', '2021-01-07'),
(2, NULL, 'SMS SUBMITTED: ID - C20005375ff6dbee8384f', NULL, 'SMS SUBMITTED: ID - C20005375ff6dbf0c3d54', '2021-01-07', '2021-01-07'),
(3, NULL, 'SMS SUBMITTED: ID - C20005375ff8aea348269', NULL, 'SMS SUBMITTED: ID - C20005375ff8aea38df06', '2021-01-09', '2021-01-09'),
(4, NULL, 'SMS SUBMITTED: ID - C200053760008ed4ed668', NULL, 'SMS SUBMITTED: ID - C200053760008ed53a97a', '2021-01-15', '2021-01-15'),
(5, NULL, 'SMS SUBMITTED: ID - C200053760029f92ae721', NULL, 'SMS SUBMITTED: ID - C200053760029f9301779', '2021-01-16', '2021-01-16'),
(6, NULL, 'SMS SUBMITTED: ID - C2000537600688443f5cb', NULL, 'SMS SUBMITTED: ID - C200053760068844953e8', '2021-01-19', '2021-01-19'),
(7, NULL, 'SMS SUBMITTED: ID - C20005376006a2a9ead90', NULL, 'SMS SUBMITTED: ID - C20005376006a2aa4f7d1', '2021-01-19', '2021-01-19'),
(8, NULL, 'SMS SUBMITTED: ID - C200053760098b9ebd5ff', NULL, 'SMS SUBMITTED: ID - C200053760098b9f0ca44', '2021-01-21', '2021-01-21'),
(9, NULL, 'SMS SUBMITTED: ID - C200053760113a366a95d', NULL, 'SMS SUBMITTED: ID - C200053760113a36a6434', '2021-01-27', '2021-01-27'),
(10, NULL, 'SMS SUBMITTED: ID - C2000537601169ac8ba65', NULL, 'SMS SUBMITTED: ID - C2000537601169acd3aea', '2021-01-27', '2021-01-27'),
(11, NULL, 'SMS SUBMITTED: ID - C2000537601266f13eddb', NULL, 'SMS SUBMITTED: ID - C2000537601266f17acbf', '2021-01-28', '2021-01-28'),
(12, NULL, 'SMS SUBMITTED: ID - C200053760183abe6757f', NULL, 'SMS SUBMITTED: ID - C200053760183abea8f4f', '2021-02-01', '2021-02-01'),
(13, NULL, 'SMS SUBMITTED: ID - C2000537601841a2a4faa', NULL, 'SMS SUBMITTED: ID - C2000537601841a30d509', '2021-02-02', '2021-02-02'),
(14, NULL, 'SMS SUBMITTED: ID - C200053760218e9c3c281', NULL, 'SMS SUBMITTED: ID - C200053760218e9c7f8c3', '2021-02-09', '2021-02-09'),
(15, NULL, 'SMS SUBMITTED: ID - C20005376021b5cf76624', NULL, 'SMS SUBMITTED: ID - C20005376021b5cfbb663', '2021-02-09', '2021-02-09'),
(16, NULL, 'SMS SUBMITTED: ID - C20005376021b93be5474', NULL, 'SMS SUBMITTED: ID - C20005376021b93c3694d', '2021-02-09', '2021-02-09'),
(17, NULL, 'SMS SUBMITTED: ID - C200053760225731c1a31', NULL, 'SMS SUBMITTED: ID - C2000537602257320fca1', '2021-02-09', '2021-02-09'),
(18, NULL, 'SMS SUBMITTED: ID - C2000537602a33e337f63', NULL, 'SMS SUBMITTED: ID - C2000537602a33e3822ea', '2021-02-15', '2021-02-15'),
(19, NULL, 'SMS SUBMITTED: ID - C2000537602a4baee251b', NULL, 'SMS SUBMITTED: ID - C2000537602a4baf340b0', '2021-02-15', '2021-02-15'),
(20, NULL, 'SMS SUBMITTED: ID - C2000537602a623e62cf9', NULL, 'SMS SUBMITTED: ID - C2000537602a623f2723e', '2021-02-15', '2021-02-15'),
(21, NULL, 'SMS SUBMITTED: ID - C2000537602b963a60e78', NULL, 'SMS SUBMITTED: ID - C2000537602b963aa52b5', '2021-02-16', '2021-02-16'),
(22, NULL, 'SMS SUBMITTED: ID - C2000537602bb244d2b9b', NULL, 'SMS SUBMITTED: ID - C2000537602bb2451f4d8', '2021-02-16', '2021-02-16'),
(23, NULL, 'SMS SUBMITTED: ID - C2000537603116c714797', NULL, 'SMS SUBMITTED: ID - C2000537603116c7738e5', '2021-02-20', '2021-02-20'),
(24, NULL, 'SMS SUBMITTED: ID - C20005376036a3ed786ee', NULL, 'SMS SUBMITTED: ID - C20005376036a3edbf7e4', '2021-02-25', '2021-02-25'),
(25, NULL, 'SMS SUBMITTED: ID - C2000537603a2e2b33d96', NULL, 'SMS SUBMITTED: ID - C2000537603a2e2b71de9', '2021-02-27', '2021-02-27'),
(26, NULL, 'SMS SUBMITTED: ID - C2000537603cc4765983a', NULL, 'SMS SUBMITTED: ID - C2000537603cc4769892e', '2021-03-01', '2021-03-01'),
(27, NULL, 'SMS SUBMITTED: ID - C2000537603e10a2356b8', NULL, 'SMS SUBMITTED: ID - C2000537603e10a2782ea', '2021-03-02', '2021-03-02'),
(28, NULL, 'SMS SUBMITTED: ID - C2000537603f05ad9d88a', NULL, 'SMS SUBMITTED: ID - C2000537603f05addca02', '2021-03-03', '2021-03-03'),
(29, NULL, 'SMS SUBMITTED: ID - C2000537603f093ebb738', NULL, 'SMS SUBMITTED: ID - C2000537603f093f0a9f7', '2021-03-03', '2021-03-03'),
(30, NULL, 'SMS SUBMITTED: ID - C2000537603f65ffef20e', NULL, 'SMS SUBMITTED: ID - C2000537603f660038469', '2021-03-03', '2021-03-03'),
(31, NULL, 'SMS SUBMITTED: ID - C2000537603f6a7d5b975', NULL, 'SMS SUBMITTED: ID - C2000537603f6a7da3a67', '2021-03-03', '2021-03-03'),
(32, NULL, 'SMS SUBMITTED: ID - C2000537603f6f060f76a', NULL, 'SMS SUBMITTED: ID - C2000537603f6f064c754', '2021-03-03', '2021-03-03'),
(33, NULL, 'SMS SUBMITTED: ID - C2000537603f72163536a', NULL, 'SMS SUBMITTED: ID - C2000537603f72167940c', '2021-03-03', '2021-03-03'),
(34, NULL, 'SMS SUBMITTED: ID - C20005376044620498ade', NULL, 'SMS SUBMITTED: ID - C200053760446204e2db5', '2021-03-07', '2021-03-07'),
(35, NULL, 'SMS SUBMITTED: ID - C200053760447a625b9ad', NULL, 'SMS SUBMITTED: ID - C200053760447a62a3ff5', '2021-03-07', '2021-03-07'),
(36, NULL, 'SMS SUBMITTED: ID - C2000537604624ec080dc', NULL, 'SMS SUBMITTED: ID - C2000537604624ec44345', '2021-03-08', '2021-03-08'),
(37, NULL, 'SMS SUBMITTED: ID - C200053760463ae56a2e1', NULL, 'SMS SUBMITTED: ID - C200053760463ae5ad209', '2021-03-08', '2021-03-08'),
(38, NULL, 'SMS SUBMITTED: ID - C200053760475c7c1f3c9', NULL, 'SMS SUBMITTED: ID - C200053760475c7c5c732', '2021-03-09', '2021-03-09'),
(39, NULL, 'SMS SUBMITTED: ID - C200053760476fd7ba72d', NULL, 'SMS SUBMITTED: ID - C200053760476fd809b77', '2021-03-09', '2021-03-09'),
(40, NULL, 'SMS SUBMITTED: ID - C2000537604860f42a3c5', NULL, 'SMS SUBMITTED: ID - C2000537604860f46f38a', '2021-03-10', '2021-03-10'),
(41, NULL, 'SMS SUBMITTED: ID - C2000537604c6476d4282', NULL, 'SMS SUBMITTED: ID - C2000537604c64771bb84', '2021-03-13', '2021-03-13'),
(42, NULL, 'SMS SUBMITTED: ID - C2000537604cc95884175', NULL, 'SMS SUBMITTED: ID - C2000537604cc958c4b90', '2021-03-13', '2021-03-13'),
(43, NULL, 'SMS SUBMITTED: ID - C2000537604e2cd007fcb', NULL, 'SMS SUBMITTED: ID - C2000537604e2cd043d95', '2021-03-14', '2021-03-14'),
(44, NULL, 'SMS SUBMITTED: ID - C20005376051a58c6c441', NULL, 'SMS SUBMITTED: ID - C20005376051a58cae4fd', '2021-03-17', '2021-03-17'),
(45, NULL, 'SMS SUBMITTED: ID - C200053760573128da39a', NULL, 'SMS SUBMITTED: ID - C20005376057312929412', '2021-03-21', '2021-03-21'),
(46, NULL, 'SMS SUBMITTED: ID - C2000537605749dcefc8c', NULL, 'SMS SUBMITTED: ID - C2000537605749dd43931', '2021-03-21', '2021-03-21'),
(47, NULL, 'SMS SUBMITTED: ID - C200053760574d681dc47', NULL, 'SMS SUBMITTED: ID - C200053760574d685b387', '2021-03-21', '2021-03-21'),
(48, NULL, 'SMS SUBMITTED: ID - C2000537605755ade767b', NULL, 'SMS SUBMITTED: ID - C2000537605755ae356f1', '2021-03-21', '2021-03-21'),
(49, NULL, 'SMS SUBMITTED: ID - C2000537605870df86485', NULL, 'SMS SUBMITTED: ID - C2000537605870dfc6a2f', '2021-03-22', '2021-03-22'),
(50, NULL, 'SMS SUBMITTED: ID - C200053760589525b769b', NULL, 'SMS SUBMITTED: ID - C20005376058952611827', '2021-03-22', '2021-03-22'),
(51, NULL, 'SMS SUBMITTED: ID - C20005376058a13587c38', NULL, 'SMS SUBMITTED: ID - C20005376058a135cc62a', '2021-03-22', '2021-03-22'),
(52, NULL, 'SMS SUBMITTED: ID - C20005376058a27a8e11d', NULL, 'SMS SUBMITTED: ID - C20005376058a27ad9302', '2021-03-22', '2021-03-22'),
(53, NULL, 'SMS SUBMITTED: ID - C20005376058acc49c4af', NULL, 'SMS SUBMITTED: ID - C20005376058acc4df5cd', '2021-03-22', '2021-03-22'),
(54, NULL, 'SMS SUBMITTED: ID - C200053760599766c4e56', NULL, 'SMS SUBMITTED: ID - C200053760599767120ff', '2021-03-23', '2021-03-23'),
(55, '1007', '1007', '1007', '1007', '2021-04-10', '2021-04-10'),
(56, '1007', '1007', '1007', '1007', '2021-04-10', '2021-04-10'),
(57, '1007', '1007', '1007', '1007', '2021-04-10', '2021-04-10'),
(58, '1007', '1007', '1007', '1007', '2021-04-10', '2021-04-10'),
(59, NULL, 'SMS SUBMITTED: ID - C20005376071871337246', NULL, 'SMS SUBMITTED: ID - C20005376071871374672', '2021-04-10', '2021-04-10'),
(60, NULL, 'SMS SUBMITTED: ID - C2000537607192e65b82f', NULL, 'SMS SUBMITTED: ID - C2000537607192e65b82f', '2021-04-10', '2021-04-10'),
(61, NULL, 'SMS SUBMITTED: ID - C2000537607192fac53ed', NULL, 'SMS SUBMITTED: ID - C2000537607192fac53ed', '2021-04-10', '2021-04-10'),
(62, NULL, 'SMS SUBMITTED: ID - C20005376072c5b9953f2', NULL, 'SMS SUBMITTED: ID - C20005376072c5b9d6606', '2021-04-11', '2021-04-11'),
(63, NULL, 'SMS SUBMITTED: ID - C20005376072d7fa4411c', NULL, 'SMS SUBMITTED: ID - C20005376072d7fa4411c', '2021-04-11', '2021-04-11'),
(64, NULL, 'SMS SUBMITTED: ID - C20005376072daacaecab', NULL, 'SMS SUBMITTED: ID - C20005376072daacaecab', '2021-04-11', '2021-04-11'),
(65, NULL, 'SMS SUBMITTED: ID - C20005376072dcf4e9bfd', NULL, 'SMS SUBMITTED: ID - C20005376072dcf4e9bfd', '2021-04-11', '2021-04-11'),
(66, NULL, 'SMS SUBMITTED: ID - C20005376072de197d636', NULL, 'SMS SUBMITTED: ID - C20005376072de197d636', '2021-04-11', '2021-04-11'),
(67, NULL, 'SMS SUBMITTED: ID - C20005376072e14009318', NULL, 'SMS SUBMITTED: ID - C20005376072e14009318', '2021-04-11', '2021-04-11'),
(68, NULL, 'SMS SUBMITTED: ID - C20005376072e426c3b84', NULL, 'SMS SUBMITTED: ID - C20005376072e426c3b84', '2021-04-11', '2021-04-11'),
(69, NULL, 'SMS SUBMITTED: ID - C20005376072e5d7e0feb', NULL, 'SMS SUBMITTED: ID - C20005376072e5d7e0feb', '2021-04-11', '2021-04-11'),
(70, NULL, 'SMS SUBMITTED: ID - C200053760730fce86d6d', NULL, 'SMS SUBMITTED: ID - C200053760730fcf17f67', '2021-04-11', '2021-04-11'),
(71, NULL, 'SMS SUBMITTED: ID - C2000537607315476f6e2', NULL, 'SMS SUBMITTED: ID - C2000537607315476f6e2', '2021-04-11', '2021-04-11'),
(72, NULL, 'SMS SUBMITTED: ID - C200053760731c0455264', NULL, 'SMS SUBMITTED: ID - C200053760731c0455264', '2021-04-11', '2021-04-11'),
(73, NULL, 'SMS SUBMITTED: ID - C200053760731c3e8b4d7', NULL, 'SMS SUBMITTED: ID - C200053760731c3e8b4d7', '2021-04-11', '2021-04-11'),
(74, NULL, 'SMS SUBMITTED: ID - C200053760734452d0265', NULL, 'SMS SUBMITTED: ID - C200053760734452d0265', '2021-04-12', '2021-04-12'),
(75, NULL, 'SMS SUBMITTED: ID - C20005376073782f1ff5e', NULL, 'SMS SUBMITTED: ID - C20005376073782f1ff5e', '2021-04-12', '2021-04-12'),
(76, NULL, 'SMS SUBMITTED: ID - C2000537607381f02df5c', NULL, 'SMS SUBMITTED: ID - C2000537607381f02df5c', '2021-04-12', '2021-04-12'),
(77, NULL, 'SMS SUBMITTED: ID - C20005376073dcb5e0503', NULL, 'SMS SUBMITTED: ID - C20005376073dcb5e0503', '2021-04-12', '2021-04-12'),
(78, NULL, 'SMS SUBMITTED: ID - C20005376073ead5b7c20', NULL, 'SMS SUBMITTED: ID - C20005376073ead604a2b', '2021-04-12', '2021-04-12'),
(79, NULL, 'SMS SUBMITTED: ID - C200053760741aa862975', NULL, 'SMS SUBMITTED: ID - C200053760741aa8a0f15', '2021-04-12', '2021-04-12'),
(80, NULL, 'SMS SUBMITTED: ID - C200053760743c77ede0d', NULL, 'SMS SUBMITTED: ID - C200053760743c7840e79', '2021-04-12', '2021-04-12'),
(81, NULL, 'SMS SUBMITTED: ID - C200053760746f90e03b4', NULL, 'SMS SUBMITTED: ID - C200053760746f90e03b4', '2021-04-12', '2021-04-12'),
(82, NULL, 'SMS SUBMITTED: ID - C200053760746fc4479ba', NULL, 'SMS SUBMITTED: ID - C200053760746fc4479ba', '2021-04-12', '2021-04-12'),
(83, NULL, 'SMS SUBMITTED: ID - C20005376074700961d5b', NULL, 'SMS SUBMITTED: ID - C20005376074700961d5b', '2021-04-12', '2021-04-12'),
(84, NULL, 'SMS SUBMITTED: ID - C20005376074702cca4cf', NULL, 'SMS SUBMITTED: ID - C20005376074702cca4cf', '2021-04-12', '2021-04-12'),
(85, NULL, 'SMS SUBMITTED: ID - C200053760760bb610226', NULL, 'SMS SUBMITTED: ID - C200053760760bb610226', '2021-04-14', '2021-04-14'),
(86, NULL, 'SMS SUBMITTED: ID - C20005376076934b0156f', NULL, 'SMS SUBMITTED: ID - C20005376076934b437ef', '2021-04-14', '2021-04-14'),
(87, NULL, 'SMS SUBMITTED: ID - C2000537607a0b0dd4e50', NULL, 'SMS SUBMITTED: ID - C2000537607a0b0dd4e50', '2021-04-17', '2021-04-17'),
(88, NULL, 'SMS SUBMITTED: ID - C2000537607ae2bb3d2e6', NULL, 'SMS SUBMITTED: ID - C2000537607ae2bb3d2e6', '2021-04-17', '2021-04-17'),
(89, NULL, 'SMS SUBMITTED: ID - C2000537607ae38256973', NULL, 'SMS SUBMITTED: ID - C2000537607ae38256973', '2021-04-17', '2021-04-17'),
(90, NULL, 'SMS SUBMITTED: ID - C2000537607ae86d6b4de', NULL, 'SMS SUBMITTED: ID - C2000537607ae86d6b4de', '2021-04-17', '2021-04-17'),
(91, NULL, 'SMS SUBMITTED: ID - C2000537607e784b13b38', NULL, 'SMS SUBMITTED: ID - C2000537607e784b13b38', '2021-04-20', '2021-04-20'),
(92, NULL, 'SMS SUBMITTED: ID - C20005376096f9958a0c9', NULL, 'SMS SUBMITTED: ID - C20005376096f9958a0c9', '2021-05-09', '2021-05-09'),
(93, NULL, 'SMS SUBMITTED: ID - C200053760996d54a62ff', NULL, 'SMS SUBMITTED: ID - C200053760996d54a62ff', '2021-05-10', '2021-05-10'),
(94, NULL, 'SMS SUBMITTED: ID - C2000537609a552bc133e', NULL, 'SMS SUBMITTED: ID - C2000537609a552bc133e', '2021-05-11', '2021-05-11'),
(95, NULL, 'SMS SUBMITTED: ID - C2000537609a557d7b02f', NULL, 'SMS SUBMITTED: ID - C2000537609a557d7b02f', '2021-05-11', '2021-05-11'),
(96, NULL, 'SMS SUBMITTED: ID - C2000537609ac00b2b9e4', NULL, 'SMS SUBMITTED: ID - C2000537609ac00b2b9e4', '2021-05-11', '2021-05-11'),
(97, NULL, 'SMS SUBMITTED: ID - C2000537609ac08a7c035', NULL, 'SMS SUBMITTED: ID - C2000537609ac08a7c035', '2021-05-11', '2021-05-11'),
(98, NULL, 'SMS SUBMITTED: ID - C200053760a1270d38501', NULL, 'SMS SUBMITTED: ID - C200053760a1270d38501', '2021-05-16', '2021-05-16'),
(99, NULL, 'SMS SUBMITTED: ID - C200053760a1e291a5963', NULL, 'SMS SUBMITTED: ID - C200053760a1e291a5963', '2021-05-17', '2021-05-17'),
(100, NULL, 'SMS SUBMITTED: ID - C200053760ab727229479', NULL, 'SMS SUBMITTED: ID - C200053760ab727229479', '2021-05-24', '2021-05-24'),
(101, NULL, 'SMS SUBMITTED: ID - C200053760abacaa208e2', NULL, 'SMS SUBMITTED: ID - C200053760abacaa208e2', '2021-05-24', '2021-05-24'),
(102, NULL, 'SMS SUBMITTED: ID - C200053760b07341a40d4', NULL, 'SMS SUBMITTED: ID - C200053760b07341a40d4', '2021-05-28', '2021-05-28'),
(103, NULL, 'SMS SUBMITTED: ID - C200053760b07341a3c62', NULL, 'SMS SUBMITTED: ID - C200053760b07341a3c62', '2021-05-28', '2021-05-28'),
(104, NULL, 'SMS SUBMITTED: ID - C200053760b07648a0222', NULL, 'SMS SUBMITTED: ID - C200053760b07648a0222', '2021-05-28', '2021-05-28'),
(105, NULL, 'SMS SUBMITTED: ID - C200053760b07685053c0', NULL, 'SMS SUBMITTED: ID - C200053760b07685053c0', '2021-05-28', '2021-05-28'),
(106, NULL, 'SMS SUBMITTED: ID - C200053760b080eb393de', NULL, 'SMS SUBMITTED: ID - C200053760b080eb393de', '2021-05-28', '2021-05-28'),
(107, NULL, 'SMS SUBMITTED: ID - C200053760b8afa262232', NULL, 'SMS SUBMITTED: ID - C200053760b8afa262232', '2021-06-03', '2021-06-03'),
(108, NULL, 'SMS SUBMITTED: ID - C200053760ba80f405c41', NULL, 'SMS SUBMITTED: ID - C200053760ba80f405c41', '2021-06-05', '2021-06-05'),
(109, NULL, 'SMS SUBMITTED: ID - C200053760bc2df0c807d', NULL, 'SMS SUBMITTED: ID - C200053760bc2df0c807d', '2021-06-06', '2021-06-06'),
(110, NULL, 'SMS SUBMITTED: ID - C200053760c2fc1b8075b', NULL, 'SMS SUBMITTED: ID - C200053760c2fc1b8075b', '2021-06-11', '2021-06-11'),
(111, NULL, 'SMS SUBMITTED: ID - C200053760c41ed9e2df8', NULL, 'SMS SUBMITTED: ID - C200053760c41ed9e2df8', '2021-06-12', '2021-06-12');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_specialist`
--

CREATE TABLE `tbl_specialist` (
  `OID` bigint(20) NOT NULL,
  `Specialization` varchar(200) DEFAULT NULL,
  `ImagePath` varchar(200) DEFAULT NULL,
  `Active` int(111) NOT NULL DEFAULT 1,
  `Updated_by` varchar(255) DEFAULT NULL,
  `Updated_at` date DEFAULT NULL,
  `Created_at` date DEFAULT NULL,
  `ordering` int(111) NOT NULL DEFAULT 1,
  `Added_by` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_specialist`
--

INSERT INTO `tbl_specialist` (`OID`, `Specialization`, `ImagePath`, `Active`, `Updated_by`, `Updated_at`, `Created_at`, `ordering`, `Added_by`) VALUES
(1, 'Medicine/Internal Medicine/Chest Specialist', 'https://app.shasthobd.com/applications/appImg/60731cdfee1461618156767Medicine.png', 1, NULL, NULL, NULL, 5, NULL),
(2, 'Gynecologist', 'https://app.shasthobd.com/applications/appImg/60731cb2d6e5c1618156722Gynecologist.png', 1, NULL, NULL, NULL, 4, NULL),
(3, 'Child Specialist/Pdiatrician', 'https://app.shasthobd.com/applications/appImg/60731d27204851618156839childspecialist.png', 1, NULL, NULL, NULL, 2, NULL),
(4, 'Cardiologist', 'https://app.shasthobd.com/applications/appImg/60731cc67b6b21618156742cardiologist.png', 1, NULL, NULL, NULL, 1, NULL),
(5, 'Pulmonary Medicine Specialist', 'https://app.shasthobd.com/applications/appImg/60731d4d875571618156877Pulmonarymedicinespecialist.png', 1, NULL, NULL, NULL, 6, NULL),
(6, 'Diabetologist/Endocrinologist', 'https://app.shasthobd.com/applications/appImg/60731d141a86c1618156820diabetologist.png', 1, NULL, NULL, NULL, 3, NULL),
(7, 'Skin Specialist & Sexologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(8, 'Neurologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(9, 'GastroEnterologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(10, 'Breast Cancer Specialist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(11, 'Oncologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(12, 'General Surgery', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(13, 'Colorectal Surgery', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(14, 'Urologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(15, 'Orthopedist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(16, 'Dentist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(17, 'Vascular Surgery', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(18, 'ENT Specialist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(19, 'Psychiatrist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(20, 'Eye Specialist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(21, 'Hematologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(22, 'Rheumatologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(23, 'Palliative Medicine', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(24, 'Nephrologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(25, 'Physical Medicine / Pain / Paralysis', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(26, 'Sports Injury', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(27, 'Pain Medicine', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 0, NULL, NULL, NULL, 10, NULL),
(28, 'Hepatologist', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(31, 'Family Medicine', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(30, 'Female Surgeons (General, Breast, Colorectal, Plastic, Cosmetic  Surgery)', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL),
(32, 'Oncoplastic Surgery', 'https://app.shasthobd.com/applications/appImg/606ebc014c0881617869825special_category.png', 1, NULL, NULL, NULL, 10, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sub_menu`
--

CREATE TABLE `tbl_sub_menu` (
  `sub_menu_id` int(111) NOT NULL,
  `menu_id` int(111) NOT NULL,
  `sub_menu_name` varchar(255) DEFAULT NULL,
  `page_url` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `notification` int(111) NOT NULL DEFAULT 0,
  `ordering` int(111) NOT NULL DEFAULT 1,
  `added_by` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_sub_menu`
--

INSERT INTO `tbl_sub_menu` (`sub_menu_id`, `menu_id`, `sub_menu_name`, `page_url`, `status`, `notification`, `ordering`, `added_by`, `user_id`, `edate`) VALUES
(1, 1, 'Add User', 'add_user.php', 1, 0, 1, 'das', NULL, '2020-07-14 17:00:00'),
(2, 2, 'Add Doctor', 'add_doctor.php', 1, 0, 1, '', NULL, '2020-07-14 11:00:00'),
(4, 1, 'Add Role Permission', 'add_role_permission.php', 1, 0, 1, 'das', NULL, '2020-07-15 00:00:00'),
(13, 2, 'Add Specialist', 'add_special.php', 1, 0, 1, 'das', 1, '2020-09-13 00:00:00'),
(14, 4, 'Doctor List (Active)', 'doctors.php?status=1', 1, 0, 1, 'das', 1, '2020-09-13 00:00:00'),
(15, 6, 'Send Notification To All', 'push_to_all.php', 1, 0, 1, 'das', 1, '2020-10-20 00:00:00'),
(16, 4, 'Patient List', 'patients.php', 1, 0, 2, 'das', 1, '2021-01-02 00:00:00'),
(17, 4, 'Appointment List', 'appointment_list.php', 1, 1, 3, 'das', 1, '2021-01-02 00:00:00'),
(18, 4, 'Invoice List', 'invoice_list.php', 1, 1, 4, 'das', 1, '2021-01-02 00:00:00'),
(19, 3, 'Add menu', 'add_menu.php', 1, 0, 1, 'das', 1, '2021-01-19 00:00:00'),
(20, 3, 'Add Sub Menu', 'add_sub_menu.php', 1, 0, 2, 'das', NULL, '2021-01-19 00:00:00'),
(21, 2, 'Add Other Profession', 'add_other_pf.php', 1, 1, 1, 'SasthoBD ', 1, '2021-01-19 23:42:02'),
(22, 4, 'Specialist (Active)', 'speciality.php?status=1', 1, 1, 5, 'SasthoBD ', 1, '2021-01-19 23:42:22'),
(23, 4, 'Other Professional (Active)', 'other_professional.php?status=1', 1, 1, 6, 'SasthoBD ', 1, '2021-01-19 23:42:35'),
(24, 7, 'Doctor List (In-Active)', 'doctors.php?status=0', 1, 1, 1, 'SasthoBD ', 1, '2021-01-19 23:42:47'),
(25, 7, 'Specialist (In-Active)', 'speciality.php?status=0', 1, 1, 2, 'SasthoBD ', 1, '2021-01-19 23:43:02'),
(26, 7, 'Other Professional (In-Active)', 'other_professional.php?status=0', 1, 1, 3, 'SasthoBD ', 1, '2021-01-19 23:43:21'),
(27, 2, 'Add Coupon', 'add_coupon.php', 1, 1, 1, 'SasthoBD ', 1, '2021-03-29 16:46:12');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_times`
--

CREATE TABLE `tbl_times` (
  `id` int(11) NOT NULL,
  `time` varchar(255) NOT NULL,
  `12hr_time` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_times`
--

INSERT INTO `tbl_times` (`id`, `time`, `12hr_time`) VALUES
(46, '09:30:00', '09:30AM'),
(2, '00:30:00', '00:30AM'),
(3, '01:00:00', '01:00AM'),
(4, '01:30:00', '01:30AM'),
(5, '02:00:00', '02:00AM'),
(6, '02:30:00', '02:30AM'),
(7, '03:00:00', '03:00AM'),
(8, '03:30:00', '03:30AM'),
(9, '04:00:00', '04:00AM'),
(10, '05:00:00', '05:00AM'),
(11, '05:30:00', '05:30AM'),
(12, '06:00:00', '06:00AM'),
(13, '06:30:00', '06:30AM'),
(14, '07:00:00', '07:00AM'),
(15, '07:30:00', '07:30AM'),
(16, '08:00:00', '08:00AM'),
(17, '08:30:00', '08:30AM'),
(18, '09:00:00', '09:00AM'),
(19, '10:00:00', '10:00AM'),
(20, '11:00:00', '11:00AM'),
(21, '11:30:00', '11:30AM'),
(22, '24:00:00', '12:00PM'),
(23, '12:30:00', '12:30PM'),
(24, '13:00:00', '01:00PM'),
(25, '13:30:00', '01:30PM'),
(26, '14:00:00', '02:00PM'),
(27, '14:30:00', '02:30PM'),
(28, '15:00:00', '03:00PM'),
(29, '15:30:00', '03:30PM'),
(30, '16:00:00', '04:00PM'),
(31, '16:30:00', '04:30PM'),
(32, '17:00:00', '05:00PM'),
(33, '17:30:00', '05:30PM'),
(34, '18:00:00', '06:00PM'),
(35, '18:30:00', '06:30PM'),
(36, '19:00:00', '07:00PM'),
(37, '19:30:00', '07:30PM'),
(38, '20:00:00', '08:00PM'),
(39, '20:30:00', '08:30PM'),
(40, '21:30:00', '09:30PM'),
(41, '22:00:00', '10:00PM'),
(42, '22:30:00', '10:30PM'),
(43, '23:00:00', '11:00PM'),
(44, '23:30:00', '11:30PM'),
(45, '12:00:00', '12:00:AM'),
(47, '10:30:00', '10:30AM'),
(48, '04:30:00', '04:30AM'),
(49, '21:00:00', '09:00PM');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_time_gaps`
--

CREATE TABLE `tbl_time_gaps` (
  `id` int(111) NOT NULL,
  `gap` int(111) NOT NULL,
  `status` int(111) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_time_gaps`
--

INSERT INTO `tbl_time_gaps` (`id`, `gap`, `status`) VALUES
(1, 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transactions`
--

CREATE TABLE `tbl_transactions` (
  `id` int(111) NOT NULL,
  `txn_id` varchar(300) NOT NULL,
  `txn_id_app` varchar(255) DEFAULT NULL,
  `txn_patientID` int(111) NOT NULL DEFAULT 0,
  `txn_doctorID` int(111) NOT NULL DEFAULT 0,
  `txn_status` varchar(255) NOT NULL DEFAULT ' ',
  `txn_date` datetime NOT NULL DEFAULT current_timestamp(),
  `txn_amount` varchar(255) NOT NULL DEFAULT ' ',
  `txn_bankTranId` varchar(255) NOT NULL DEFAULT ' ',
  `txn_cardType` varchar(255) NOT NULL DEFAULT ' ',
  `txn_cardNo` varchar(255) NOT NULL DEFAULT '  ',
  `txn_currencyType` varchar(255) NOT NULL DEFAULT ' ',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_transactions`
--

INSERT INTO `tbl_transactions` (`id`, `txn_id`, `txn_id_app`, `txn_patientID`, `txn_doctorID`, `txn_status`, `txn_date`, `txn_amount`, `txn_bankTranId`, `txn_cardType`, `txn_cardNo`, `txn_currencyType`, `created_at`, `updated_at`) VALUES
(1, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '10', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 13:05:56', '2020-10-04 13:05:56'),
(2, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 13:23:55', '2020-10-04 13:23:55'),
(3, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 13:36:18', '2020-10-04 13:36:18'),
(4, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 13:37:26', '2020-10-04 13:37:26'),
(5, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 18:17:19', '2020-10-04 18:17:19'),
(6, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 18:17:36', '2020-10-04 18:17:36'),
(7, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 18:18:02', '2020-10-04 18:18:02'),
(8, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 18:19:33', '2020-10-04 18:19:33'),
(9, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 18:20:05', '2020-10-04 18:20:05'),
(10, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-04 18:41:56', '2020-10-04 18:41:56'),
(11, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-07 23:20:53', '2020-10-07 23:20:53'),
(12, '213wqdqwe312e1', NULL, 3, 0, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-07 23:48:08', '2020-10-07 23:48:08'),
(13, '213wqdqwe312e1', NULL, 3, 14, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-08 01:35:38', '2020-10-08 01:35:38'),
(14, '213wqdqwe312e1', NULL, 3, 14, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-08 01:37:49', '2020-10-08 01:37:49'),
(15, '213wqdqwe312e1', NULL, 3, 1, 'valid', '2020-10-04 00:00:00', '90', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-08 20:31:31', '2020-10-08 20:31:31'),
(16, '789087666698765', NULL, 5, 20, 'VALID', '2020-10-09 10:08:49', '9.80', 'BGW70442020100929638', 'BKASH-BKash', 'KX7J966AT132', 'BDT', '2020-10-09 10:10:58', '2020-10-09 10:10:58'),
(17, '789087666698765', NULL, 5, 20, 'VALID', '2020-10-09 10:19:04', '9.80', 'BGW30022020100930893', 'BKASH-BKash', 'KX7J936B13JD', 'BDT', '2020-10-09 10:20:42', '2020-10-09 10:20:42'),
(18, '789087666698765', NULL, 14, 20, 'VALID', '2020-10-09 23:15:24', '9.80', 'BGW667920201009129910', 'BKASH-BKash', 'KX7J946RM4EG', 'BDT', '2020-10-09 23:16:18', '2020-10-09 23:16:18'),
(19, '789087666698765', NULL, 3, 20, 'VALID', '2020-10-09 23:52:41', '9.80', 'BGW633020201009134578', 'BKASH-BKash', 'KX7J946RWOAA', 'BDT', '2020-10-09 23:53:31', '2020-10-09 23:53:31'),
(20, '789087666698765', NULL, 15, 8, 'VALID', '2020-10-10 15:43:06', '9.80', 'BGW82722020101068833', 'BKASH-BKash', 'KX7JA071QFFG', 'BDT', '2020-10-10 15:43:58', '2020-10-10 15:43:58'),
(21, 'txn234554321', NULL, 15, 8, 'valid', '2020-10-10 00:00:00', '10', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-10 16:04:13', '2020-10-10 16:04:13'),
(22, 'txn234554321', NULL, 15, 8, 'valid', '2020-10-10 00:00:00', '10', 'txbhsyvjasydufavjav', 'Bkash', 'N/A', 'BDT', '2020-10-10 16:04:29', '2020-10-10 16:04:29'),
(23, '789087666698765', NULL, 16, 8, 'VALID', '2020-10-10 16:25:46', '9.80', 'BGW73522020101073602', 'BKASH-BKash', 'KX7JA872JHQM', 'BDT', '2020-10-10 16:27:04', '2020-10-10 16:27:04'),
(24, '789087666698765', NULL, 16, 8, 'VALID', '2020-10-10 16:35:24', '9.80', 'BGW98052020101074449', 'BKASH-BKash', 'KX7JA872Q03U', 'BDT', '2020-10-10 16:37:00', '2020-10-10 16:37:00'),
(25, '789087666698765', NULL, 5, 19, 'VALID', '2020-10-10 21:37:15', '9.80', 'FrK6jiuXDGZCi4z1KOuiBmCb4Jo=', 'DBBLMOBILEB-Dutch Bangla', '999999XXXXXX6723', 'BDT', '2020-10-10 21:38:46', '2020-10-10 21:38:46'),
(26, '789087666698765', NULL, 5, 19, 'VALID', '2020-10-10 21:42:28', '9.80', 'Xa5OxeLVUt26Bu195UcpStZ6Wcw=', 'DBBLMOBILEB-Dutch Bangla', '999999XXXXXX6723', 'BDT', '2020-10-10 21:44:18', '2020-10-10 21:44:18'),
(27, '789087666698765', NULL, 3, 8, 'VALID', '2020-10-11 00:26:55', '9.80', 'BGW51322020101103770', 'BKASH-BKash', 'KX7JB97DBMKL', 'BDT', '2020-10-11 00:27:51', '2020-10-11 00:27:51'),
(28, '789087666698765', NULL, 3, 8, 'VALID', '2020-10-11 00:30:37', '9.80', 'BGW57412020101104128', 'BKASH-BKash', 'KX7JB87DC48Y', 'BDT', '2020-10-11 00:31:14', '2020-10-11 00:31:14'),
(29, '789087666698765', NULL, 3, 8, 'VALID', '2020-10-11 00:50:00', '9.80', 'BGW25932020101105712', 'BKASH-BKash', 'KX7JB37DF607', 'BDT', '2020-10-11 00:50:41', '2020-10-11 00:50:41'),
(30, '789087666698765', NULL, 17, 8, 'VALID', '2020-10-11 01:45:46', '9.80', 'BGW29052020101108856', 'BKASH-BKash', 'KX7JB57DKM6H', 'BDT', '2020-10-11 01:46:26', '2020-10-11 01:46:26'),
(31, 'BGW36952020101161269', NULL, 18, 8, 'VALID', '2020-10-11 13:49:06', '9.80', 'BGW36952020101161269', 'BKASH-BKash', 'KX7JB67LU6W0', 'BDT', '2020-10-11 07:48:53', '2020-10-11 07:48:53'),
(32, 'BGW10492020101161374', NULL, 14, 20, 'VALID', '2020-10-11 13:49:48', '9.80', 'BGW10492020101161374', 'BKASH-BKash', 'KX7JB57LUQQ5', 'BDT', '2020-10-11 07:49:43', '2020-10-11 07:49:43'),
(33, 'BGW62612020101356158', NULL, 10, 1, 'VALID', '2020-10-13 14:01:27', '9.80', 'BGW62612020101356158', 'BKASH-BKash', 'KX7JD98UZIZ3', 'BDT', '2020-10-13 14:02:55', '2020-10-13 14:02:55'),
(34, 'BGW26012020101450652', NULL, 11, 1, 'VALID', '2020-10-14 13:15:21', '9.80', 'BGW26012020101450652', 'BKASH-BKash', 'KX7JE69GCNQK', 'BDT', '2020-10-14 13:17:13', '2020-10-14 13:17:13'),
(35, 'BGW71832020101465140', NULL, 10, 36, 'VALID', '2020-10-14 15:16:55', '9.80', 'BGW71832020101465140', 'BKASH-BKash', 'KX7JE39IHZCR', 'BDT', '2020-10-14 15:19:23', '2020-10-14 15:19:23'),
(36, 'BGW87212020101467162', NULL, 20, 36, 'VALID', '2020-10-14 15:33:38', '9.80', 'BGW87212020101467162', 'BKASH-BKash', 'KX7JE39ISZY9', 'BDT', '2020-10-14 15:37:00', '2020-10-14 15:37:00'),
(37, 'BGW79692020101471833', NULL, 14, 20, 'VALID', '2020-10-14 16:14:34', '9.80', 'BGW79692020101471833', 'BKASH-BKash', 'KX7JE09JJ1K2', 'BDT', '2020-10-14 16:15:37', '2020-10-14 16:15:37'),
(38, 'BGW17312020101482024', NULL, 9, 36, 'VALID', '2020-10-14 17:43:38', '9.80', 'BGW17312020101482024', 'BKASH-BKash', 'KX7JE59LQ4WX', 'BDT', '2020-10-14 17:44:43', '2020-10-14 17:44:43'),
(39, 'BGW28002020101802809', NULL, 14, 8, 'VALID', '2020-10-18 00:27:59', '9.80', 'BGW28002020101802809', 'BKASH-BKash', 'KX7JI7BMD1EV', 'BDT', '2020-10-18 00:28:48', '2020-10-18 00:28:48'),
(40, 'BGW361920201022124884', NULL, 19, 36, 'VALID', '2020-10-22 21:20:33', '9.80', 'BGW361920201022124884', 'BKASH-BKash', 'KX7JM8EL3BT0', 'BDT', '2020-10-22 21:22:27', '2020-10-22 21:22:27'),
(41, 'BGW62882020110901343', NULL, 10, 38, 'VALID', '2020-11-09 00:14:09', '9.80', 'BGW62882020110901343', 'BKASH-BKash', 'KX7K99OJAG6T', 'BDT', '2020-11-09 00:15:04', '2020-11-09 00:15:04'),
(42, 'BGW64842020121103856', NULL, 19, 38, 'VALID', '2020-12-11 01:31:16', '9.80', 'BGW64842020121103856', 'BKASH-BKash', 'KX7LB4ALG9AI', 'BDT', '2020-12-11 01:33:23', '2020-12-11 01:33:23'),
(43, 'BGW89072020121741868', NULL, 17, 36, 'VALID', '2020-12-17 16:35:14', '9.80', 'BGW89072020121741868', 'BKASH-BKash', 'KX7LH2EMDEXG', 'BDT', '2020-12-17 16:36:13', '2020-12-17 16:36:13'),
(44, 'BGW36832020121751436', NULL, 3, 39, 'VALID', '2020-12-17 18:39:40', '9.80', 'BGW36832020121751436', 'BKASH-BKash', 'KX7LH6EQAECU', 'BDT', '2020-12-17 18:40:56', '2020-12-17 18:40:56'),
(45, 'BGW77952020121810833', NULL, 30, 23, 'VALID', '2020-12-18 09:43:13', '735.00', 'BGW77952020121810833', 'BKASH-BKash', 'KX7LI9EZE0RT', 'BDT', '2020-12-18 09:45:01', '2020-12-18 09:45:01'),
(46, 'NG36802020123051356', NULL, 11, 41, 'VALID', '2020-12-30 16:49:18', '9.80', 'NG36802020123051356', 'NAGAD-Nagad', 'N018****7744', 'BDT', '2020-12-30 16:52:43', '2020-12-30 16:52:43'),
(47, 'BGW67022020123057903', NULL, 11, 41, 'VALID', '2020-12-30 18:01:41', '9.80', 'BGW67022020123057903', 'BKASH-BKash', 'KX7LU7MJXJ09', 'BDT', '2020-12-30 18:02:54', '2020-12-30 18:02:54'),
(48, 'BGW38392021010330175', NULL, 11, 41, 'VALID', '2021-01-03 13:11:29', '9.80', 'BGW38392021010330175', 'BKASH-BKash', 'KX8A30OY9JHC', 'BDT', '2021-01-03 13:11:20', '2021-01-03 13:11:20'),
(49, 'NG65182021010734014', NULL, 3, 42, 'VALID', '2021-01-07 14:01:23', '14.70', 'NG65182021010734014', 'NAGAD-Nagad', 'N015****6045', 'BDT', '2021-01-07 14:02:11', '2021-01-07 14:02:11'),
(50, 'NG32042021010739065', NULL, 3, 42, 'VALID', '2021-01-07 15:06:36', '14.70', 'NG32042021010739065', 'NAGAD-Nagad', 'N015****6045', 'BDT', '2021-01-07 15:07:40', '2021-01-07 15:07:40'),
(51, 'NG56232021010902709', NULL, 10, 41, 'VALID', '2021-01-09 01:11:21', '14.70', 'NG56232021010902709', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-01-09 01:12:35', '2021-01-09 01:12:35'),
(52, 'NG87462021011501893', NULL, 3, 41, 'VALID', '2021-01-15 00:34:13', '14.70', 'NG87462021011501893', 'NAGAD-Nagad', 'N015****6045', 'BDT', '2021-01-15 00:35:00', '2021-01-15 00:35:00'),
(53, 'BGT72932021011635694', NULL, 11, 41, 'VALID', '2021-01-16 13:45:51', '14.70', 'BGT72932021011635694', 'BKASH-BKash', 'KX8AG1X2FFY7', 'BDT', '2021-01-16 13:47:18', '2021-01-16 13:47:18'),
(54, 'BGT46302021011637640', NULL, 11, 41, 'VALID', '2021-01-16 14:09:50', '11.76', 'BGT46302021011637640', 'BKASH-BKash', 'KX8AG8004KNG', 'BDT', '2021-01-16 14:10:58', '2021-01-16 14:10:58'),
(55, 'BGT45742021011930898', NULL, 11, 41, 'VALID', '2021-01-19 13:19:30', '11.76', 'BGT45742021011930898', 'BKASH-BKash', 'KX8AJ91TIOFR', 'BDT', '2021-01-19 13:20:35', '2021-01-19 13:20:35'),
(56, 'BGT56862021011938760', NULL, 11, 41, 'VALID', '2021-01-19 15:12:13', '11.76', 'BGT56862021011938760', 'BKASH-BKash', 'KX8AJ51VRN3F', 'BDT', '2021-01-19 15:13:13', '2021-01-19 15:13:13'),
(57, 'NG37132021012171040', NULL, 3, 41, 'VALID', '2021-01-21 20:11:08', '14.70', 'NG37132021012171040', 'NAGAD-Nagad', 'N015****6045', 'BDT', '2021-01-21 20:11:42', '2021-01-21 20:11:42'),
(58, 'NG37212021012749761', NULL, 10, 41, 'VALID', '2021-01-27 16:01:34', '14.70', 'NG37212021012749761', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-01-27 16:02:30', '2021-01-27 16:02:30'),
(59, 'BGT79172021012769546', NULL, 11, 41, 'VALID', '2021-01-27 19:23:59', '14.70', 'BGT79172021012769546', 'BKASH-BKash', 'KX8AR96VT3CX', 'BDT', '2021-01-27 19:25:00', '2021-01-27 19:25:00'),
(60, 'NG27862021012832978', NULL, 10, 41, 'VALID', '2021-01-28 13:24:51', '11.76', 'NG27862021012832978', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-01-28 13:25:37', '2021-01-28 13:25:37'),
(61, 'BGT12812021020191071', NULL, 3, 42, 'VALID', '2021-02-01 23:29:37', '9.80', 'BGT12812021020191071', 'BKASH-BKash', 'KX8B189WYI1O', 'BDT', '2021-02-01 23:30:37', '2021-02-01 23:30:37'),
(62, 'BGT72362021020192934', NULL, 3, 42, 'VALID', '2021-02-01 23:59:13', '9.80', 'BGT72362021020192934', 'BKASH-BKash', 'KX8B169X5D42', 'BDT', '2021-02-02 00:00:01', '2021-02-02 00:00:01'),
(63, 'NG48302021020904789', NULL, 10, 41, 'VALID', '2021-02-09 01:18:05', '14.70', 'NG48302021020904789', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-09 01:18:52', '2021-02-09 01:18:52'),
(64, 'NG92162021020907540', NULL, 10, 41, 'VALID', '2021-02-09 04:05:29', '11.76', 'NG92162021020907540', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-09 04:06:07', '2021-02-09 04:06:07'),
(65, 'NG69202021020907637', NULL, 10, 41, 'VALID', '2021-02-09 04:19:25', '11.76', 'NG69202021020907637', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-09 04:20:43', '2021-02-09 04:20:43'),
(66, 'NG28092021020950903', NULL, 10, 41, 'VALID', '2021-02-09 15:34:07', '11.76', 'NG28092021020950903', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-09 15:34:41', '2021-02-09 15:34:41'),
(67, 'BGT53852021021544690', NULL, 3, 42, 'VALID', '2021-02-15 14:41:03', '9.80', 'BGT53852021021544690', 'BKASH-BKash', 'KX8BF5II34MP', 'BDT', '2021-02-15 14:42:11', '2021-02-15 14:42:11'),
(68, 'BGT31252021021553586', NULL, 3, 42, 'VALID', '2021-02-15 16:22:47', '9.80', 'BGT31252021021553586', 'BKASH-BKash', 'KX8BF5IK4FOT', 'BDT', '2021-02-15 16:23:42', '2021-02-15 16:23:42'),
(69, 'NG34152021021562142', NULL, 10, 41, 'VALID', '2021-02-15 17:58:39', '14.70', 'NG34152021021562142', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-15 17:59:53', '2021-02-15 17:59:53'),
(70, 'NG18952021021648386', NULL, 10, 41, 'VALID', '2021-02-16 15:53:19', '11.76', 'NG18952021021648386', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-16 15:54:02', '2021-02-16 15:54:02'),
(71, 'BGT28252021021658053', NULL, 11, 41, 'VALID', '2021-02-16 17:52:16', '14.70', 'BGT28252021021658053', 'BKASH-BKash', 'KX8BG7JA31E5', 'BDT', '2021-02-16 17:53:41', '2021-02-16 17:53:41'),
(72, 'NG38382021022085028', NULL, 10, 41, 'VALID', '2021-02-20 20:03:11', '14.70', 'NG38382021022085028', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-20 20:03:50', '2021-02-20 20:03:50'),
(73, 'NG20422021022504008', NULL, 41, 41, 'VALID', '2021-02-25 01:06:37', '14.70', 'NG20422021022504008', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-02-25 01:07:23', '2021-02-25 01:07:23'),
(74, 'BGT69142021022767433', NULL, 11, 41, 'VALID', '2021-02-27 17:33:08', '14.70', 'BGT69142021022767433', 'BKASH-BKash', 'KX8BR6Q7QFAC', 'BDT', '2021-02-27 17:34:03', '2021-02-27 17:34:03'),
(75, 'NG25732021030162264', NULL, 51, 41, 'VALID', '2021-03-01 16:37:47', '14.70', 'NG25732021030162264', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-01 16:39:50', '2021-03-01 16:39:50'),
(76, 'NG59192021030256407', NULL, 51, 41, 'VALID', '2021-03-02 16:14:47', '11.76', 'NG59192021030256407', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-02 16:17:05', '2021-03-02 16:17:05'),
(77, 'NG24752021030322142', NULL, 10, 41, 'VALID', '2021-03-03 09:41:50', '14.70', 'NG24752021030322142', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-03-03 09:42:37', '2021-03-03 09:42:37'),
(78, 'NG22332021030323611', NULL, 10, 41, 'VALID', '2021-03-03 09:57:16', '11.76', 'NG22332021030323611', 'NAGAD-Nagad', 'N017****0942', 'BDT', '2021-03-03 09:57:50', '2021-03-03 09:57:50'),
(79, 'NG75772021030363891', NULL, 51, 59, 'VALID', '2021-03-03 16:31:55', '11.76', 'NG75772021030363891', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-03 16:33:35', '2021-03-03 16:33:35'),
(80, 'NG77942021030365677', NULL, 51, 59, 'VALID', '2021-03-03 16:51:18', '9.80', 'NG77942021030365677', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-03 16:52:45', '2021-03-03 16:52:45'),
(81, 'BGT75532021030367443', NULL, 10, 59, 'VALID', '2021-03-03 17:11:00', '11.76', 'BGT75532021030367443', 'BKASH-BKash', 'KX8C30T425CI', 'BDT', '2021-03-03 17:12:05', '2021-03-03 17:12:05'),
(82, 'BGT97112021030368679', NULL, 11, 59, 'VALID', '2021-03-03 17:24:11', '11.76', 'BGT97112021030368679', 'BKASH-BKash', 'KX8C33T4GRH5', 'BDT', '2021-03-03 17:25:10', '2021-03-03 17:25:10'),
(83, 'NG63412021030699783', NULL, 51, 70, 'VALID', '2021-03-06 20:49:25', '11.76', 'NG63412021030699783', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-06 20:50:51', '2021-03-06 20:50:51'),
(84, 'NG479120210306104612', NULL, 51, 63, 'VALID', '2021-03-06 21:26:01', '11.76', 'NG479120210306104612', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-06 21:27:37', '2021-03-06 21:27:37'),
(85, 'NG51332021030727948', NULL, 51, 40, 'VALID', '2021-03-07 11:16:37', '11.76', 'NG51332021030727948', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-07 11:17:56', '2021-03-07 11:17:56'),
(86, 'NG85282021030728808', NULL, 51, 40, 'VALID', '2021-03-07 11:23:18', '11.76', 'NG85282021030728808', 'NAGAD-Nagad', 'N017****9772', 'BDT', '2021-03-07 11:24:31', '2021-03-07 11:24:31'),
(87, 'BGT91372021030741136', NULL, 51, 26, 'VALID', '2021-03-07 13:00:26', '11.76', 'BGT91372021030741136', 'BKASH-BKash', 'KX8C74VSMNHS', 'BDT', '2021-03-07 13:01:54', '2021-03-07 13:01:54'),
(88, 'BGT77632021030886565', NULL, 51, 53, 'VALID', '2021-03-08 19:18:14', '11.76', 'BGT77632021030886565', 'BKASH-BKash', 'KX8C89WX3AMJ', 'BDT', '2021-03-08 19:21:47', '2021-03-08 19:21:47'),
(89, 'BGT34512021030899920', NULL, 51, 7, 'VALID', '2021-03-08 20:54:06', '11.76', 'BGT34512021030899920', 'BKASH-BKash', 'KX8C81X15IN1', 'BDT', '2021-03-08 20:55:33', '2021-03-08 20:55:33'),
(90, 'BGT18622021030976607', NULL, 51, 51, 'VALID', '2021-03-09 17:28:33', '11.76', 'BGT18622021030976607', 'BKASH-BKash', 'KX8C990JVHOX', 'BDT', '2021-03-09 17:31:07', '2021-03-09 17:31:07'),
(91, 'BGT55332021030988986', NULL, 51, 45, 'VALID', '2021-03-09 18:52:19', '11.76', 'BGT55332021030988986', 'BKASH-BKash', 'KX8C980MWVSU', 'BDT', '2021-03-09 18:53:43', '2021-03-09 18:53:43'),
(92, 'BGT64412021031052376', NULL, 51, 46, 'VALID', '2021-03-10 12:01:12', '11.76', 'BGT64412021031052376', 'BKASH-BKash', 'KX8CA113Q96L', 'BDT', '2021-03-10 12:02:27', '2021-03-10 12:02:27'),
(93, 'BGT31622021031353735', NULL, 51, 68, 'VALID', '2021-03-13 13:04:55', '11.76', 'BGT31622021031353735', 'BKASH-BKash', 'KX8CD03CIPFC', 'BDT', '2021-03-13 13:06:30', '2021-03-13 13:06:30'),
(94, 'BGT121720210313108055', NULL, 51, 44, 'VALID', '2021-03-13 20:15:37', '11.76', 'BGT121720210313108055', 'BKASH-BKash', 'KX8CD03M2S0U', 'BDT', '2021-03-13 20:16:56', '2021-03-13 20:16:56'),
(95, 'BGT258620210314100530', NULL, 27, 1, 'VALID', '2021-03-14 21:32:46', '9.80', 'BGT258620210314100530', 'BKASH-BKash', 'KX8CE14GMLSF', 'BDT', '2021-03-14 21:33:35', '2021-03-14 21:33:35'),
(96, 'BGT61452021031741254', NULL, 51, 43, 'VALID', '2021-03-17 12:44:23', '11.76', 'BGT61452021031741254', 'BKASH-BKash', 'KX8CH66AVH02', 'BDT', '2021-03-17 12:45:32', '2021-03-17 12:45:32'),
(97, 'BGT47472021032176658', NULL, 51, 55, 'VALID', '2021-03-21 17:41:15', '11.76', 'BGT47472021032176658', 'BKASH-BKash', 'KX8CL099VQI2', 'BDT', '2021-03-21 17:42:32', '2021-03-21 17:42:32'),
(98, 'BGT43552021032190385', NULL, 51, 59, 'VALID', '2021-03-21 19:26:18', '11.76', 'BGT43552021032190385', 'BKASH-BKash', 'KX8CL49DW1I6', 'BDT', '2021-03-21 19:27:56', '2021-03-21 19:27:56'),
(99, 'BGT57582021032192604', NULL, 51, 59, 'VALID', '2021-03-21 19:41:11', '9.80', 'BGT57582021032192604', 'BKASH-BKash', 'KX8CL49EJL06', 'BDT', '2021-03-21 19:43:03', '2021-03-21 19:43:03'),
(100, 'BGT69532021032197460', NULL, 51, 59, 'VALID', '2021-03-21 20:16:47', '9.80', 'BGT69532021032197460', 'BKASH-BKash', 'KX8CL19FXW9N', 'BDT', '2021-03-21 20:18:21', '2021-03-21 20:18:21'),
(101, 'BGT71792021032263858', NULL, 11, 41, 'VALID', '2021-03-22 16:25:36', '14.70', 'BGT71792021032263858', 'BKASH-BKash', 'KX8CM09XRB6Y', 'BDT', '2021-03-22 16:26:39', '2021-03-22 16:26:39'),
(102, 'BGT21722021032281283', NULL, 3, 42, 'VALID', '2021-03-22 19:00:38', '9.80', 'BGT21722021032281283', 'BKASH-BKash', 'KX8CM9A2FMXR', 'BDT', '2021-03-22 19:01:25', '2021-03-22 19:01:25'),
(103, 'BGT65272021032288317', NULL, 11, 52, 'VALID', '2021-03-22 19:51:47', '11.76', 'BGT65272021032288317', 'BKASH-BKash', 'KX8CM3A4MAGV', 'BDT', '2021-03-22 19:52:53', '2021-03-22 19:52:53'),
(104, 'BGT27322021032289123', NULL, 11, 52, 'VALID', '2021-03-22 19:57:17', '9.80', 'BGT27322021032289123', 'BKASH-BKash', 'KX8CM9A4TUP1', 'BDT', '2021-03-22 19:58:18', '2021-03-22 19:58:18'),
(105, 'BGT12382021032295063', NULL, 11, 54, 'VALID', '2021-03-22 20:41:00', '11.76', 'BGT12382021032295063', 'BKASH-BKash', 'KX8CM5A6GCC9', 'BDT', '2021-03-22 20:42:12', '2021-03-22 20:42:12'),
(106, 'NG41422021032340366', NULL, 3, 42, 'VALID', '2021-03-23 13:22:37', '9.80', 'NG41422021032340366', 'NAGAD-Nagad', 'N015****6045', 'BDT', '2021-03-23 13:23:18', '2021-03-23 13:23:18'),
(107, 'BGT80022021032424039', NULL, 11, 56, 'VALID', '2021-03-24 10:36:58', '11.76', 'BGT80022021032424039', 'BKASH-BKash', 'KX8CO1B49LK1', 'BDT', '2021-03-24 10:39:26', '2021-03-24 10:39:26'),
(108, 'BGT32932021032443041', NULL, 11, 50, 'VALID', '2021-03-24 13:22:09', '11.76', 'BGT32932021032443041', 'BKASH-BKash', 'KX8CO1B8Q3OT', 'BDT', '2021-03-24 13:23:16', '2021-03-24 13:23:16'),
(109, 'BGT16832021032485441', NULL, 11, 30, 'VALID', '2021-03-24 20:04:46', '11.76', 'BGT16832021032485441', 'BKASH-BKash', 'KX8CO6BJEA84', 'BDT', '2021-03-24 20:05:51', '2021-03-24 20:05:51'),
(110, 'BGT80232021032542691', NULL, 11, 68, 'VALID', '2021-03-25 13:06:08', '11.76', 'BGT80232021032542691', 'BKASH-BKash', 'KX8CP6BXFN5Y', 'BDT', '2021-03-25 13:07:19', '2021-03-25 13:07:19'),
(111, 'BGT249720210326101254', NULL, 3, 42, 'VALID', '2021-03-26 21:24:44', '9.80', 'BGT249720210326101254', 'BKASH-BKash', 'KX8CQ1CY4J6B', 'BDT', '2021-03-26 21:26:12', '2021-03-26 21:26:12'),
(112, 'BGT98732021032771115', NULL, 11, 41, 'VALID', '2021-03-27 16:46:58', '14.70', 'BGT98732021032771115', 'BKASH-BKash', 'KX8CR3DCMJ2Z', 'BDT', '2021-03-27 16:48:13', '2021-03-27 16:48:13'),
(113, 'BGT99812021032771478', NULL, 11, 41, 'VALID', '2021-03-27 16:50:25', '11.76', 'BGT99812021032771478', 'BKASH-BKash', 'KX8CR0DCP0NW', 'BDT', '2021-03-27 16:51:32', '2021-03-27 16:51:32'),
(114, 'BGT21392021032982460', NULL, 11, 77, 'VALID', '2021-03-29 19:57:47', '11.76', 'BGT21392021032982460', 'BKASH-BKash', 'KX8CT0EWC8SQ', 'BDT', '2021-03-29 19:58:44', '2021-03-29 19:58:44'),
(115, 'BGT17482021032984220', NULL, 11, 77, 'VALID', '2021-03-29 20:12:44', '11.76', 'BGT17482021032984220', 'BKASH-BKash', 'KX8CT9EWU8U5', 'BDT', '2021-03-29 20:13:48', '2021-03-29 20:13:48'),
(116, 'BGT45262021033133273', NULL, 11, 49, 'VALID', '2021-03-31 11:49:46', '11.76', 'BGT45262021033133273', 'BKASH-BKash', 'KX8CV2FSDWGI', 'BDT', '2021-03-31 11:50:55', '2021-03-31 11:50:55'),
(117, 'BGT53142021033134855', NULL, 9, 42, 'VALID', '2021-03-31 12:01:33', '9.80', 'BGT53142021033134855', 'BKASH-BKash', 'KX8CV8FSQ0EU', 'BDT', '2021-03-31 12:02:50', '2021-03-31 12:02:50'),
(118, 'BGT92872021033143563', NULL, 11, 72, 'VALID', '2021-03-31 13:08:33', '11.76', 'BGT92872021033143563', 'BKASH-BKash', 'KX8CV0FUHHTC', 'BDT', '2021-03-31 13:09:50', '2021-03-31 13:09:50'),
(119, 'BGT70902021040160384', NULL, 11, 72, 'VALID', '2021-04-01 15:38:55', '11.76', 'BGT70902021040160384', 'BKASH-BKash', 'KX8D14GMULG4', 'BDT', '2021-04-01 15:39:47', '2021-04-01 15:39:47'),
(120, 'BGT79312021041079460', NULL, 11, 6, 'VALID', '2021-04-10 17:07:06', '11.76', 'BGT79312021041079460', 'BKASH-BKash', 'KX8DA5N9MLOV', 'BDT', '2021-04-10 17:08:03', '2021-04-10 17:08:03'),
(121, 'BGT89112021041166141', NULL, 11, 5, 'VALID', '2021-04-11 15:46:50', '11.76', 'BGT89112021041166141', 'BKASH-BKash', 'KX8DB3O15P0N', 'BDT', '2021-04-11 15:47:37', '2021-04-11 15:47:37'),
(122, 'BGT695420210411108768', NULL, 11, 78, 'VALID', '2021-04-11 21:02:32', '11.76', 'BGT695420210411108768', 'BKASH-BKash', 'KX8DB6OD6KIU', 'BDT', '2021-04-11 21:03:41', '2021-04-11 21:03:41'),
(123, 'BGT65922021041248772', NULL, 11, 26, 'VALID', '2021-04-12 12:36:55', '11.76', 'BGT65922021041248772', 'BKASH-BKash', 'KX8DC5OQUQCH', 'BDT', '2021-04-12 12:38:13', '2021-04-12 12:38:13'),
(124, 'BGT31032021041275322', NULL, 11, 51, 'VALID', '2021-04-12 16:01:09', '11.76', 'BGT31032021041275322', 'BKASH-BKash', 'KX8DC0OW982U', 'BDT', '2021-04-12 16:02:16', '2021-04-12 16:02:16'),
(125, 'BGT43502021041293641', NULL, 11, 70, 'VALID', '2021-04-12 18:24:56', '11.76', 'BGT43502021041293641', 'BKASH-BKash', 'KX8DC2P13Z3U', 'BDT', '2021-04-12 18:26:31', '2021-04-12 18:26:31'),
(126, 'BGT38432021041453828', NULL, 11, 41, 'VALID', '2021-04-14 13:00:33', '14.70', 'BGT38432021041453828', 'BKASH-BKash', 'KX8DE3QJ14N5', 'BDT', '2021-04-14 13:01:30', '2021-04-14 13:01:30');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id`, `user_name`, `first_name`, `last_name`, `company_id`, `mobile`, `email`, `password`, `user_role_id`, `status`, `datetime`) VALUES
(1, 'admin', 'SasthoBD', '', 1, NULL, NULL, 'MTIz', 1, 1, '2019-09-24 00:00:00'),
(2, 'mod', 'MOD', '', 2, NULL, NULL, 'MTIz', 3, 1, '2020-07-14 13:00:00'),
(7, 'shiba', 'das', NULL, 1, '123', NULL, 'MTIz', 3, 1, '2020-09-13 00:00:00'),
(8, 'shasthobd', 'shasthobd', ' ', 1, '01966622262', 'info@shasthobd.com', 'YWRtaW5AMTIz', 2, 1, '2020-09-13 00:56:08');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_role`
--

CREATE TABLE `tbl_user_role` (
  `id` int(11) NOT NULL,
  `role_name` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `core_id` tinyint(4) NOT NULL DEFAULT 0,
  `edate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_user_role`
--

INSERT INTO `tbl_user_role` (`id`, `role_name`, `status`, `core_id`, `edate`) VALUES
(1, 'Admin', 1, 0, '2020-07-14 11:20:00'),
(2, 'Moderator', 1, 0, '2020-07-14 11:00:00'),
(3, 'Super Duper Admin', 1, 1, '2020-07-14 12:00:00');

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
-- Indexes for table `tbl_appointment`
--
ALTER TABLE `tbl_appointment`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_consultation`
--
ALTER TABLE `tbl_consultation`
  ADD PRIMARY KEY (`OID`),
  ADD KEY `FK_Consultation_PatientID` (`PatientID`),
  ADD KEY `FK_Consultation_DoctorID` (`DoctorID`);

--
-- Indexes for table `tbl_contact_info`
--
ALTER TABLE `tbl_contact_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_doctor`
--
ALTER TABLE `tbl_doctor`
  ADD PRIMARY KEY (`DOCID`);

--
-- Indexes for table `tbl_doctor_log`
--
ALTER TABLE `tbl_doctor_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_doctype`
--
ALTER TABLE `tbl_doctype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_guide`
--
ALTER TABLE `tbl_guide`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_hospital`
--
ALTER TABLE `tbl_hospital`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_instant_payment`
--
ALTER TABLE `tbl_instant_payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_labtest_trace`
--
ALTER TABLE `tbl_labtest_trace`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_menu`
--
ALTER TABLE `tbl_menu`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indexes for table `tbl_notification`
--
ALTER TABLE `tbl_notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_notification_tokens`
--
ALTER TABLE `tbl_notification_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_otherprofessional`
--
ALTER TABLE `tbl_otherprofessional`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_otp`
--
ALTER TABLE `tbl_otp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_patient`
--
ALTER TABLE `tbl_patient`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_patientfile`
--
ALTER TABLE `tbl_patientfile`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_patientreport`
--
ALTER TABLE `tbl_patientreport`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_patient_activity_instant`
--
ALTER TABLE `tbl_patient_activity_instant`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_permission`
--
ALTER TABLE `tbl_permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_prescriptionfile`
--
ALTER TABLE `tbl_prescriptionfile`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `tbl_prescription_trace`
--
ALTER TABLE `tbl_prescription_trace`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_reason`
--
ALTER TABLE `tbl_reason`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_relativepatient`
--
ALTER TABLE `tbl_relativepatient`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_sliders`
--
ALTER TABLE `tbl_sliders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_sms_log`
--
ALTER TABLE `tbl_sms_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_specialist`
--
ALTER TABLE `tbl_specialist`
  ADD PRIMARY KEY (`OID`);

--
-- Indexes for table `tbl_sub_menu`
--
ALTER TABLE `tbl_sub_menu`
  ADD PRIMARY KEY (`sub_menu_id`);

--
-- Indexes for table `tbl_times`
--
ALTER TABLE `tbl_times`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_time_gaps`
--
ALTER TABLE `tbl_time_gaps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_role`
--
ALTER TABLE `tbl_user_role`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `tbl_appointment`
--
ALTER TABLE `tbl_appointment`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT for table `tbl_consultation`
--
ALTER TABLE `tbl_consultation`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT for table `tbl_contact_info`
--
ALTER TABLE `tbl_contact_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_doctor`
--
ALTER TABLE `tbl_doctor`
  MODIFY `DOCID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `tbl_doctor_log`
--
ALTER TABLE `tbl_doctor_log`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_doctype`
--
ALTER TABLE `tbl_doctype`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_guide`
--
ALTER TABLE `tbl_guide`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_hospital`
--
ALTER TABLE `tbl_hospital`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_instant_payment`
--
ALTER TABLE `tbl_instant_payment`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_labtest_trace`
--
ALTER TABLE `tbl_labtest_trace`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tbl_menu`
--
ALTER TABLE `tbl_menu`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_notification`
--
ALTER TABLE `tbl_notification`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_notification_tokens`
--
ALTER TABLE `tbl_notification_tokens`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_otherprofessional`
--
ALTER TABLE `tbl_otherprofessional`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_otp`
--
ALTER TABLE `tbl_otp`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=244;

--
-- AUTO_INCREMENT for table `tbl_patient`
--
ALTER TABLE `tbl_patient`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT for table `tbl_patientfile`
--
ALTER TABLE `tbl_patientfile`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT for table `tbl_patientreport`
--
ALTER TABLE `tbl_patientreport`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `tbl_patient_activity_instant`
--
ALTER TABLE `tbl_patient_activity_instant`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `tbl_permission`
--
ALTER TABLE `tbl_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=323;

--
-- AUTO_INCREMENT for table `tbl_prescriptionfile`
--
ALTER TABLE `tbl_prescriptionfile`
  MODIFY `Id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT for table `tbl_prescription_trace`
--
ALTER TABLE `tbl_prescription_trace`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tbl_reason`
--
ALTER TABLE `tbl_reason`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_relativepatient`
--
ALTER TABLE `tbl_relativepatient`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `tbl_sliders`
--
ALTER TABLE `tbl_sliders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_sms_log`
--
ALTER TABLE `tbl_sms_log`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `tbl_specialist`
--
ALTER TABLE `tbl_specialist`
  MODIFY `OID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `tbl_sub_menu`
--
ALTER TABLE `tbl_sub_menu`
  MODIFY `sub_menu_id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `tbl_times`
--
ALTER TABLE `tbl_times`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `tbl_time_gaps`
--
ALTER TABLE `tbl_time_gaps`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_user_role`
--
ALTER TABLE `tbl_user_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
