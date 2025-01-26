pipeline {
  agent any
  environment {
    DATABASES_HOST = '10.10.10.101'
    DATABASES_PORT = '3306'
    MIGRATION_DIR = 'migrations'
    DOCKER_IMAGE = 'mariadb:latest'
    SSH_CREDENTIALS_ID = 'databases-ssh-key'
    DB_CONTAINER_NAME = 'prod-mariadb'
    DB_CREDENTIALS = credentials('mariadb-credentials')
    MARIADB_CLIENT_CONTAINER_NAME = 'mariadb-client'
    MARIADB_CLIENT_IMAGE = 'library/mariadb:10.3'
  }
  stages {
    stage('Run mariadb client container') {
      steps {
        sh '''
          docker run --rm -d --name ${MARIADB_CLIENT_CONTAINER_NAME} -e MYSQL_ROOT_PASSWORD="mypass" ${MARIADB_CLIENT_IMAGE}
        '''
      }
    }
    stage('Connect to mariadb client container and show databases') {
      steps {
        sh '''
          docker exec ${MARIADB_CLIENT_CONTAINER_NAME} mysql -h ${DATABASES_HOST} -P ${DATABASES_PORT} -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} -e "SHOW DATABASES;"
        '''
      }
    }
    
    stage('Create Migrations Table') {
      steps {
        sh '''
          docker exec ${MARIADB_CLIENT_CONTAINER_NAME} mysql -h ${DATABASES_HOST} -P ${DATABASES_PORT} -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} -e "
            CREATE DATABASE IF NOT EXISTS db_migrations;
            USE db_migrations;
            CREATE TABLE IF NOT EXISTS schema_migrations (
              id INT AUTO_INCREMENT PRIMARY KEY,
              filename VARCHAR(255) NOT NULL UNIQUE,
              applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            SHOW tables;
          "
        '''
      }
    }
stage('Debug') {
  steps {
    sh 'pwd && ls -la'
  }
}
    stage('Apply migrations') {
      steps {
        sh '''#!/bin/bash
          ls ./migrations/*.sql | sort | while read -r file; do
            FILENAME=$(basename "$file")
            echo "Applying migration: ${FILENAME}"
            APPLIED=$(docker exec -i ${DB_CONTAINER_NAME} mariadb -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} -e "
              USE db_migrations;
              SELECT COUNT(*) FROM schema_migrations WHERE filename='${FILENAME}';
            " | tail -n 1)
            echo "APPLIED: ${APPLIED}"
            if [ APPLIED -eq 0 ]; then
                echo "Applying migration: ${FILENAME}"
                # docker exec -i ${DB_CONTAINER_NAME} mysql -uroot -proot < \$file
                # docker exec -i ${DB_CONTAINER_NAME} mysql -uroot -proot -e "
                # INSERT INTO schema_migrations (filename) VALUES ('\$FILENAME');
                # "
            else
                echo "Migration already applied: ${FILENAME}"
            fi
          done
        '''
      }
    }

  //   stage('Create Migrations Table') {
  //     steps {
  //       sshagent(credentials: [SSH_CREDENTIALS_ID]) {
  //         sh '''#!/bin/bash
  //           ssh jenkins@${DATABASES_HOST} <<EOF
  //             cd /tmp
  //             export DB_CONTAINER_NAME=${DB_CONTAINER_NAME}
  //             export DB_CREDENTIALS_USR=${DB_CREDENTIALS_USR}
  //             export DB_CREDENTIALS_PSW=${DB_CREDENTIALS_PSW}
  //             docker exec ${DB_CONTAINER_NAME} mariadb -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} -e "
  //               CREATE DATABASE IF NOT EXISTS db_migrations;
  //               SHOW databases;
  //               USE db_migrations;
  //               CREATE TABLE IF NOT EXISTS schema_migrations (
  //                 id INT AUTO_INCREMENT PRIMARY KEY,
  //                 filename VARCHAR(255) NOT NULL UNIQUE,
  //                 applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  //               );
  //               SHOW tables;
  //             "
  //         '''
  //       }
  //     }
  //   }
  //   stage('Apply migrations') {
  //     steps {
  //       sshagent(credentials: [SSH_CREDENTIALS_ID]) {
  //         sh '''#!/bin/bash
  //           ssh jenkins@${DATABASES_HOST} <<EOF
  //             export DB_CONTAINER_NAME=${DB_CONTAINER_NAME}
  //             export DB_CREDENTIALS_USR=${DB_CREDENTIALS_USR}
  //             export DB_CREDENTIALS_PSW=${DB_CREDENTIALS_PSW}
  //             cd /tmp
  //             chmod +x migrate.sh
  //             ./migrate.sh
  //         '''
  //       }
  //     }
  //   }
  }
  post {
    always {
      sh '''
        docker stop ${MARIADB_CLIENT_CONTAINER_NAME}
      '''
    }
  }
}