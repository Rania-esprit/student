pipeline {
    agent any

    environment {
        // ID du Credential Jenkins pour DockerHub
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        IMAGE_NAME = "raniabahri/student"
        IMAGE_TAG = "latest"
        
        // --- VARIABLES SONARQUBE ---
        SONAR_CREDENTIALS_ID = 'devops_sonar'
        SONAR_SCANNER_NAME = 'student_sonar' // Nom du serveur SonarQube configuré dans Jenkins
        // ---------------------------
    }

    tools {
        jdk 'jdk17'
        maven 'maven' // ASSUMANT QUE VOUS AVEZ RENOMMÉ L'OUTIL JENKINS DE 'M2_HOME' À 'maven'
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
                // Utilise le JDK 'jdk17' et le Maven 'maven' configurés
                withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                    sh 'mvn clean verify'
                }
            }
        }
        
        stage('Sonar Analysis') {
            steps {
                // Utilise la configuration SonarQube enregistrée dans Jenkins (nom du serveur: student_sonar)
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
                    sh '''
                    # Connexion à Docker Hub
                    echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    
                    # Poussée de l'image
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }
}