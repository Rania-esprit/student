<<<<<<< HEAD
# Utiliser une image JRE pour une taille et une sécurité réduites (Image de base plus légère)
FROM amazoncorretto:17-alpine

# Définir des arguments pour le nom du fichier JAR
ARG JAR_FILE=target/student-management-0.0.1-SNAPSHOT.jar

# Créer un utilisateur non-root pour la sécurité (bonne pratique)
RUN addgroup -S spring && adduser -S spring -G spring
USER spring
=======
# Stage 1 : Build (optionnel, mais Maven le fait déjà ; ici pour complétude)
FROM maven:3.9.6-eclipse-temurin-17 AS builder
>>>>>>> ebde1a9b00d8992554d416386ddc24e34121c872
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src src
RUN mvn clean package -DskipTests

<<<<<<< HEAD
# Copier le fichier JAR
COPY ${JAR_FILE} app.jar

# Exposer le port de l'application
EXPOSE 8089

# Commande de lancement de l'application
=======
# Stage 2 : Runtime (image finale légère)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copie le JAR du stage précédent
COPY --from=builder /app/target/*.jar app.jar
# Expose le port par défaut de Spring Boot
EXPOSE 8080
# Lance l'app
>>>>>>> ebde1a9b00d8992554d416386ddc24e34121c872
ENTRYPOINT ["java", "-jar", "app.jar"]