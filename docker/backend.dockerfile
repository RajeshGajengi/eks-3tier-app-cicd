# Stage 1: Build the application
FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /app

COPY . .

# Build the JAR without running tests
RUN rm -f src/main/resources/application.properties && \
    cp -f application.properties src/main/resources/application.properties && \
    mvn clean package -DskipTests

# Stage 2: Create runtime image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the built JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8081

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
