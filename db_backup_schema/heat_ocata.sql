-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: 192.168.100.10    Database: heat
-- ------------------------------------------------------
-- Server version	5.5.5-10.0.30-MariaDB-wsrep

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) DEFAULT NULL,
  `stack_id` varchar(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `resource_action` varchar(255) DEFAULT NULL,
  `resource_status` varchar(255) DEFAULT NULL,
  `resource_name` varchar(255) DEFAULT NULL,
  `physical_resource_id` varchar(255) DEFAULT NULL,
  `resource_status_reason` varchar(255) DEFAULT NULL,
  `resource_type` varchar(255) DEFAULT NULL,
  `resource_properties` blob,
  `rsrc_prop_data_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `stack_id` (`stack_id`),
  KEY `ev_rsrc_prop_data_ref` (`rsrc_prop_data_id`),
  CONSTRAINT `ev_rsrc_prop_data_ref` FOREIGN KEY (`rsrc_prop_data_id`) REFERENCES `resource_properties_data` (`id`),
  CONSTRAINT `event_ibfk_1` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrate_version`
--

DROP TABLE IF EXISTS `migrate_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrate_version` (
  `repository_id` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `repository_path` text COLLATE utf8_unicode_ci,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`repository_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `raw_template`
--

DROP TABLE IF EXISTS `raw_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `raw_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `template` longtext,
  `files` longtext,
  `environment` longtext,
  `files_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raw_tmpl_files_fkey_ref` (`files_id`),
  CONSTRAINT `raw_tmpl_files_fkey_ref` FOREIGN KEY (`files_id`) REFERENCES `raw_template_files` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `raw_template_files`
--

DROP TABLE IF EXISTS `raw_template_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `raw_template_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `files` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource`
--

DROP TABLE IF EXISTS `resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) DEFAULT NULL,
  `nova_instance` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_reason` longtext,
  `stack_id` varchar(36) NOT NULL,
  `rsrc_metadata` longtext,
  `properties_data` longtext,
  `engine_id` varchar(36) DEFAULT NULL,
  `atomic_key` int(11) DEFAULT NULL,
  `needed_by` longtext,
  `requires` longtext,
  `replaces` int(11) DEFAULT NULL,
  `replaced_by` int(11) DEFAULT NULL,
  `current_template_id` int(11) DEFAULT NULL,
  `properties_data_encrypted` tinyint(1) DEFAULT NULL,
  `root_stack_id` varchar(36) DEFAULT NULL,
  `rsrc_prop_data_id` int(11) DEFAULT NULL,
  `attr_data_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `stack_id` (`stack_id`),
  KEY `current_template_id` (`current_template_id`),
  KEY `ix_resource_root_stack_id` (`root_stack_id`),
  KEY `rsrc_rsrc_prop_data_ref` (`rsrc_prop_data_id`),
  KEY `rsrc_attr_data_ref` (`attr_data_id`),
  CONSTRAINT `resource_ibfk_1` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`),
  CONSTRAINT `resource_ibfk_2` FOREIGN KEY (`current_template_id`) REFERENCES `raw_template` (`id`),
  CONSTRAINT `rsrc_attr_data_ref` FOREIGN KEY (`attr_data_id`) REFERENCES `resource_properties_data` (`id`),
  CONSTRAINT `rsrc_rsrc_prop_data_ref` FOREIGN KEY (`rsrc_prop_data_id`) REFERENCES `resource_properties_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource_data`
--

DROP TABLE IF EXISTS `resource_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` text,
  `redact` tinyint(1) DEFAULT NULL,
  `decrypt_method` varchar(64) DEFAULT NULL,
  `resource_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_resource_id` (`resource_id`),
  CONSTRAINT `fk_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource_properties_data`
--

DROP TABLE IF EXISTS `resource_properties_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_properties_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longtext,
  `encrypted` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` varchar(36) NOT NULL,
  `engine_id` varchar(36) NOT NULL,
  `host` varchar(255) NOT NULL,
  `hostname` varchar(255) NOT NULL,
  `binary` varchar(255) NOT NULL,
  `topic` varchar(255) NOT NULL,
  `report_interval` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `snapshot`
--

DROP TABLE IF EXISTS `snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snapshot` (
  `id` varchar(36) NOT NULL,
  `stack_id` varchar(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_reason` varchar(255) DEFAULT NULL,
  `data` longtext,
  `tenant` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stack_id` (`stack_id`),
  KEY `ix_snapshot_tenant` (`tenant`),
  CONSTRAINT `snapshot_ibfk_1` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `software_config`
--

DROP TABLE IF EXISTS `software_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `software_config` (
  `id` varchar(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `config` longtext,
  `tenant` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_software_config_tenant` (`tenant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `software_deployment`
--

DROP TABLE IF EXISTS `software_deployment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `software_deployment` (
  `id` varchar(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `server_id` varchar(36) NOT NULL,
  `config_id` varchar(36) NOT NULL,
  `input_values` longtext,
  `output_values` longtext,
  `action` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_reason` longtext,
  `tenant` varchar(64) NOT NULL,
  `stack_user_project_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `config_id` (`config_id`),
  KEY `ix_software_deployment_created_at` (`created_at`),
  KEY `ix_software_deployment_tenant` (`tenant`),
  KEY `ix_software_deployment_server_id` (`server_id`),
  CONSTRAINT `software_deployment_ibfk_1` FOREIGN KEY (`config_id`) REFERENCES `software_config` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stack`
--

DROP TABLE IF EXISTS `stack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stack` (
  `id` varchar(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `raw_template_id` int(11) NOT NULL,
  `prev_raw_template_id` int(11) DEFAULT NULL,
  `user_creds_id` int(11) DEFAULT NULL,
  `username` varchar(256) DEFAULT NULL,
  `owner_id` varchar(36) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_reason` longtext,
  `timeout` int(11) DEFAULT NULL,
  `tenant` varchar(256) DEFAULT NULL,
  `disable_rollback` tinyint(1) NOT NULL,
  `stack_user_project_id` varchar(64) DEFAULT NULL,
  `backup` tinyint(1) DEFAULT NULL,
  `nested_depth` int(11) DEFAULT NULL,
  `convergence` tinyint(1) DEFAULT NULL,
  `current_traversal` varchar(36) DEFAULT NULL,
  `current_deps` longtext,
  `parent_resource_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raw_template_id` (`raw_template_id`),
  KEY `prev_raw_template_id` (`prev_raw_template_id`),
  KEY `user_creds_id` (`user_creds_id`),
  KEY `ix_stack_name` (`name`),
  KEY `ix_stack_tenant` (`tenant`(255)),
  KEY `ix_stack_owner_id` (`owner_id`),
  CONSTRAINT `stack_ibfk_1` FOREIGN KEY (`raw_template_id`) REFERENCES `raw_template` (`id`),
  CONSTRAINT `stack_ibfk_2` FOREIGN KEY (`prev_raw_template_id`) REFERENCES `raw_template` (`id`),
  CONSTRAINT `stack_ibfk_3` FOREIGN KEY (`user_creds_id`) REFERENCES `user_creds` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stack_lock`
--

DROP TABLE IF EXISTS `stack_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stack_lock` (
  `stack_id` varchar(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `engine_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`stack_id`),
  CONSTRAINT `stack_lock_ibfk_1` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stack_tag`
--

DROP TABLE IF EXISTS `stack_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stack_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tag` varchar(80) DEFAULT NULL,
  `stack_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stack_id` (`stack_id`),
  CONSTRAINT `stack_tag_ibfk_1` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sync_point`
--

DROP TABLE IF EXISTS `sync_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_point` (
  `entity_id` varchar(36) NOT NULL,
  `traversal_id` varchar(36) NOT NULL,
  `is_update` tinyint(1) NOT NULL,
  `atomic_key` int(11) NOT NULL,
  `stack_id` varchar(36) NOT NULL,
  `input_data` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`entity_id`,`traversal_id`,`is_update`),
  KEY `fk_stack_id` (`stack_id`),
  CONSTRAINT `fk_stack_id` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_creds`
--

DROP TABLE IF EXISTS `user_creds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_creds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `region_name` varchar(255) DEFAULT NULL,
  `decrypt_method` varchar(64) DEFAULT NULL,
  `tenant` varchar(1024) DEFAULT NULL,
  `auth_url` text,
  `tenant_id` varchar(256) DEFAULT NULL,
  `trust_id` varchar(255) DEFAULT NULL,
  `trustor_user_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watch_data`
--

DROP TABLE IF EXISTS `watch_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watch_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `data` longtext,
  `watch_rule_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `watch_rule_id` (`watch_rule_id`),
  CONSTRAINT `watch_data_ibfk_1` FOREIGN KEY (`watch_rule_id`) REFERENCES `watch_rule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watch_rule`
--

DROP TABLE IF EXISTS `watch_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watch_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `rule` longtext,
  `last_evaluated` datetime DEFAULT NULL,
  `stack_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stack_id` (`stack_id`),
  CONSTRAINT `watch_rule_ibfk_1` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-06-27 15:16:39
