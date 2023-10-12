pipeline {
    agent any

    environment {
        DOCKER_REPO = "your-dockerhub-repo/your-image-name"
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Get the latest commit ID
                    def commitId = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
                    // Build the Docker image with commit ID as a tag
                    sh "docker build -t $DOCKER_REPO:$commitId ."
                    
                    // Push the Docker image to DockerHub
                    sh "docker push $DOCKER_REPO:$commitId"
                    
                    // Clean up old Docker images (optional)
                    sh "docker system prune -f --all"
                }
            }
        }
    }
}
