FROM gradle:8 as builder
WORKDIR /usr/src/app
COPY . .
RUN gradle build

FROM openjdk:17-jdk-alpine
WORKDIR /usr/src/app
EXPOSE 8080
COPY --from=builder /usr/src/app/app/build/libs/app-all.jar app-all.jar
ENTRYPOINT ["java", "-jar", "app-all.jar"]