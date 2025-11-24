pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        IMAGE_NAME = "raniabahri/student"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {

                    sh 'echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}
