-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 10 Des 2023 pada 14.47
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `book_hub`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `admin_email` varchar(50) NOT NULL,
  `admin_name` varchar(50) NOT NULL,
  `admin_password` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`admin_email`, `admin_name`, `admin_password`) VALUES
('adminkeren@gmail.com', 'minker', 'minker@789'),
('johhnypapa@gmail.com', 'Ten', 'johhnyPapa123'),
('rinoptr@gmail.com', 'rino', 'rino@123'),
('whoisthis@yahoo.co.id', 'MiMin', '$MiminMomo$');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `available_books`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `available_books` (
`book_id` char(5)
,`book_title` varchar(40)
,`book_author` varchar(30)
,`book_price` int(11)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `book`
--

CREATE TABLE `book` (
  `book_id` char(5) NOT NULL,
  `book_title` varchar(40) NOT NULL,
  `book_author` varchar(30) NOT NULL,
  `book_page` int(11) NOT NULL,
  `book_status` enum('Tersedia','Tidak Tersedia') NOT NULL,
  `book_price` int(11) NOT NULL,
  `e_book_format` varchar(50) DEFAULT NULL,
  `e_book_licenseKey` varchar(100) DEFAULT NULL,
  `physicBook_ISBN` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `book`
--

INSERT INTO `book` (`book_id`, `book_title`, `book_author`, `book_page`, `book_status`, `book_price`, `e_book_format`, `e_book_licenseKey`, `physicBook_ISBN`) VALUES
('BK001', 'Harry Potter and The Sorcerers Stone', 'J.K Rowling', 320, 'Tersedia', 120000, 'PDF', 'ABC123XYZ', 'ISBN9780590353427'),
('BK002', 'Laut Bercerita', ' Leila Salikha Chudori', 379, 'Tidak Tersedia', 80000, 'EPUB', 'DEF456UVW', 'ISBN9786024246945'),
('BK004', 'Hujan', 'Tere Liye', 320, 'Tersedia', 70000, 'PDF', 'TLY123HJN', 'ISBN9780590357362'),
('BK005', 'Garis Waktu', ' Fiersa Besari', 212, 'Tidak Tersedia', 65000, 'PDF', 'FRS456GWT', 'ISBN9789797945251');

--
-- Trigger `book`
--
DELIMITER $$
CREATE TRIGGER `update_book_borrow_trigger` AFTER UPDATE ON `book` FOR EACH ROW BEGIN
    UPDATE borrow
    SET borrow_status = 'Sudah Dikembalikan'
    WHERE book_id = NEW.book_id AND borrow_status = 'Belum Dikembalikan';
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `borrow`
--

CREATE TABLE `borrow` (
  `borrow_id` int(11) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date NOT NULL,
  `borrow_status` enum('Sudah Dikembalikan','Belum Dikembalikan') NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `book_id` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `borrow`
--

INSERT INTO `borrow` (`borrow_id`, `borrow_date`, `return_date`, `borrow_status`, `user_email`, `book_id`) VALUES
(1, '2023-10-15', '2023-10-30', 'Sudah Dikembalikan', 'nana.ratma@gmail.com', 'BK001'),
(2, '2023-10-16', '2023-10-14', 'Sudah Dikembalikan', 'ramadharanuh@gmail.com', 'BK002'),
(3, '2023-10-16', '2023-10-31', 'Sudah Dikembalikan', 'tejotegar@gmail.com', 'BK004'),
(4, '2023-08-17', '2023-08-31', 'Sudah Dikembalikan', 'rinoputra@gmail.com', 'BK005'),
(7, '2023-11-25', '2023-12-25', 'Sudah Dikembalikan', 'nana.ratma@gmail.com', 'BK004');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `completedpaymentview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `completedpaymentview` (
`payment_id` int(11)
,`payment_amount` int(11)
,`payment_method` varchar(30)
,`payment_date` date
,`payment_status` enum('Pending','Completed')
,`purchase_id` int(11)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `orderbook`
--

CREATE TABLE `orderbook` (
  `order_id` char(5) NOT NULL,
  `order_amount` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `user_email` varchar(50) NOT NULL,
  `book_id` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `orderbook`
--

INSERT INTO `orderbook` (`order_id`, `order_amount`, `order_date`, `user_email`, `book_id`) VALUES
('OR001', 2, '2023-10-15', 'nana.ratma@gmail.com', 'BK001'),
('OR002', 1, '2023-09-14', 'ramadharanuh@gmail.com', 'BK002'),
('OR004', 3, '2023-10-12', 'rinoputra@gmail.com', 'BK004');

--
-- Trigger `orderbook`
--
DELIMITER $$
CREATE TRIGGER `delete_orderBook_trigger` AFTER DELETE ON `orderbook` FOR EACH ROW BEGIN
    DELETE FROM ShipmentDetails WHERE book_id = OLD.book_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_orderBook_borrow_trigger` AFTER INSERT ON `orderbook` FOR EACH ROW BEGIN
    INSERT INTO borrow (borrow_date, return_date, borrow_status, user_email, book_id)
    VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'Belum Dikembalikan', NEW.user_email, NEW.book_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_orderBook_trigger` AFTER INSERT ON `orderbook` FOR EACH ROW BEGIN
    INSERT INTO ShipmentDetails (purchase_receipt, purchase_status, book_id)
    VALUES ('LMN789', 'Shipped', NEW.book_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_orderBook_trigger1` AFTER INSERT ON `orderbook` FOR EACH ROW BEGIN
    INSERT INTO ShipmentDetails (purchase_receipt, purchase_status, book_id)
    VALUES ('LMN789', 'Shipped', 'BK007');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `payment_amount` int(11) NOT NULL,
  `payment_method` varchar(30) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_status` enum('Pending','Completed') NOT NULL,
  `purchase_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `payments`
--

INSERT INTO `payments` (`payment_id`, `payment_amount`, `payment_method`, `payment_date`, `payment_status`, `purchase_id`) VALUES
(1, 80000, 'PayPal', '2023-10-15', 'Completed', 1),
(2, 120000, 'Credit Card', '2023-10-14', 'Completed', 2),
(5, 70000, 'PayPal', '2023-10-12', 'Completed', 4),
(6, 120000, 'Credit Card', '2023-08-17', 'Completed', 5),
(8, 100000, 'Credit Card', '2023-11-25', 'Completed', 7);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `pendingpaymentview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `pendingpaymentview` (
`payment_id` int(11)
,`payment_amount` int(11)
,`payment_method` varchar(30)
,`payment_date` date
,`payment_status` enum('Pending','Completed')
,`purchase_id` int(11)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `purchase`
--

CREATE TABLE `purchase` (
  `purchase_id` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `purchase`
--

INSERT INTO `purchase` (`purchase_id`, `price`) VALUES
(1, 120000),
(2, 80000),
(3, 70000),
(4, 65000),
(5, 70000),
(7, 100000);

--
-- Trigger `purchase`
--
DELIMITER $$
CREATE TRIGGER `delete_purchase_trigger` AFTER DELETE ON `purchase` FOR EACH ROW BEGIN
    DELETE FROM payments WHERE purchase_id = OLD.purchase_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_purchase_trigger` AFTER INSERT ON `purchase` FOR EACH ROW BEGIN
    INSERT INTO payments (payment_amount, payment_method, payment_date, payment_status, purchase_id)
    VALUES (100, 'Credit Card', CURDATE(), 'Pending', NEW.purchase_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_purchase_trigger1` AFTER INSERT ON `purchase` FOR EACH ROW BEGIN
    INSERT INTO payments (payment_amount, payment_method, payment_date, payment_status, purchase_id)
    VALUES (100000, 'Credit Card', CURDATE(), 'Pending', NEW.purchase_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_purchase_trigger2` AFTER INSERT ON `purchase` FOR EACH ROW BEGIN
    INSERT INTO payments (payment_amount, payment_method, payment_date, payment_status, purchase_id)
    VALUES (100000, 'Credit Card', '2023-11-20', 'Pending', 6);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_purchase_trigger` AFTER UPDATE ON `purchase` FOR EACH ROW BEGIN
    UPDATE payments
    SET payment_status = 'Completed'
    WHERE purchase_id = NEW.purchase_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `shipmentandpaymentview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `shipmentandpaymentview` (
`shipment_id` int(11)
,`purchase_receipt` varchar(30)
,`shipment_status` enum('Shipped','Delivered')
,`payment_id` int(11)
,`payment_amount` int(11)
,`payment_method` varchar(30)
,`payment_date` date
,`payment_status` enum('Pending','Completed')
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `shipmentdetails`
--

CREATE TABLE `shipmentdetails` (
  `shipment_id` int(11) NOT NULL,
  `purchase_receipt` varchar(30) NOT NULL,
  `purchase_status` enum('Shipped','Delivered') NOT NULL,
  `book_id` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `shipmentdetails`
--

INSERT INTO `shipmentdetails` (`shipment_id`, `purchase_receipt`, `purchase_status`, `book_id`) VALUES
(1, 'ABC123', 'Shipped', 'BK001'),
(2, 'DEF456', 'Delivered', 'BK002'),
(3, 'GHI123', 'Delivered', 'BK004');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `shippeddataview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `shippeddataview` (
`shipment_id` int(11)
,`purchase_receipt` varchar(30)
,`shipment_status` enum('Shipped','Delivered')
,`book_id` char(5)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_bookhub`
--

CREATE TABLE `user_bookhub` (
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_password` varchar(30) NOT NULL,
  `user_address` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `user_bookhub`
--

INSERT INTO `user_bookhub` (`user_email`, `user_name`, `user_password`, `user_address`) VALUES
('nana.ratma@gmail.com', 'Nanaaaa', 'nanakeren1515', 'Semarang'),
('ramadharanuh@gmail.com', 'Rmrnh', 'Password123', 'Magelang'),
('rinoputra@gmail.com', 'rino1', 'onir123', 'Malang'),
('tejotegar@gmail.com', 'ttegar', 'tegar456', 'Jakarta');

--
-- Trigger `user_bookhub`
--
DELIMITER $$
CREATE TRIGGER `after_user_insert` AFTER INSERT ON `user_bookhub` FOR EACH ROW BEGIN
INSERT INTO user_creation_log (user_email, creation_time)
VALUES (NEW.user_email, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur untuk view `available_books`
--
DROP TABLE IF EXISTS `available_books`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `available_books`  AS SELECT `book`.`book_id` AS `book_id`, `book`.`book_title` AS `book_title`, `book`.`book_author` AS `book_author`, `book`.`book_price` AS `book_price` FROM `book` WHERE `book`.`book_status` = 'Tersedia''Tersedia'  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `completedpaymentview`
--
DROP TABLE IF EXISTS `completedpaymentview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `completedpaymentview`  AS SELECT `payments`.`payment_id` AS `payment_id`, `payments`.`payment_amount` AS `payment_amount`, `payments`.`payment_method` AS `payment_method`, `payments`.`payment_date` AS `payment_date`, `payments`.`payment_status` AS `payment_status`, `payments`.`purchase_id` AS `purchase_id` FROM `payments` WHERE `payments`.`payment_status` = 'Completed''Completed'  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `pendingpaymentview`
--
DROP TABLE IF EXISTS `pendingpaymentview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pendingpaymentview`  AS SELECT `payments`.`payment_id` AS `payment_id`, `payments`.`payment_amount` AS `payment_amount`, `payments`.`payment_method` AS `payment_method`, `payments`.`payment_date` AS `payment_date`, `payments`.`payment_status` AS `payment_status`, `payments`.`purchase_id` AS `purchase_id` FROM `payments` WHERE `payments`.`payment_status` = 'Pending''Pending'  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `shipmentandpaymentview`
--
DROP TABLE IF EXISTS `shipmentandpaymentview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `shipmentandpaymentview`  AS SELECT `sd`.`shipment_id` AS `shipment_id`, `sd`.`purchase_receipt` AS `purchase_receipt`, `sd`.`purchase_status` AS `shipment_status`, `p`.`payment_id` AS `payment_id`, `p`.`payment_amount` AS `payment_amount`, `p`.`payment_method` AS `payment_method`, `p`.`payment_date` AS `payment_date`, `p`.`payment_status` AS `payment_status` FROM (`shipmentdetails` `sd` left join `payments` `p` on(`sd`.`purchase_receipt` = `p`.`purchase_id`)) WHERE `sd`.`purchase_status` in ('Shipped','Delivered') OR `p`.`payment_status` in ('Pending','Completed')  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `shippeddataview`
--
DROP TABLE IF EXISTS `shippeddataview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `shippeddataview`  AS SELECT `shipmentdetails`.`shipment_id` AS `shipment_id`, `shipmentdetails`.`purchase_receipt` AS `purchase_receipt`, `shipmentdetails`.`purchase_status` AS `shipment_status`, `shipmentdetails`.`book_id` AS `book_id` FROM `shipmentdetails` WHERE `shipmentdetails`.`purchase_status` = 'Shipped''Shipped'  ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_email`);

--
-- Indeks untuk tabel `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`book_id`);

--
-- Indeks untuk tabel `borrow`
--
ALTER TABLE `borrow`
  ADD PRIMARY KEY (`borrow_id`),
  ADD KEY `user_email` (`user_email`),
  ADD KEY `book_id` (`book_id`);

--
-- Indeks untuk tabel `orderbook`
--
ALTER TABLE `orderbook`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_email` (`user_email`),
  ADD KEY `book_id` (`book_id`);

--
-- Indeks untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `purchase_id` (`purchase_id`);

--
-- Indeks untuk tabel `purchase`
--
ALTER TABLE `purchase`
  ADD PRIMARY KEY (`purchase_id`);

--
-- Indeks untuk tabel `shipmentdetails`
--
ALTER TABLE `shipmentdetails`
  ADD PRIMARY KEY (`shipment_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indeks untuk tabel `user_bookhub`
--
ALTER TABLE `user_bookhub`
  ADD PRIMARY KEY (`user_email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `borrow`
--
ALTER TABLE `borrow`
  MODIFY `borrow_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `purchase`
--
ALTER TABLE `purchase`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `shipmentdetails`
--
ALTER TABLE `shipmentdetails`
  MODIFY `shipment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `borrow`
--
ALTER TABLE `borrow`
  ADD CONSTRAINT `borrow_ibfk_1` FOREIGN KEY (`user_email`) REFERENCES `user_bookhub` (`user_email`),
  ADD CONSTRAINT `borrow_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`);

--
-- Ketidakleluasaan untuk tabel `orderbook`
--
ALTER TABLE `orderbook`
  ADD CONSTRAINT `orderbook_ibfk_1` FOREIGN KEY (`user_email`) REFERENCES `user_bookhub` (`user_email`),
  ADD CONSTRAINT `orderbook_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`);

--
-- Ketidakleluasaan untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `purchase` (`purchase_id`);

--
-- Ketidakleluasaan untuk tabel `shipmentdetails`
--
ALTER TABLE `shipmentdetails`
  ADD CONSTRAINT `shipmentdetails_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
