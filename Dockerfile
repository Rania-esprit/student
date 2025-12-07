# Utiliser une image JRE pour une taille et une sécurité réduites (Image de base plus légère)
FROM amazoncorretto:17-alpine

# Définir des arguments pour le nom du fichier JAR
ARG JAR_FILE=target/student-management-0.0.1-SNAPSHOT.jar

# Créer un utilisateur non-root pour la sécurité (bonne pratique)
RUN addgroup -S spring && adduser -S spring -G spring
USER spring
WORKDIR /app

# Copier le fichier JAR
COPY ${JAR_FILE} app.jar

# Exposer le port de l'application
EXPOSE 8089

# Commande de lancement de l'application
ENTRYPOINT ["java", "-jar", "app.jar"]