/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.20-12.3.3-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: minicms_db
-- ------------------------------------------------------
-- Server version	12.3.3-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `project_submissions`
--

DROP TABLE IF EXISTS `project_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_submissions` (
  `id` varchar(191) NOT NULL,
  `projectId` varchar(191) NOT NULL,
  `formId` varchar(191) DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`data`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  KEY `project_submissions_projectId_idx` (`projectId`),
  CONSTRAINT `project_submissions_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_submissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `project_submissions` WRITE;
/*!40000 ALTER TABLE `project_submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_submissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `project_users`
--

DROP TABLE IF EXISTS `project_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_users` (
  `id` varchar(191) NOT NULL,
  `projectId` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `role` varchar(191) NOT NULL DEFAULT 'admin',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_users_projectId_email_key` (`projectId`,`email`),
  KEY `project_users_projectId_idx` (`projectId`),
  CONSTRAINT `project_users_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_users`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `project_users` WRITE;
/*!40000 ALTER TABLE `project_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_users` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`blocks`)),
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `authEnabled` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `routePrefix` varchar(191) NOT NULL DEFAULT 'sitio',
  PRIMARY KEY (`id`),
  UNIQUE KEY `projects_slug_key` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES
('cmue7ctf80000pplfgzdfhm44','test','TEST','Prueba para ver si cumplimos con el flujo de trabajo we',1,'[{\"id\":\"b-1790173961964\",\"type\":\"HERO\",\"content\":{\"title\":\"TEST\",\"subtitle\":\"Prueba para ver si cumplimos con el flujo de trabajo we\",\"ctaText\":\"Descubrir más\"},\"styles\":{}},{\"id\":\"b-feat-1790173961964\",\"type\":\"FEATURES\",\"content\":{\"items\":[{\"title\":\"Rendimiento Extremo\",\"desc\":\"Optimizado con Fastify y Vite para respuestas en microsegundos.\"},{\"title\":\"Modularidad Pura\",\"desc\":\"Configuración de bloques dinámicos JSON en MariaDB.\"},{\"title\":\"Seguridad Multi-Tenant\",\"desc\":\"Sesiones y autenticación aisladas por proyecto.\"}]},\"styles\":{}},{\"id\":\"canvas-1790570142929\",\"type\":\"CANVAS_GRID\",\"content\":{\"title\":\"Lienzo Modular Drag & Drop\",\"columns\":3,\"gap\":16,\"items\":[{\"id\":\"c-card-1790570142931\",\"type\":\"card\",\"colSpan\":1,\"rowSpan\":1,\"content\":{\"cardTitle\":\"Espacio de Tarjeta\",\"cardDescription\":\"Contenedor modular con estética Apple Glassmorphism.\"}},{\"id\":\"c-img-1790570142929\",\"type\":\"image\",\"colSpan\":2,\"rowSpan\":2,\"content\":{\"imageUrl\":\"https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=1000&q=80\",\"title\":\"Espacio de Imagen Principal\",\"subtitle\":\"Arrastra widgets hacia el lienzo para reservar nuevos espacios\"}},{\"id\":\"c-text-1790570142930\",\"type\":\"text\",\"colSpan\":1,\"rowSpan\":1,\"content\":{\"heading\":\"Espacio de Texto\",\"bodyText\":\"Escribe aquí tu encabezado o mensaje destacado con tipografía limpia.\",\"alignment\":\"left\"}},{\"id\":\"c-image-1790570162322\",\"type\":\"image\",\"colSpan\":2,\"rowSpan\":2,\"content\":{\"imageUrl\":\"https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80\",\"title\":\"Nuevo Espacio de Imagen\",\"subtitle\":\"Descripción de la imagen\",\"alignment\":\"left\",\"buttonUrl\":\"#\"}},{\"id\":\"c-image-1790570165593\",\"type\":\"image\",\"colSpan\":3,\"rowSpan\":1,\"content\":{\"imageUrl\":\"https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80\",\"title\":\"Nuevo Espacio de Imagen\",\"subtitle\":\"Descripción de la imagen\",\"alignment\":\"left\",\"buttonUrl\":\"#\"}}]},\"styles\":{}}]','{\"coverImage\":\"/storage/tenants/testing/test/uploads/1790174849610-php_icon_130857.png\",\"loginSettings\":{\"title\":\"TEST\",\"subtitle\":\"Ingresa tus credenciales autorizadas para acceder a tu espacio\",\"badgeText\":\"Acceso Seguro\",\"logoUrl\":\"/storage/tenants/testing/test/uploads/1790174849610-php_icon_130857.png\",\"bgImageUrl\":\"\",\"bgBlur\":24,\"bgDarkness\":41,\"glowColor\":\"#8b5cf6\",\"accentColor\":\"#7c3aed\",\"buttonText\":\"Iniciar Sesión\",\"helpText\":\"¿Problemas para acceder? Contacta al soporte técnico\",\"showBackLink\":true}}',1,'2026-09-23 14:32:41.972','2026-09-28 04:36:16.586','testing');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `super_admins`
--

DROP TABLE IF EXISTS `super_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `super_admins` (
  `id` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `super_admins_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `super_admins`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `super_admins` WRITE;
/*!40000 ALTER TABLE `super_admins` DISABLE KEYS */;
INSERT INTO `super_admins` VALUES
('cmuat7abl0000ppf7n5lttjl7','admin@puvlo.com','$2b$10$3H47ObWGe4AUrgEemMNbKOES9408fgG8I7B5tEPhS11BWWYLuPfly','Super Admin','2026-09-21 05:33:10.785','2026-09-21 05:33:10.785');
/*!40000 ALTER TABLE `super_admins` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-27 22:40:32
