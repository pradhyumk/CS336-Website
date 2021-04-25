CREATE DATABASE  IF NOT EXISTS `buyme` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `buyme`;
-- MySQL dump 10.13  Distrib 8.0.22, for macos10.15 (x86_64)
--
-- Host: 69.115.98.32    Database: buyme
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adminaccount`
--

DROP TABLE IF EXISTS `adminaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adminaccount` (
  `accountID` int NOT NULL AUTO_INCREMENT,
  `street` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `zip` int DEFAULT NULL,
  `phoneNumber` varchar(12) DEFAULT NULL,
  `loginStatus` tinyint(1) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `userPassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminaccount`
--

LOCK TABLES `adminaccount` WRITE;
/*!40000 ALTER TABLE `adminaccount` DISABLE KEYS */;
INSERT INTO `adminaccount` VALUES (1,'69 Bigman Street','Blazertown','New Jersey',1285,'1231231234',1,'admin@buyme.com','John','Smith','admin','password');
/*!40000 ALTER TABLE `adminaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `alertID` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(50) DEFAULT NULL,
  `accountID` int DEFAULT NULL,
  PRIMARY KEY (`alertID`),
  KEY `alertSeller_fk_idx` (`accountID`),
  KEY `alert_id_idx` (`itemName`),
  CONSTRAINT `alertsBUyer_fk` FOREIGN KEY (`accountID`) REFERENCES `buyeraccount` (`accountID`),
  CONSTRAINT `alertSeller_fk` FOREIGN KEY (`accountID`) REFERENCES `selleraccount` (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES (1,'adidas max',15);
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction`
--

DROP TABLE IF EXISTS `auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction` (
  `auctionID` int NOT NULL AUTO_INCREMENT,
  `startPrice` float DEFAULT NULL,
  `upperLimit` float DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endPrice` float DEFAULT NULL,
  `closingDateTime` datetime DEFAULT NULL,
  `currentPrice` float DEFAULT NULL,
  `bidIncrement` float DEFAULT NULL,
  `accountID` int DEFAULT NULL,
  `minPrice` float DEFAULT NULL,
  PRIMARY KEY (`auctionID`),
  KEY `auctionSeller_fk_idx` (`accountID`),
  CONSTRAINT `auctionBuyer_fk` FOREIGN KEY (`accountID`) REFERENCES `buyeraccount` (`accountID`),
  CONSTRAINT `auctionSeller_fk` FOREIGN KEY (`accountID`) REFERENCES `selleraccount` (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction`
--

LOCK TABLES `auction` WRITE;
/*!40000 ALTER TABLE `auction` DISABLE KEYS */;
INSERT INTO `auction` VALUES (1,50,NULL,'2021-04-25 11:17:00',NULL,'2021-04-25 11:20:00',65,5,16,150),(2,25,NULL,'2021-04-25 11:21:00',NULL,'2021-04-25 11:35:00',55,5,16,100),(3,120,NULL,'2021-04-25 11:23:00',NULL,'2021-04-25 11:33:00',120,10,14,250),(4,25,NULL,'2021-04-25 11:24:00',NULL,'2021-04-25 11:30:00',25,5,14,25),(5,20,NULL,'2021-04-25 11:37:00',NULL,'2021-04-25 11:39:00',82.5,2.5,16,30),(6,25,NULL,'2021-04-25 11:42:00',NULL,'2021-04-25 11:44:00',46,1,15,30);
/*!40000 ALTER TABLE `auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bid`
--

DROP TABLE IF EXISTS `bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bid` (
  `bidNumber` int NOT NULL AUTO_INCREMENT,
  `bidDateTime` datetime DEFAULT NULL,
  `bidAmount` float DEFAULT NULL,
  `buyerMaximum` float DEFAULT NULL,
  `auctionID` int DEFAULT NULL,
  `accountID` int DEFAULT NULL,
  PRIMARY KEY (`bidNumber`),
  KEY `bidAuction_fk_idx` (`auctionID`),
  KEY `bidAccountID_idx` (`accountID`),
  CONSTRAINT `bidAccountID` FOREIGN KEY (`accountID`) REFERENCES `buyeraccount` (`accountID`),
  CONSTRAINT `bidAccountID2` FOREIGN KEY (`accountID`) REFERENCES `selleraccount` (`accountID`),
  CONSTRAINT `bidAuction_fk` FOREIGN KEY (`auctionID`) REFERENCES `auction` (`auctionID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid`
--

LOCK TABLES `bid` WRITE;
/*!40000 ALTER TABLE `bid` DISABLE KEYS */;
INSERT INTO `bid` VALUES (1,'2021-04-25 11:17:33',55,100,1,15),(2,'2021-04-25 11:18:07',60,60,1,14),(3,'2021-04-25 11:18:07',65,100,1,15),(4,'2021-04-25 11:26:48',30,50,2,14),(5,'2021-04-25 11:27:11',35,60,2,15),(6,'2021-04-25 11:27:11',55,60,2,15),(7,'2021-04-25 11:27:40',60,60,2,16),(8,'2021-04-25 11:37:16',40,50,5,14),(9,'2021-04-25 11:37:37',42.5,100,5,14),(10,'2021-04-25 11:38:28',45,60,5,15),(11,'2021-04-25 11:38:28',62.5,100,5,14),(12,'2021-04-25 11:38:46',65,80,5,15),(13,'2021-04-25 11:38:46',100,100,5,14),(14,'2021-04-25 11:42:25',26,50,6,16),(15,'2021-04-25 11:42:41',27,45,6,14),(16,'2021-04-25 11:42:41',46,50,6,16);
/*!40000 ALTER TABLE `bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buyeraccount`
--

DROP TABLE IF EXISTS `buyeraccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buyeraccount` (
  `accountID` int NOT NULL AUTO_INCREMENT,
  `street` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `zip` int DEFAULT NULL,
  `phoneNumber` varchar(12) DEFAULT NULL,
  `loginStatus` tinyint(1) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `userPassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buyeraccount`
--

LOCK TABLES `buyeraccount` WRITE;
/*!40000 ALTER TABLE `buyeraccount` DISABLE KEYS */;
INSERT INTO `buyeraccount` VALUES (1,'56 Asher Ct','Monmouth Junction','NJ',8852,'1234567890',1,'example@yahoo.com','Ghost','Rider','Ghost','asdaf'),(2,'855 Grove Ave','Edison','NJ',12345,'123456789',1,'mtt@mtt.in','John','Deere','jdeere','jdeere123'),(11,'321 Example Street','Princeton','New Jersey',75231,'1231231234',1,'rainbow@example.com','User','Account','rainbow','password'),(13,'321 Example Street','Princeton','New Jersey',75231,'1231231234',1,'apple@example.com','User','Account','apple','fruit'),(14,'321 Example Street','Princeton','New Jersey',75231,'1231231234',1,'milkman@example.com','User','Account','milkman','password'),(15,'123 Example st','new brunswick','new jersey',12345,'1231231234',1,'user@company.com','usernamw','lastname','username','password'),(16,'123 street','new brunswick','new jersey',12345,'1231231234',1,'hello@test.com','username','banana','hello','password');
/*!40000 ALTER TABLE `buyeraccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `categoryID` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`categoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'footwear');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerrepaccount`
--

DROP TABLE IF EXISTS `customerrepaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerrepaccount` (
  `accountID` int NOT NULL AUTO_INCREMENT,
  `street` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `zip` int DEFAULT NULL,
  `phoneNumber` varchar(12) DEFAULT NULL,
  `loginStatus` tinyint(1) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `userPassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerrepaccount`
--

LOCK TABLES `customerrepaccount` WRITE;
/*!40000 ALTER TABLE `customerrepaccount` DISABLE KEYS */;
INSERT INTO `customerrepaccount` VALUES (1,'420 Blazer Street','Blazertown','New Jersey',1285,'3123211456',1,'rep@buyme.com','Douglas','Scipio','customerrep','password');
/*!40000 ALTER TABLE `customerrepaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `itemID` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(20) DEFAULT NULL,
  `itemDescription` varchar(1000) DEFAULT NULL,
  `subCategoryID` int DEFAULT NULL,
  `itemColor` varchar(45) DEFAULT NULL,
  `itemBrand` varchar(45) DEFAULT NULL,
  `itemSize` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`itemID`),
  KEY `subcatID_fk_idx` (`subCategoryID`),
  CONSTRAINT `subcatID_fk` FOREIGN KEY (`subCategoryID`) REFERENCES `subcategory` (`subCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'adidas max','nice shoes',1,'white','adidas','10'),(2,'crocs','good sandals doesnt go above reserve price',2,'green','crocs','9.5'),(3,'cool sneakers','nice ones',1,'red','nike','12.5'),(4,'slippies','very cool slipper',3,'black','bata','12'),(5,'slides','nice slippers',3,'black','nike','10'),(6,'adidas slides','showing a winner now',3,'white','adidas','5');
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notificationID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `auctionID` int DEFAULT NULL,
  `notificationText` varchar(1000) DEFAULT NULL,
  `notificationTime` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`notificationID`),
  KEY `accountID` (`accountID`),
  KEY `auctionID` (`auctionID`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `buyeraccount` (`accountID`),
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`auctionID`) REFERENCES `auction` (`auctionID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,15,1,'The item you requested for (adidas max) has been listed in the action','Sun Apr 25 11:17:00 EDT 2021'),(2,15,1,'You are now leading the auction via auto-bid.','2021-04-25 11:18:07'),(3,14,1,'Your upper-limit was outbid by another user.','2021-04-25 11:18:07'),(4,16,1,'The auction has closed and your item has not been sold.','2021-04-25 11:20:00.0'),(5,15,2,'You are now leading the auction via auto-bid.','2021-04-25 11:27:11'),(6,14,2,'Your upper-limit was outbid by another user.','2021-04-25 11:27:11'),(7,16,2,'You are now leading the auction via auto-bid.','2021-04-25 11:27:40'),(8,14,2,'Your upper-limit was outbid by another user.','2021-04-25 11:27:40'),(9,14,4,'No bids were placed on your auction.','2021-04-25 11:30:00.0'),(10,14,3,'The auction has closed and your item has not been sold.','2021-04-25 11:33:00.0'),(11,16,2,'The auction has closed and your item has not been sold.','2021-04-25 11:35:00.0'),(12,14,5,'You are now leading the auction via auto-bid.','2021-04-25 11:38:28'),(13,15,5,'Your upper-limit was outbid by another user.','2021-04-25 11:38:28'),(14,14,5,'You are now leading the auction via auto-bid.','2021-04-25 11:38:46'),(15,15,5,'Your upper-limit was outbid by another user.','2021-04-25 11:38:46'),(16,14,5,'You have won the auction.','2021-04-25 11:39:00.0'),(17,16,5,'The auction has closed and your item has sold.','2021-04-25 11:39:00.0'),(18,16,6,'You are now leading the auction via auto-bid.','2021-04-25 11:42:41'),(19,14,6,'Your upper-limit was outbid by another user.','2021-04-25 11:42:41'),(20,16,6,'You have won the auction.','2021-04-25 11:44:00.0'),(21,15,6,'The auction has closed and your item has sold.','2021-04-25 11:44:00.0');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selleraccount`
--

DROP TABLE IF EXISTS `selleraccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selleraccount` (
  `accountID` int NOT NULL AUTO_INCREMENT,
  `street` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `zip` int DEFAULT NULL,
  `phoneNumber` varchar(12) DEFAULT NULL,
  `loginStatus` tinyint(1) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `userPassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selleraccount`
--

LOCK TABLES `selleraccount` WRITE;
/*!40000 ALTER TABLE `selleraccount` DISABLE KEYS */;
INSERT INTO `selleraccount` VALUES (1,'56 Asher Ct','Monmouth Junction','NJ',8852,'1234567890',1,'example@yahoo.com','Ghost','Rider','Ghost','asdaf'),(2,'NJ','Edison','NJ',12345,'123456789',1,'mtt@mtt.in','John','Deere','jdeere','jdeere123'),(11,'321 Example Street','Princeton','New Jersey',75231,'1231231234',1,'rainbow@example.com','User','Account','rainbow','password'),(13,'321 Example Street','Princeton','New Jersey',75231,'1231231234',1,'apple@example.com','User','Account','apple','fruit'),(14,'321 Example Street','Princeton','New Jersey',75231,'1231231234',1,'milkman@example.com','User','Account','milkman','password'),(15,'123 Example st','new brunswick','new jersey',12345,'1231231234',1,'user@company.com','usernamw','lastname','username','password'),(16,'123 street','new brunswick','new jersey',12345,'1231231234',1,'hello@test.com','username','banana','hello','password');
/*!40000 ALTER TABLE `selleraccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategory`
--

DROP TABLE IF EXISTS `subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategory` (
  `subCategoryID` int NOT NULL AUTO_INCREMENT,
  `subCategoryName` varchar(20) DEFAULT NULL,
  `categoryID` int DEFAULT NULL,
  PRIMARY KEY (`subCategoryID`),
  KEY `category_id_idx` (`categoryID`),
  CONSTRAINT `category_id` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategory`
--

LOCK TABLES `subcategory` WRITE;
/*!40000 ALTER TABLE `subcategory` DISABLE KEYS */;
INSERT INTO `subcategory` VALUES (1,'Sneakers',1),(2,'Sandals',1),(3,'Slippers',1);
/*!40000 ALTER TABLE `subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `winningmember`
--

DROP TABLE IF EXISTS `winningmember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `winningmember` (
  `winningMemberID` int NOT NULL AUTO_INCREMENT,
  `auctionID` int DEFAULT NULL,
  `accountID` int DEFAULT NULL,
  `winningAccountID` int DEFAULT NULL,
  PRIMARY KEY (`winningMemberID`),
  KEY `winmemacc_1_idx` (`accountID`),
  KEY `winningMemberAuction_fk_idx` (`auctionID`),
  CONSTRAINT `winmemacc_1` FOREIGN KEY (`accountID`) REFERENCES `buyeraccount` (`accountID`),
  CONSTRAINT `winmemacc_2` FOREIGN KEY (`accountID`) REFERENCES `selleraccount` (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `winningmember`
--

LOCK TABLES `winningmember` WRITE;
/*!40000 ALTER TABLE `winningmember` DISABLE KEYS */;
INSERT INTO `winningmember` VALUES (1,1,16,-1),(2,2,16,-1),(3,3,14,-1),(4,4,14,-1),(5,5,16,14),(6,6,15,16);
/*!40000 ALTER TABLE `winningmember` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-25 12:05:08
