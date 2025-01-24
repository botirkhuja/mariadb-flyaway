node {
  def DATABASES_HOST = '10.10.10.101'
  def  MIGRATION_DIR = 'migrations'
  def  DOCKER_IMAGE = 'mariadb:latest'
  def  SSH_CREDENTIALS_ID = 'databases-ssh-key'
  def  DB_CONTAINER_NAME = 'prod-mariadb'
  
  def remote = [:]
  remote.name = "databases"
  remote.host = DATABASES_HOST
  remote.allowAnyHosts = true

  try {
     withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
      remote.user = SSH_USER
      remote.identityFile = SSH_KEY
      stage('Test Connection via SSH') {
        sshCommand remote:  remote, command: """
          echo "Connection to ${DATABASES_HOST} successful"
        """
      }
     }
  }  catch (Exception e) {
        // Handle any failures
        echo "Pipeline failed: ${e.message}"
        throw e // Rethrow to mark the build as failed
    }
}