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
        sshagent(credentials: [SSH_CREDENTIALS_ID]) {
          sh '''
            [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
            ssh-keyscan -t rsa,dsa ${DATABASES_HOST} >> ~/.ssh/known_hosts
            ssh jenkins@${DATABASES_HOST} <<EOF
              echo "SSH Connection Successful"
              mkdir -p /tmp/migrations 
          '''
        }
      }
    }
    stage('Copy Migration Files') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
          sshagent(credentials: [SSH_CREDENTIALS_ID]) {
            sh '''
              scp -r ${MIGRATION_DIR} ${SSH_USER}@${DATABASES_HOST}:/tmp
              scp build.sh ${SSH_USER}@${DATABASES_HOST}:/tmp
            '''
          }
          // sshCommand remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], command: """
          //   mkdir -p /tmp/migrations
          // """
          // sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "${MIGRATION_DIR}", into: '/tmp'
          // sshPut remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true], from: "build.sh", into: '/tmp'
        }
      }
    }
    stage('Create Migrations Table') {
      steps {
        sshagent(credentials: [SSH_CREDENTIALS_ID]) {
          sh '''
            ssh jenkins@${DATABASES_HOST} <<EOF
            cd /tmp
            chmod +x build.sh
            ./build.sh
          '''
        }
        // withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
         
        //   sshScript remote: [name: 'databases', host: DATABASES_HOST, user: SSH_USER, identityFile: SSH_KEY, allowAnyHosts: true, agent: true], script: "build.sh"
        // }
      }
    }
  }
}