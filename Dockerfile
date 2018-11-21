#######################################
## 1. BUILD JAR WITH MAVEN
FROM maven:3.6-jdk-8 as BUILD
WORKDIR /usr/src
COPY . /usr/src
RUN mvn clean package -e
#######################################
## 2. BUILD NATIVE IMAGE WITH GRAAL
FROM oracle/graalvm-ce:1.0.0-rc9 as NATIVE_BUILD
WORKDIR /usr/src
COPY --from=BUILD /usr/src/ /usr/src
RUN ls -lath /usr/src/target/
COPY /docker-graal-build.sh /usr/src
RUN ./docker-graal-build.sh
RUN ls -lath
#######################################
## 3. BUILD DOCKER RUNTIME IMAGE
FROM alpine:3.8
CMD ["jpc-graal"]
COPY --from=NATIVE_BUILD /usr/src/jpc-graal /usr/local/bin/
RUN chmod +x /usr/local/bin/jpc-graal
#######################################
