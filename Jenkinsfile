pipeline {
    agent any

    environment {
        // --- VARIABLES SONARQUBE ---
        // Le Credential ID est 'devops_sonar', ce qui correspond à votre configuration.
        SONAR_CREDENTIALS_ID = 'devops_sonar'
        // ---------------------------
        
        // ID du Credential Jenkins pour DockerHub
       DOCKERHUB_CREDENTIALS = 'dockerhub-cred'
        IMAGE_NAME = "raniabahri/student"
        IMAGE_TAG = "latest"
    }

    tools {
        // Assurez-vous que ces outils sont configurés dans 'Gérer Jenkins -> Outils Globaux'
        jdk 'jdk17'
        maven 'maven'
    }

    stages {

        stage('Checkout from GitHub') {
            steps {
                // Utilise le trait d'union '-' dans l'URL (Corrigé, fonctionne dans le log précédent)
                git branch: 'master',
                    url: 'https://github.com/Rania-esprit/student.git'
            }
        }

        stage('Build Maven') {
            steps {
                // withEnv est essentiel pour résoudre le problème JAVA_HOME sur Windows
                withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Sonar Analysis') {
            steps {
                // CORRECTION CRITIQUE : Utilise le nom de serveur configuré dans Jenkins : 'student_sonar'
                withSonarQubeEnv('student_sonar') { 
                    withCredentials([string(credentialsId: "${SONAR_CREDENTIALS_ID}", variable: 'SONAR_LOGIN')]) {
                        withEnv(["JAVA_HOME=${tool 'jdk17'}"]) {
                            // La commande Maven envoie le code à SonarQube
                            bat "mvn clean verify sonar:sonar -Dsonar.projectKey=student -Dsonar.login=%SONAR_LOGIN%"
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    bat 'echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin'
                    bat "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}