FROM ubuntu:18.04 AS builder

ENV KAFKA_VERSION="3.1.0"
ENV SCALA_VERSION="2.13"
ENV KAFKA_HOME="/opt/kafka"
ENV PATH=${PATH}:${KAFKA_HOME}/bin
ENV KAFKA_CONFIG=${KAFKA_HOME}/config/kraft/server.properties
ENV KAFKA_CONSOLE_LOG=${KAFKA_HOME}/logs/helk-kafka.log
ENV KAFKA_USER=kafka

# Install Kafka
RUN apt-get update && apt-get -y install unzip wget \
&& wget -O /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
&& tar xvzf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
&& rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
&& ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
&& rm -rf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz


#
FROM openjdk:11-jre-slim-buster

ENV KAFKA_VERSION="3.1.0"
ENV KAFKA_HOME="/opt/kafka"
ENV KAFKA_LOGS_HOME="/data/kafka"
ENV PATH=${PATH}:${KAFKA_HOME}/bin
ENV KAFKA_CONFIG=${KAFKA_HOME}/config/kraft/server.properties
ENV KAFKA_USER=kafka
ENV KAFKA_GID=910
ENV KAFKA_UID=910
ENV KAFKA_CLUSTER_ID="MTM2NkYwNjgyQTBGNEZBOU"

LABEL name="kafka-kraft" version=${KAFKA_VERSION} \
 org.chiwoo.image.created="2022-03" \
 org.chiwoo.image.version="jre11-3.1.0" \
 org.chiwoo.image.title="kafka-kraft" \
 org.chiwoo.image.description="Dockerfile for Kafka kraft metadata mode (KRaft) - without Zookeeper" \
 org.chiwoo.image.source="https://github.com/"

COPY --from=builder ${KAFKA_HOME} ${KAFKA_HOME}

COPY entrypoint.sh ${KAFKA_HOME}/

RUN apt-get update && apt-get install -y sudo \
&& groupadd -g ${KAFKA_GID} ${KAFKA_USER} \
&& useradd -u ${KAFKA_UID} -g ${KAFKA_GID} -d ${KAFKA_HOME} --no-create-home -s /bin/bash ${KAFKA_USER} \
&& echo "${KAFKA_USER}  ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers \
&& mkdir -p ${KAFKA_LOGS_HOME} \
&& chown -R ${KAFKA_USER}:${KAFKA_USER} ${KAFKA_HOME} \
&& chown -R ${KAFKA_USER}:${KAFKA_USER} ${KAFKA_LOGS_HOME} \
&& chmod +x ${KAFKA_HOME}/entrypoint.sh

USER $KAFKA_USER

WORKDIR $KAFKA_HOME

ENTRYPOINT ["./entrypoint.sh"]

# docker build -t "symplesims/kafa-kraft:3.1.0-jre11" .
# symplesims/kafa-kraft:3.1.0-jre11