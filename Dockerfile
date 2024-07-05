# Use a base image with Java and Maven installed
FROM maven:3.9.7-sapmachine-22 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the parent pom.xml file
COPY pom.xml .

# Download all required dependencies into one layer
RUN mvn dependency:go-offline -B

# Copy source files
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Use a smaller base image for the runtime
FROM openjdk:22-slim

WORKDIR /app

# Copy the built artifact from the build stage to the app directory
COPY --from=build /app/target/app.jar /app/

# Set the startup command to run your application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]