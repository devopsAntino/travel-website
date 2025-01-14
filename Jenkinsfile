pipeline {
    agent any

    environment {
        DOCKER_REPO = "brodevops/travel_website"
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    def commitId = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
                    // Build the Docker image with commit ID and latest tags
                    sh "docker build -t $DOCKER_REPO:$commitId -t $DOCKER_REPO:latest ."
                    
                    // Log in to DockerHub using credentials
                    withCredentials([usernamePassword(credentialsId: 'DockerHub_Credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "docker login -u ${env.DOCKERHUB_USERNAME} -p ${env.DOCKERHUB_PASSWORD}"
                        sh "docker push $DOCKER_REPO:$commitId"
                        sh "docker push $DOCKER_REPO:latest"
                    }
                }
            }
        }
        
        stage('Clean Up Old Docker Images') {
            steps {
                sh "docker image prune -f -a --filter 'until=72h'"
            }
        }
    }
}
