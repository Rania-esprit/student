# Stage 1 : Build (optionnel, mais Maven le fait déjà ; ici pour complétude)
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src src
RUN mvn clean package -DskipTests

# Stage 2 : Runtime (image finale légère)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copie le JAR du stage précédent
COPY --from=builder /app/target/*.jar app.jar
# Expose le port par défaut de Spring Boot
EXPOSE 8080
# Lance l'app
ENTRYPOINT ["java", "-jar", "app.jar"]