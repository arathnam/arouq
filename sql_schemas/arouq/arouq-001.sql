CREATE DATABASE IF NOT EXISTS `arouq`;

USE `arouq`;

GRANT ALL ON `arouq`.* TO 'arouq_rw'@'%';
GRANT ALL ON `arouq`.* TO 'arouq_rw'@'localhost';
GRANT SELECT ON `arouq`.* TO 'arouq_r'@'%';
GRANT SELECT ON `arouq`.* TO 'arouq_r'@'localhost';

CREATE TABLE IF NOT EXISTS `db_updates` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `applied_at` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO db_updates (`name`) VALUES ('arouq-001.sql');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `added_at` timestamp NULL default NULL,
    `last_modified_at` timestamp NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `answers`;
CREATE TABLE `answers` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `owning_user_id` int(10) UNSIGNED,
    `text` varchar(1024) NOT NULL,
    `added_at` timestamp NULL default NULL,
    `last_modified_at` timestamp NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_answers_owning_user_id` FOREIGN KEY (`owning_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    INDEX `in_added_at` (`added_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `owning_user_id` int(10) UNSIGNED NOT NULL,
    `answer_id` int(10) UNSIGNED NOT NULL,
    `text` varchar(255) NOT NULL,
    `added_at` timestamp NULL default NULL,
    `last_modified_at` timestamp NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_questions_owning_user_id` FOREIGN KEY (`owning_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_questions_answer_id` FOREIGN KEY (`answer_id`) REFERENCES `answers`(`id`) ON DELETE CASCADE,
    INDEX `in_added_at` (`added_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
