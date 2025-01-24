#!/bin/bash

mariadbAddress=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${DB_CONTAINER_NAME}` 
echo "MariaDB Address: ${mariadbAddress}"

echo $DB_CREDENTIALS_USR
echo $DB_CREDENTIALS_PSW

mysql -h ${mariadbAddress} -u ${MARIA_DB_USER} -proot -e "
              CREATE DATABASE IF NOT EXISTS db_migrations;
              USE db_migrations;
              CREATE TABLE IF NOT EXISTS schema_migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                filename VARCHAR(255) NOT NULL UNIQUE,
                applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
              );
            "