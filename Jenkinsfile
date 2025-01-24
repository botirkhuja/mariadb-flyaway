pipeline {
  agent any
  environment {
    DATABASES_HOST = '10.10.10.101'
    MIGRATION_DIR = 'migrations'
    DOCKER_IMAGE = 'mariadb:latest'
    SSH_CREDENTIALS_ID = 'databases-ssh-key'
  }
  stages {
    stage('Test Connection via SSH') {
      steps {
        // script {
        //   def remote = [:]
        //   remote.name = 'databases'
        //   remote.host = DATABASES_HOST

        withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
        //     remote.user = SSH_USER
        //     remote.identityFile = SSH_KEY
        //     remote.allowAnyHosts = true
        //     sshCommand remote: remote, command: """
        //       echo "SSH Connection Successful" && ls -la
        //       touch /tmp/test.txt
        //     """
        //   }
          sshCommand remote: [name: 'databases', host: DATABASES_HOST, allowAnyHosts: true, user: SSH_USER, identityFile: SSH_KEY], command: """
            echo "SSH Connection Successful"
          """
        }
      }
    }
    stage('Copy Migration Files') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
          sshCommand remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], command: """
            mkdir -p /tmp/migrations
          """
          sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "${MIGRATION_DIR}", into: '/tmp'
        }
      }
    }
    stage('Create Migrations Table') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
          sshCommand remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], command: """
            docker exec -i ${DB_CONTAINER_NAME} mysql -uroot -proot -e "
              CREATE TABLE IF NOT EXISTS schema_migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                filename VARCHAR(255) NOT NULL UNIQUE,
                applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
              );
            "
          """
        }
      }
    }
  }
}