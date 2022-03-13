#!/bin/bash

# init environment variables
NODE_ID=${HOSTNAME:6}

if [ ${HOSTNAME:0:5} != "kafka" ]; then
  export NODE_ID=0
fi

[ -f ${SHOW_ENV_VARS+1} ] && SHOW_ENV_VARS=1
[ -f ${SERVICE+1} ] && SERVICE="kafka-service"
[ -f ${NAMESPACE+1} ] && NAMESPACE="kafka"
[ -f ${REPLICAS+1} ] && REPLICAS=3
[ -f ${LOG_RETENTION_HOURS+1} ] && LOG_RETENTION_HOURS=4
[ -f ${REPLICATION_FACTOR+1} ] && REPLICATION_FACTOR=1
[ -f ${KAFKA_HOME+1} ] && KAFKA_HOME="/opt/kafka"
[ -f ${KAFKA_CONFIG+1} ] && KAFKA_CONFIG="${KAFKA_HOME}/config/kraft/server.properties"
[ -f ${KAFKA_CLUSTER_ID+1} ] && KAFKA_CLUSTER_ID="MTM2NkYwNjgyQTBGNEZBOU"
[ -f ${KAFKA_LOGS_HOME+1} ] && KAFKA_LOGS_HOME="/data/kafka"
[ -f ${KAFKA_HEAP_OPTS+1} ] && KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
[ -f ${KAFKA_OPTS+1} ] && KAFKA_OPTS="-Djava.net.preferIPv4Stack=True"

LISTENERS="PLAINTEXT://:9092,CONTROLLER://:9093"
ADVERTISED_LISTENERS="PLAINTEXT://kafka-${NODE_ID}.${SERVICE}.${NAMESPACE}.svc.cluster.local:9092"

CONTROLLER_QUORUM_VOTERS=""
for i in $( seq 0 $REPLICAS); do
    if [[ $i != $REPLICAS ]]; then
        CONTROLLER_QUORUM_VOTERS="$CONTROLLER_QUORUM_VOTERS$i@kafka-$i.${SERVICE}.${NAMESPACE}.svc.cluster.local:9093,"
    else
        CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}
    fi
done

sudo mkdir -p ${KAFKA_LOGS_HOME}/${NODE_ID} && sudo chown 910:910 -R ${KAFKA_LOGS_HOME}

export CLUSTER_ID=${KAFKA_CLUSTER_ID}

#export CLUSTER_ID_DIR="${HOME}/.kafka"
#mkdir -p ${CLUSTER_ID_DIR}
#if [[ ! -f "${CLUSTER_ID_DIR}/cluster_id" && "${NODE_ID}" = "0" ]]; then
#  CLUSTER_ID=$(kafka-storage.sh random-uuid)
#  echo ${CLUSTER_ID} > ${CLUSTER_ID_DIR}/cluster_id
#else
#  CLUSTER_ID=$(cat ${CLUSTER_ID_DIR}/cluster_id)
#fi

# Refer to kafka-kraft configurations on github.
# https://github.com/apache/kafka/blob/3.1.0/config/kraft/broker.properties
if [ ${SHOW_ENV_VARS} == 1 ]; then
  echo "USER_INFO: $(id)"
  echo "HOSTNAME: ${HOSTNAME}"
  echo "CLUSTER_ID: ${CLUSTER_ID}"
  echo "NODE_ID: ${NODE_ID}"
  echo "SERVICE: ${SERVICE}"
  echo "NAMESPACE: ${NAMESPACE}"
  echo "REPLICAS: ${REPLICAS}"
  echo "LOG_RETENTION_HOURS: ${LOG_RETENTION_HOURS}"
  echo "REPLICATION_FACTOR: ${REPLICATION_FACTOR}"
  echo "CONTROLLER_QUORUM_VOTERS: ${CONTROLLER_QUORUM_VOTERS}"
  echo "KAFKA_LOGS_HOME: ${KAFKA_LOGS_HOME}"
  echo "KAFKA_HOME: ${KAFKA_HOME}"
  echo "KAFKA_VERSION: ${KAFKA_VERSION}"
  echo "KAFKA_CONFIG: ${KAFKA_CONFIG}"
  echo "KAFKA_HEAP_OPTS: ${KAFKA_HEAP_OPTS}"
  echo "KAFKA_OPTS: ${KAFKA_OPTS}"
fi

sed -e "s+^node.id=.*+node.id=${NODE_ID}+" \
-e "s+^controller.quorum.voters=.*+controller.quorum.voters=${CONTROLLER_QUORUM_VOTERS}+" \
-e "s+^listeners=.*+listeners=${LISTENERS}+" \
-e "s+^advertised.listeners=.*+advertised.listeners=${ADVERTISED_LISTENERS}+" \
-e "s+^log.dirs=.*+log.dirs=${KAFKA_LOGS_HOME}/${NODE_ID}+" \
${KAFKA_CONFIG} > server.properties.updated \
&& mv server.properties.updated ${KAFKA_CONFIG}

# KAFKA_CONFIG="${KAFKA_HOME}/config/kraft/server.properties"

sleep 20

kafka-storage.sh format -t $CLUSTER_ID -c ${KAFKA_CONFIG}

if [ ${NODE_ID} != 0 ]; then
  sleep 2
fi

exec kafka-server-start.sh ${KAFKA_CONFIG}