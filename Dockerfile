FROM maven:3.6-jdk-8
WORKDIR /usr/src
COPY . /usr/src
RUN mvn clean package -e

FROM oracle/graalvm-ce:1.0.0-rc9 as BUILD
WORKDIR /usr/src
COPY . /usr/src
RUN ls -lath /usr/src/target/
COPY /docker-graal-build.sh /usr/src
RUN ./docker-graal-build.sh
RUN ls -lath

FROM alpine:3.8
CMD ["jpc-graal"]
COPY --from=BUILD /usr/src/jpc-graal /usr/local/bin/
RUN chmod +x /usr/local/bin/jpc-graal
