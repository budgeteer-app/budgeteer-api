# Step 1: Build the application
FROM gradle:7.4-jdk17 AS build

# Set the working directory
WORKDIR /app

# Copy the Gradle wrapper and necessary build files
COPY gradlew /app/
COPY gradle /app/gradle
COPY build.gradle.kts settings.gradle.kts /app/
COPY gradle/wrapper/gradle-wrapper.properties /app/gradle/wrapper/

# Copy the source code
COPY src /app/src

# Ensure gradlew has execution permissions
RUN chmod +x ./gradlew

# Build the application
RUN ./gradlew build --no-daemon -x test

# Step 2: Create the final image to run the application
FROM openjdk:17-slim

# Set the working directory
WORKDIR /app
RUN addgroup dockergroup; adduser --ingroup dockergroup --disabled-password --system --shell /bin/false dockeruser

RUN mkdir -p /app/logs && chown -R dockeruser:dockergroup /app/logs
# Copy the built application from the previous stage
COPY --from=build /app/build/libs/*.jar /app/

# Expose the application port (default for Spring Boot)
EXPOSE 8080

USER dockeruser
# Run the application
ENTRYPOINT ["java", "-jar", "/app/budgeteer-0.0.1-SNAPSHOT.jar"]



