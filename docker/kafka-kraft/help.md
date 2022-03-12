

## build image
```
docker build -t "symplesims/kafa-kraft:3.1.0-jre11" .
```

## push image
```
docker push "symplesims/kafa-kraft:3.1.0-jre11" 
```

## run
```
docker run --network bridge --name kafka-service -p 9092:9092 symplesims/kafa-kraft:3.1.0-jre11
docker run -d --network bridge --name kafka-service -p 9092:9092 symplesims/kafa-kraft:3.1.0-jre11
```