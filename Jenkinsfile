pipeline {
  agent {
    docker {
      image 'library/mariadb:10.3'
      // run as root user
      args '-u root'
      reuseNode true
    }
  }
  environment {
    DATABASES_HOST = '192.168.50.226'
    DATABASES_PORT = '3306'
    MIGRATION_DIR = 'migrations'
    DOCKER_IMAGE = 'mariadb:latest'
    SSH_CREDENTIALS_ID = 'databases-ssh-key'
    DB_CONTAINER_NAME = 'prod-mariadb'
    DB_CREDENTIALS = credentials('mariadb-credentials')
  }
    stages {
    // stage('Run mariadb client container') {
    //   steps {
    //     sh '''
    //       docker run --rm -d --name ${MARIADB_CLIENT_CONTAINER_NAME} -e MYSQL_ROOT_PASSWORD="mypass" ${MARIADB_CLIENT_IMAGE}
    //     '''
    //   }
    // }
        stage('Connect to mariadb client container and show databases') {
            steps {
                sh """
                    mysql \
                    -h \$DATABASES_HOST \
                    -P \$DATABASES_PORT \
                    -u\$DB_CREDENTIALS_USR \
                    -p\$DB_CREDENTIALS_PSW \
                    -e 'SHOW DATABASES;'
                """
            }
        }

        // stage('Create Migrations Table') {
        //     steps {
        //         sh """
        //             mysql -h ${DATABASES_HOST} -P ${DATABASES_PORT} -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} -e "
        //                 CREATE DATABASE IF NOT EXISTS db_migrations;
        //                 USE db_migrations;
        //                 CREATE TABLE IF NOT EXISTS schema_migrations (
        //                 id INT AUTO_INCREMENT PRIMARY KEY,
        //                 filename VARCHAR(255) NOT NULL UNIQUE,
        //                 applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        //                 );
        //                 SHOW tables;
        //             "
        //         """
        //     }
        // }


    // stage('Apply migrations') {
    //   steps {
    //     sh """
    //       for file in \$(ls ./migrations/*.sql | sort); do
    //         FILENAME=$(basename "$file")
    //         echo "Checking migration: ${FILENAME}"
    //         APPLIED=$(docker exec -i ${MARIADB_CLIENT_CONTAINER_NAME} mysql -h ${DATABASES_HOST} -P ${DATABASES_PORT} -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} db_migrations -e "
    //           SELECT COUNT(*) FROM schema_migrations WHERE filename='${FILENAME}';
    //         " | tail -n 1)
    //         if [ ${APPLIED} -eq "0" ]; then
    //             echo "Applying migration: ${FILENAME}"
    //             docker exec -i ${MARIADB_CLIENT_CONTAINER_NAME} mysql -h ${DATABASES_HOST} -P ${DATABASES_PORT} -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} my-maria-database < \$file
    //             docker exec -i ${MARIADB_CLIENT_CONTAINER_NAME} mysql -h ${DATABASES_HOST} -P ${DATABASES_PORT} -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} db_migrations -e "
    //               INSERT INTO schema_migrations (filename) VALUES ('\$FILENAME');
    //             "
    //         else
    //             echo "Migration already applied: ${FILENAME}"
    //         fi
    //       done
    //     """
    //   }
    // }
    }

    
  // post {
  //   always {
  //     sh '''
  //       docker stop ${MARIADB_CLIENT_CONTAINER_NAME}
  //     '''
  //   }
  // }
}
