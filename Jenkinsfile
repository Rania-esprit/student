pipeline {
    agent any

    environment {
        // --- VARIABLES SONARQUBE ---
        SONAR_CREDENTIALS_ID = 'devops_sonar'
        // ---------------------------
        
        // ID du Credential Jenkins pour DockerHub
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        IMAGE_NAME = "raniabahri/student"
        IMAGE_TAG = "latest"
    }

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    stages {

        stage('Checkout from GitHub') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/Rania-esprit/student.git'
            }
        }

        stage('Build Maven') {
            steps {
                // IMPORTANT: Replaced 'bat' with 'sh' for Linux compatibility
                withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('student_sonar') { 
                    withCredentials([string(credentialsId: "${SONAR_CREDENTIALS_ID}", variable: 'SONAR_LOGIN')]) {
                        withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                            // IMPORTANT: Replaced 'bat' with 'sh' and changed %VAR% to $VAR
                            sh "mvn clean verify sonar:sonar -Dsonar.projectKey=student -Dsonar.login=$SONAR_LOGIN"
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // IMPORTANT: Replaced 'bat' with 'sh'
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
                    // IMPORTANT: Replaced 'bat' with 'sh' and adjusted login syntax for Linux
                    sh 'echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin'
                    // IMPORTANT: Replaced 'bat' with 'sh'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}