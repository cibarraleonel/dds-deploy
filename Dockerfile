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

# Instalar dependencias necesarias para Docker Compose
RUN apt-get update && apt-get install -y \
    curl \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Docker Compose
RUN pip3 install docker-compose

# Copiar el archivo jar de la aplicación desde la etapa de build
COPY --from=build /target/javalin-deploy-1.0-SNAPSHOT-jar-with-dependencies.jar libros.jar

# Copiar el archivo docker-compose.yml al contenedor
COPY docker-compose.yml /app/docker-compose.yml

# Establecer el directorio de trabajo
WORKDIR /app

# Exponer el puerto que usará la aplicación Java
EXPOSE 5432

# Comando para ejecutar Docker Compose y luego la aplicación Java
CMD ["sh", "-c", "docker-compose up -d && java -classpath libros.jar ar.edu.dds.libros.AppLibros"]
