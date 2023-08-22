# kubernetes-resource-catalogue
kubernetes resource catalogue

## repo 추가
```
helm repo add chiwoo https://chiwooiac.github.io/kubernetes-resource-catalogue/helm-charts

# repository update index
helm repo update chiwoo
```

```
품질 관리를 위해 부수적인 작업량이 많이 늘어나거나, 상황에 맞지 않는 통제가 없었으면 하는 바램입니다.
품질 관리 활동은 꼭 필요하다고 생각 합니다. 

```
## Chart 서비스

### hello
```
helm search repo hello

# 최근에 새롭게 올라온 릴리즈가 있는지 확인 하기 위해 update 명령으로 저장소를 갱신 합니다.
helm repo update chiwoo

# hello 서비스 배포
helm install hello chiwoo/hello

# helm 배포목록 확인
helm list

# helm 전체 manifest 조회
helm get manifest hello
```
- 참고로, install 하지 않고 download 만 하고자 하는 경우 Pull 명령을 활용할 수 있다.
```
helm pull chiwoo/hello --untar --untardir /tmp
```

### mysql
A Helm chart for mysql-galera cluster.
```
helm install mysql chiwoo/mysql --namespace cs 

# upgrade new version
helm upgrade --install mysql chiwoo/mysql --namespace cs
```

### kafka
A Helm chart for kafka-kraft cluster.
```
helm install kafka-kraft chiwoo/kafka-kraft --namespace cs 

# upgrade new version
helm upgrade --install kafka-kraft chiwoo/kafka-kraft --namespace cs
```

- kafka cli
```

kubectl -n cs exec -it kafka-0 -- sh

# 토픽 생성
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic my-topic --replication-factor 1 --partitions 1

# 토픽 정보 조회
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic my-topic
    
# 토픽 목록 조회
kafka-topics.sh --bootstrap-server localhost:9092 --list

# 토픽 삭제
kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic my-topic 

# Produce 테스트
# 먼저 topic 에 연결 하여 터미널에 접속 후 메시지를 입력 한다.
kafka-console-producer.sh --broker-list localhost:9092 --topic my-topic

# Consume 테스트
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning
```

### redis
A Helm chart for redis cluster (sentinel).

```
helm install redis chiwoo/redis --namespace cs 

# upgrade new version
helm upgrade --install redis chiwoo/redis --namespace cs
```

- redis cli
```
kubectl -n cs exec -it redis-0 -- sh

# redis-cli
/prompt # redis-cli
127.0.0.1:6379> auth <your_redis_password>
OK
127.0.0.1:6379> info replication
```

## 서비스 배포
```shell
helm install kafka-kraft chiwoo/kafka-kraft --namespace cs \
&& helm install mysql chiwoo/mysql --namespace cs \
&& helm install mysql chiwoo/redis --namespace cs
```

## Appendix

### Redis
- [redis cluster comparison](https://medium.com/hepsiburadatech/redis-solutions-standalone-vs-sentinel-vs-cluster-f46e703307a9)
- [redis cluster not sentinel](https://github.com/sobotklp/kubernetes-redis-cluster)
