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

    // stage('Run mariadb client container') {
    //   steps {
    //     script {
    //       docker.image(MARIADB_CLIENT_IMAGE).run('-d --name ${MARIADB_CLIENT_CONTAINER_NAME} -e MYSQL_ROOT_PASSWORD="mypass"')
    //     }
    //   }
    // }
    // stage('Connect to mariadb client container') {
    //   steps {
    //     script {
    //       docker.image(MARIADB_CLIENT_IMAGE).inside("--entrypoint /bin/bash --workdir /tmp --name ${MARIADB_CLIENT_CONTAINER_NAME} ${MARIADB_CLIENT_CONTAINER_NAME}") {
    //         sh '''
    //           mysql -h ${DATABASES_HOST} -u root -pmypass
    //         '''
    //       }
    //     }
    //   }
    // }
  //   stage('Test Connection via SSH') {
  //     steps {
  //       sshagent(credentials: [SSH_CREDENTIALS_ID]) {
  //         sh '''
  //           [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
  //           ssh-keyscan -t rsa,dsa ${DATABASES_HOST} >> ~/.ssh/known_hosts
  //           ssh jenkins@${DATABASES_HOST} <<EOF
  //             echo "SSH Connection Successful"
  //             mkdir -p /tmp/migrations 
  //         '''
  //       }
  //     }
  //   }
  //   stage('Copy Migration Files') {
  //     steps {
  //       withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
  //         sshagent(credentials: [SSH_CREDENTIALS_ID]) {
  //           sh '''
  //             scp -r ${MIGRATION_DIR} ${SSH_USER}@${DATABASES_HOST}:/tmp
  //             scp build.sh ${SSH_USER}@${DATABASES_HOST}:/tmp
  //             scp migrate.sh ${SSH_USER}@${DATABASES_HOST}:/tmp
  //           '''
  //         }
  //         // sshCommand remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], command: """
  //         //   mkdir -p /tmp/migrations
  //         // """
  //         // sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "${MIGRATION_DIR}", into: '/tmp'
  //         // sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "build.sh", into: '/tmp'
  //       }
  //     }
  //   }
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
      stage('Remove mariadb client container') {
        steps {
          sh '''
            docker stop ${MARIADB_CLIENT_CONTAINER_NAME}
          '''
        }
      }
      // sh '''
      //   docker stop ${MARIADB_CLIENT_CONTAINER_NAME}
      //   docker rm ${MARIADB_CLIENT_CONTAINER_NAME}
      // '''
    }
  }
}