FROM maven:3.8.3-openjdk-17
COPY . /opt/
WORKDIR /opt
RUN rm -f src/main/resources/application.properties && \
   cp -f application.properties src/main/resources/application.properties && \
    mvn clean package -DskipTests
WORKDIR target/
EXPOSE 8081
ENTRYPOINT ["java","-jar"]
CMD ["student-registration-backend-0.0.1-SNAPSHOT.jar"]

