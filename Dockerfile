FROM openjdk:17-alpine

ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} /opt/maven-docker/spring-petclinic.jar

ENTRYPOINT ["java", "-jar", "/opt/maven-docker/spring-petclinic.jar"]
