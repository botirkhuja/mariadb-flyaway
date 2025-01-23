pipeline {
  agent any
  environment {
    DATABASES_HOST = '10.10.10.101'
    MIGRATION_DIR = './migration'
    DOCKER_IMAGE = 'mariadb:latest'
    SSH_CREDENTIALS_ID = 'databases-ssh-key'
  }
  stages {
    stage('Test Connection via SSH') {
      steps {
    node {
    def remote = [:]
    remote.name = "jenkins-agent-1"
    remote.host = DATABASES_HOST
    remote.allowAnyHosts = true
      withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIALS_ID}", keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
        remote.user = SSH_USER
        remote.identityFile = SSH_KEY
            sshCommand remote: remote, command: """
              echo "SSH Connection Successful"
            """
          }
        }
      }
    }
    stage('Copy Migration Files') {
      steps {
        sshCommand remote: [host: "${DATABASES_HOST}", credentialsId: "${SSH_CREDENTIALS_ID}"], command: """
            mkdir -p /tmp/migrations
        """
        sh """
            scp -r ${MIGRATION_DIR}/* ${DATABASES_HOST}:/tmp/migrations
        """
      }
  }
  }
}