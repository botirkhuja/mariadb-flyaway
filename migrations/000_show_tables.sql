SHOW tables;

-- SELECT * FROM phone_number_types;

-- SELECT * FROM social_account_platforms;

-- Need to run as root
CREATE DATABASE IF NOT EXISTS `usa4foryou` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Need to run as root
GRANT ALL PRIVILEGES ON `usa4foryou`.* TO 'btiradmusr'@'%';