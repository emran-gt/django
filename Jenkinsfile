pipeline {
    agent {
        node {
            label 'jenkins'
        }
    }
    triggers {
        pollSCM('* * * * *')
    }
    environment{
        DOCKER_TAG = getDockerTag()
    }
    options {
     buildDiscarder(logRotator(numToKeepStr: '5'))
 }

    stages{

        stage('Build Image'){
            steps{
                sh "docker build . -t rokonzaman/django-qa:${DOCKER_TAG}"
            }
        }

        stage('Push Image'){
            steps{
            withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerHubPwd')]) {
                sh "docker login -u rokonzaman -p ${dockerHubPwd}"
                sh "docker push rokonzaman/django-qa:${DOCKER_TAG}"
            }
        }
    }

        stage('Remove Image'){
            steps{
                sh "docker rmi rokonzaman/django-qa:${DOCKER_TAG}"
            }
        }

        stage('Deploy to k8s'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sh " kubectl apply -f django-qa.yaml"
            }
        }
    }
}


def getDockerTag(){
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
