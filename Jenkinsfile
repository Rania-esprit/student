pipeline {
    agent any

    environment {
        // ID du Credential Jenkins pour DockerHub
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        IMAGE_NAME = "raniabahri/student"
        IMAGE_TAG = "latest"
        
        // --- VARIABLES SONARQUBE ---
        SONAR_CREDENTIALS_ID = 'sonardevops'
        SONAR_SCANNER_NAME = 'student_sonar' // Nom du serveur SonarQube configuré dans Jenkins
        // ---------------------------
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

        stage('Build & Test Maven') {
            steps {
                // IMPORTANT : -DskipTests est utilisé pour éviter l'échec de la connexion MySQL sur l'agent Jenkins.
                // Cela vous permet de progresser vers les étapes Docker.
                withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                    sh 'mvn clean verify -DskipTests' 
                }
            }
        }
        
        stage('Sonar Analysis') {
            steps {
                // Utilisation de la méthode Jenkins standard et sécurisée pour SonarQube
                withSonarQubeEnv("${SONAR_SCANNER_NAME}") {
                    withCredentials([string(credentialsId: "${SONAR_CREDENTIALS_ID}", variable: 'SONAR_LOGIN')]) {
                        withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                            sh '''
                            mvn sonar:sonar \
                            -Dsonar.projectKey=student-management \
                            -Dsonar.login=$SONAR_LOGIN
                            '''
                        }
                    }
                }
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
                    // Connexion sécurisée à Docker Hub via stdin
                    sh '''
                    echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }
}