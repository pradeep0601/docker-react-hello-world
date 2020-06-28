def builderImage
def productionImage
def ACCOUNT_REGISTRY_PREFIX
def GIT_COMMIT_HASH

pipeline {
  agent any
  stages {
    stage('Checkout source code and Logging into registry') {
      steps {
        echo 'Logging into private ECR registry'
        script {
          GIT_COMMIT_HASH = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
          ACCOUNT_REGISTRY_PREFIX = "999176805196.dkr.ecr.us-east-1.amazonaws.com"
          sh """
          \$(aws ecr get-login --no-include-email --regios us-east-1)
          """
        }
      }
    }

    stage('Make a Builder image') {
      steps {
        echo 'Starting to build the project builder docker image'
        script {
          builderImage = docker.build("${ACCOUNT_REGISTRY_PREFIX}/docker-react-hello-world:${GIT_COMMIT_HASH}", "-f ./Dockerfile.builder .")
          builderImage.push()
          builderImage.push("${env.GIT_BRANCH}")
          builderImage.inside('-v $WORKSPACE:/output -u root') {
              sh """
              cd /output
              echo 'hello from output folder of container'
              yarn build
              """
          }
        }
      }
    }
    
    stage('Unit test') {
        steps {
            echo 'Running unit tests on builder image'
            script {
                builderImage.inside('-v $WORKSPACE:/output -u root') {
                    sh """
                    cd output
                    yarn test
                    """
                }
            }
        }
    }
  }
}