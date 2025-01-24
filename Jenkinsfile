pipeline {
  agent any
  environment {
    DATABASES_HOST = '10.10.10.101'
    MIGRATION_DIR = 'migrations'
    DOCKER_IMAGE = 'mariadb:latest'
    SSH_CREDENTIALS_ID = 'databases-ssh-key'
    DB_CONTAINER_NAME = 'prod-mariadb'
  }
  stages {
    stage('Test Connection via SSH') {
      steps {
        sshagent(credentials: ['databases-ssh-key']) {
          sh '''
            [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
            ssh-keyscan -t rsa,dsa ${DATABASES_HOST} >> ~/.ssh/known_hosts
            ssh jenkins@${DATABASES_HOST} <<EOF
              echo "SSH Connection Successful"
              ls -la 
          '''
        }
      }
      // steps {
      //   // script {
      //   //   def remote = [:]
      //   //   remote.name = 'databases'
      //   //   remote.host = DATABASES_HOST

      //   withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
      //   //     remote.user = SSH_USER
      //   //     remote.identityFile = SSH_KEY
      //   //     remote.allowAnyHosts = true
      //   //     sshCommand remote: remote, command: """
      //   //       echo "SSH Connection Successful" && ls -la
      //   //       touch /tmp/test.txt
      //   //     """
      //   //   }
      //     sshCommand remote: [name: 'databases', host: DATABASES_HOST, allowAnyHosts: true, user: SSH_USER, identityFile: SSH_KEY], command: """
      //       echo "SSH Connection Successful"
      //     """
      //   }
      // }
    }
    // stage('Copy Migration Files') {
    //   steps {
    //     withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
    //       sshCommand remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], command: """
    //         mkdir -p /tmp/migrations
    //       """
    //       sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "${MIGRATION_DIR}", into: '/tmp'
    //       sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "build.sh", into: '/tmp'
    //     }
    //   }
    // }
    // stage('Create Migrations Table') {
    //   steps {
    //     // sshagent(credentials: [SSH_CREDENTIALS_ID]) {
    //     //   sh '''
    //     //     [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
    //     //     ssh-keyscan -t rsa,dsa ${DATABASES_HOST} >> ~/.ssh/known_hosts
    //     //     ssh user@${DATABASES_HOST}
    //     //   '''
    //     // }
    //     withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
         
    //       sshCommand remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true, agent: true], command: """
    //         chmod +x /tmp/build.sh
    //         /tmp/build.sh
    //       """
    //     }
    //   }
    // }
  }
}