# Random Dog Facts

Basic client for fetching random dog facts from `dogapi.dog`.

## Running

Running locally with command `./gradlew run`. This will open server to port 8080.

## Building

Build with command `./gradlew build`. Ready .jar for running is found from app/build/libs/app-all.jar. Built .jar can be runned with command `java -jar app/build/libs/app-all.jar`.

## Docker

Run with `docker run -p "8080:8080" tualanen/dogfacts`. Image is available from Docker Hub. App will run on `localhost:8080`.

If doing locally, build image with `docker build . -t dogfacts`. Run with `docker run -p "8080:8080" dogfacts`.
