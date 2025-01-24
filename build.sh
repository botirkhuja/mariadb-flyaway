#!/bin/bash

mariadbAddress=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${DB_CONTAINER_NAME}` 
echo "MariaDB Address: ${mariadbAddress}"

mysql -h ${mariadbAddress} --user=${DB_CREDENTIALS_USR} root --password=${DB_CREDENTIALS_PSW} -e "
              CREATE DATABASE IF NOT EXISTS db_migrations;
              USE db_migrations;
              CREATE TABLE IF NOT EXISTS schema_migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                filename VARCHAR(255) NOT NULL UNIQUE,
                applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
              );
            "