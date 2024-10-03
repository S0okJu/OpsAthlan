FROM openjdk:17-jdk-slim
VOLUME /tmp
EXPOSE 8080
COPY build/libs/app.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]