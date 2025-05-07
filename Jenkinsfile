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
        stage('Make every shell script executable') {
            steps {
                sh '''
                    chmod +x *.sh
                '''
            }
        }
        stage('Execute config shell script') {
            steps {
                sh '''
                    ./config_mariadb.sh
                '''
            }
        }
        stage('Connect to databases') {
            steps {
                sh '''
                    mysql my-maria-database -e "
                        SHOW TABLES;
                    "
                '''
            }
        }

        stage('create migrations table') {
            steps {
                sh '''
                    mysql my-maria-database -e "
                        CREATE TABLE IF NOT EXISTS schema_migrations (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            filename VARCHAR(255) NOT NULL UNIQUE,
                            applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        );
                    "
                '''
            }
        }

        stage('Apply migrations') {
            steps {
                sh '''
                    ./execute_migrations.sh
                '''
            }
        }
    }

// post {
//   always {
//     sh '''
//       docker stop ${MARIADB_CLIENT_CONTAINER_NAME}
//     '''
//   }
// }
}
