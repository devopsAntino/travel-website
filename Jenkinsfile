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
                    
                    sh "docker build -t $DOCKER_REPO:$commitId ."

                    withCredentials([usernamePassword(credentialsId: 'DockerHub_Credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "docker login -u ${env.DOCKERHUB_USERNAME} -p ${env.DOCKERHUB_PASSWORD}"
                        sh "docker push $DOCKER_REPO:$commitId"
                    }
                }
            }
        }

        // Add the "Delete Old Docker Images" stage here
        stage('Delete Old Docker Images') {
            steps {
                script {
                    def imageList = sh(script: 'docker images --format "{{.ID}} {{.Repository}}:{{.Tag}}"', returnStdout: true).trim()

                    // Split the image list into lines
                    def images = imageList.tokenize('\n')

                    // Create a list of image IDs and their corresponding image names
                    def imageIdsAndNames = [:]

                    images.each { image ->
                        def parts = image.tokenize(' ')
                        if (parts.size() == 2) {
                            imageIdsAndNames[parts[0]] = parts[1]
                        }
                    }

                    // Sort the images by creation date
                    def sortedImages = imageIdsAndNames.sort { a, b ->
                        def creationDateA = sh(script: 'docker inspect --format="{{.Created}}" ' + a.key, returnStdout: true).trim()
                        def creationDateB = sh(script: 'docker inspect --format="{{.Created}}" ' + b.key, returnStdout: true).trim()

                        return creationDateA <=> creationDateB
                    }

                    // Delete old images, keeping the latest 3
                    def imagesToDelete = sortedImages.take(sortedImages.size() - 3)
                    imagesToDelete.each { imageToDelete ->
                        def imageId = imageToDelete.key
                        def imageName = imageToDelete.value
                        sh "docker rmi -f $imageId"
                        echo "Deleted old image: $imageName"
                    }
                }
            }
        }
    }
}
