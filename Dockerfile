# Image de base avec Java 17 (Temurin remplace OpenJDK)
FROM eclipse-temurin:17-jdk

# Répertoire de travail
WORKDIR /app

# Copier le jar généré

COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port Spring Boot
EXPOSE 8089

# Commande de lancement
ENTRYPOINT ["java", "-jar", "app.jar"]

