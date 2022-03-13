

## build image
```
docker build -t symplesims/kafa-kraft:3.1.0-jre11 .
```

## push image
```
docker push symplesims/kafa-kraft:3.1.0-jre11
```

## run
```
docker run -d --network bridge --name kafka-service -p 9092:9092 symplesims/kafa-kraft:3.1.0-jre11
```

## Appendix
참고해서, 나중에 더 작게 만들자
```
FROM alpine:3.14 AS builder
ENV KAFKA_VERSION=3.0.0
ENV SCALA_VERSION=2.13
COPY install_kafka.sh /bin/
RUN apk update \
  && apk add --no-cache bash curl jq \
  && /bin/install_kafka.sh \
  && apk del curl jq

FROM alpine:3.14
RUN apk update && apk add --no-cache bash openjdk8-jre
COPY --from=builder /opt/kafka /opt/kafka
COPY start_kafka.sh /bin/
CMD [ "/bin/start_kafka.sh" ]
```

- server.properties
```
# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# 데이터 유지 시간 - 7 일
log.retention.hours=168

# 로그 파일의 최소 용량 - 1 GB (Replication 2 로 설정된다면 디스크는 2GB 를 차지 함)
# 로그 파일의 삭제는 세그먼트 단위로 일어 나며, 하나의 세그먼트만 있는경우 정상적으로 삭제되지 않을 수 있음
#log.retention.bytes=1073741824

# 최대 새그먼트 파일 크기. 지정된 크기를 도달하면 새로운 새그먼트 파일이 자동 생성
# 반드시 log.retention.bytes 이하로 설정 해야 함.
log.segment.bytes=1073741824

# 로그파일 정리 체크 주기 - 5분 
log.retention.check.interval.ms=300000
```