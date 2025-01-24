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
      // remote.failOnError = false

      stage('Test Connection via SSH') {
        def commanResult = sshCommand remote:  remote, command: """
          rm -rf ~/workdir/tmp 
          mkdir -p ~/workdir/tmp/migrations
          echo "Connection to ${DATABASES_HOST} successful"
        """
        echo "Command Result: ${commanResult}"
      }

      stage('Copy Migration Files') {
        remote.fileTransfer = 'scp'
        sshPut remote: remote, from: "${MIGRATION_DIR}", into: '~/workdir/tmp'
        sshPut remote: remote, from: "build.sh", into: '~/workdir/tmp'
      }

      stage('Create Migrations Table') {
        def commanResult = sshCommand remote: remote, command: """
          cd ~/workdir/tmp
          chmod +x build.sh
          ./build.sh
        """
        echo "Command Result: ${commanResult}"
      }
    }
  }  catch (Exception e) {
      // Handle any failures
      echo "Pipeline failed: ${e.message}"
      throw e // Rethrow to mark the build as failed
  }
}