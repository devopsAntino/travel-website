pipeline {
    agent any

    environment {
        DOCKER_REPO = "brodevops/travel_website"
        SSHUSERNAME = "ubuntu"

    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    def commitId = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
                    sh "docker build -t $DOCKER_REPO:$commitId ."

                    withCredentials([usernamePassword(credentialsId: 'DockerHub_Credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "docker login -u ${env.DOCKERHUB_USERNAME} -p ${env.DOCKERHUB_PASSWORD}"
                        sh "docker push $DOCKER_REPO:$commitId"
                    }
                }
            }
        }
    }
}
