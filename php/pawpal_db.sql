-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2026 at 06:36 AM
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
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `requester_user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `requested_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `pet_id`, `requester_user_id`, `message`, `status`, `requested_at`) VALUES
(1, 27, 2, 'Can i adopt this?', 'Pending', '2026-01-10 02:15:25');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `donator_user_id` int(11) NOT NULL,
  `donation_type` enum('Food','Medical','Money') NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `donated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `donator_user_id`, `donation_type`, `amount`, `description`, `donated_at`) VALUES
(1, 28, 1, 'Money', 1.00, '', '2026-01-10 09:11:23'),
(2, 28, 1, 'Food', 0.00, '1kg of house food', '2026-01-10 10:18:08');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pet_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` enum('Male','Female','Unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `age` int(3) NOT NULL,
  `health_status` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_paths` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lng` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `gender`, `age`, `health_status`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(27, 1, 'Darwin', 'Fish', 'Male', 1, 'No illness', 'Adoption', 'Goldfish', '[\"../assets/pets/pet_27_1.png\"]', '37.4219983', '-122.084', '2026-01-09 20:12:37'),
(28, 2, 'Housey', 'Other', 'Unknown', 50, 'House', 'Donation Request', 'Green', '[\"../assets/pets/pet_28_1.png\"]', '37.4219983', '-122.084', '2026-01-09 22:43:03');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_image_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registered_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `phone`, `password`, `profile_image_path`, `registered_at`) VALUES
(1, 'Alexander', 'Alex@gmail.com', '0198765432', '7c4a8d09ca3762af61e59520943dc26494f8941b', '../assets/profile/profile_1_1768017517.png', '2025-11-25 18:26:02'),
(2, 'Steve', 'Steve@yahoo.com', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2025-11-25 22:52:22'),
(3, 'Blex', 'Blex@gmail.com', '0134567892', 'd54b76b2bad9d9946011ebc62a1d272f4122c7b5', NULL, '2025-11-25 23:14:07'),
(4, 'Katy', 'Katy@yahoo.my', '0134562798', '601f1889667efaebb33b8c12572835da3f027f78', NULL, '2025-11-25 23:39:47'),
(5, 'Betty', 'Betty@gmail.com', '01987654321', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2026-01-04 23:58:41'),
(6, 'Cathy', 'Cathy@gmail.com', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2026-01-05 00:02:34'),
(7, 'Daniel', 'Daniel@gmail.com', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2026-01-05 00:05:43'),
(8, 'Ethan', 'Ethan@gmail.com', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2026-01-05 00:06:52'),
(9, 'Fanny', 'Fanny@gmail.com', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2026-01-05 00:27:23'),
(10, 'Gabriel', 'Gabriel@gmail.com', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '2026-01-09 18:49:21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`),
  ADD KEY `pet_id` (`pet_id`),
  ADD KEY `requester_user_id` (`requester_user_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `pet_id` (`pet_id`),
  ADD KEY `donator_user_id` (`donator_user_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD CONSTRAINT `tbl_adoptions_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_adoptions_ibfk_2` FOREIGN KEY (`requester_user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD CONSTRAINT `tbl_donations_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_donations_ibfk_2` FOREIGN KEY (`donator_user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
