# catalogue-resource
kubernetes catalogue-resource

## repo 추가
```
helm repo add chiwoo https://chiwooiac.github.io/catalogue-resource/helm-charts

# repository update index
helm repo update chiwoo
```

```
품질 관리를 위해 부수적인 작업량이 많이 늘어나거나, 상황에 맞지 않는 통제가 없었으면 하는 바램입니다.
품질 관리 활동은 꼭 필요하다고 생각 합니다. 

```
## 서비스 배포

### hello
```
helm search repo hello

# 최근에 새롭게 올라온 릴리즈가 있는지 확인 하기 위해 update 명령으로 저장소를 갱신 하자
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

### redis
A Helm chart for redis cluster.

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