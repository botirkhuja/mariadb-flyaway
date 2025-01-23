pipeline {
  agent any
  environment {
    DATABASES_HOST = '10.10.10.101'
    MIGRATION_DIR = './migration'
    DOCKER_IMAGE = 'mariadb:latest'
    SSH_CREDENTIALS_ID = 'databases-ssh-key'
  }
  stages {
    stage('Test Connection via PING') {
      steps {
        script {
          sh 'ping -c 1 $DATABASES_HOST'
        }
      }
    }
    stage('Test Connection via SSH') {
      steps {
        script {
          sshCommand remote: [host: "${DATABASES_HOST}", credentialsId: "${SSH_CREDENTIALS_ID}"], command: """
            echo "SSH Connection Successful"
          """
        }
      }
    }
  }
}