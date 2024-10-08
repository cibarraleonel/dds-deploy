# syntax = docker/dockerfile:1.2
#
# Build stage
#
FROM maven:3.8.6-openjdk-18 AS build
COPY . .
RUN mvn clean package assembly:single -DskipTests

#
# Package stage
#
FROM openjdk:17-jdk-slim
COPY --from=build /target/javalin-deploy-1.0-SNAPSHOT-jar-with-dependencies.jar libros.jar
# ENV PORT=5432
EXPOSE 5432
CMD ["java","-classpath","libros.jar","ar.edu.dds.libros.AppLibros"]
