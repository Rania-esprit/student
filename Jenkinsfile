pipeline {
    agent any

    environment {
        // ID du Credential Jenkins pour DockerHub
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        IMAGE_NAME = "raniabahri/student"
        IMAGE_TAG = "latest"
        
        // --- VARIABLES SONARQUBE ---
        SONAR_CREDENTIALS_ID = 'devops_sonar'
        SONAR_SCANNER_NAME = 'student_sonar' // Assurez-vous que ce nom correspond à la configuration SonarQube dans Jenkins
        // ---------------------------
    }

    tools {
        jdk 'jdk17' // Utilise l'installation JDK nommée 'jdk17'
        maven 'maven' // Utilise l'installation Maven nommée 'maven'
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
                // S'assurer que le bon JDK est utilisé pour l'exécution de Maven
                withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                    // 'verify' assure l'exécution des tests unitaires et le packaging
                    sh 'mvn clean verify' 
                }
            }
        }
        
        stage('Sonar Analysis') {
            steps {
                // Utilise la configuration SonarQube enregistrée via l'interface Jenkins
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