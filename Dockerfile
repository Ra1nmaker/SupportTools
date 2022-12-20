FROM maven:3.8-openjdk-11 as build
COPY . /tmp/src
WORKDIR /tmp/src
RUN mvn package

FROM ibmcom/websphere-liberty:full-java11-openj9-ubi

LABEL \
  org.opencontainers.image.authors="Your Name" \
  org.opencontainers.image.source="Your Repository URL"

COPY --chown=1001:0 --from=build /tmp/src/src/main/liberty/config/ /config/
COPY --chown=1001:0 --from=build /tmp/src/target/*.war /config/apps/

RUN ls -al /config/ && ls -al /config/apps/ && cat /config/server.xml
RUN export VERBOSE=true && configure.sh
