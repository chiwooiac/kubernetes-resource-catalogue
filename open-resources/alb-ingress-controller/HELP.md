# alb-ingress-controller 

EKS 클러스터 내에서 AWS Application Load Balancer(ALB)를 관리하고 ALB를 사용하여 Ingress 리소스를 처리하는 컨트롤러입니다.
EKS 클러스터 내부의 애플리케이션을 외부로 노출하거나 내부에서 사용할 수 있도록 서비스 Endpoint 을 노출하고 트래픽 분산 및 라우팅을 할 수 있습니다. 

##  주요 기능

- Ingress 리소스 처리: alb-ingress-controller는 Kubernetes Ingress 리소스를 감지하고 이를 기반으로 ALB를 자동으로 생성 및 구성합니다.
  Ingress 리소스를 통해 서비스의 경로 기반 라우팅 및 SSL/TLS 인증서 적용을 손쉽게 설정할 수 있습니다. 
- 외부 액세스 및 내부 액세스 관리: EKS 내부에서 작동하는 서비스를 ALB를 통해 외부로 노출하거나, 클러스터 외부에서 접근하는 요청을 내부 서비스로 라우팅할 수 있습니다. 
- SSL/TLS 인증서 관리: Ingress 리소스에 정의된 SSL/TLS 설정을 기반으로 ALB에 SSL/TLS 인증서를 연결하고 관리합니다. 
- HTTP/HTTPS 리디렉션: Ingress 리소스에 설정된 경로 및 호스트를 기반으로 ALB에서 HTTP에서 HTTPS로의 리디렉션을 처리할 수 있습니다.
- Path 기반 라우팅: alb-ingress-controller를 사용하여 경로 기반 라우팅을 설정할 수 있습니다. 예를 들어 "/api" 경로로 들어오는 요청을 특정 서비스로 라우팅할 수 있습니다.
- ALB의 다양한 기능 활용: ALB의 기능인 Sticky Sessions, Health Checks, Connection Draining 등을 활용할 수 있습니다.
- 자동 스케일링 지원: ALB의 Target Group 기능을 활용하여 부하를 분산 하고 트래픽에 대응하여 서비스의 스케일 인/아웃을 관리할 수 있습니다.


## Installation

### 1. Add the Helm repository

eks-charts 리포지토리를 추가합니다.

```
helm repo add eks https://aws.github.io/eks-charts
```


### 2. Update your local Helm chart repository cache:

최신 차트가 적용되도록 로컬 리포지토리를 업데이트합니다.

```
helm repo update eks
```

### 3. Prepare aws-load-balancer-controller 

EKS 클러스터에 NAT 맟 IGW 가 구성 되지 않아서 워커 노드가 Amazon ECR 퍼블릭 이미지 리포지토리에 액세스할 수 없는 경우 
public ECR 저장소에서 원하는 aws-load-balancer-controller 이미지를 내려받고 private ECR 저장소에 push 합니다.

- example
```
docker pull public.ecr.aws/eks/aws-load-balancer-controller:v2.4.7

aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 1111222233334444.dkr.ecr.ap-northeast-2.amazonaws.com/aws-load-balancer-controller:v2.4.7
docker push 1111222233334444.dkr.ecr.ap-northeast-2.amazonaws.com/aws-load-balancer-controller:v2.4.7
```


### 4. Install the aws-load-balancer-controller Helm chart

AWS Load Balancer Controller를 설치합니다.

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName=<my-cluster> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 


# Amazon EC2 인스턴스 메타데이터 서비스(IMDS)에 대해 제한적인 액세스 권한이 있는 Amazon EC2 노드에 컨트롤러를 배포하거나 Fargate에 배포하는 경우, 다음 helm 명령에 다음 플래그를 추가합니다.
--set region=region-code
--set vpcId=vpc-xxxxxxxx
```

### 4. Uninstall the cert-manager Helm chart
```
# step 1 - delete cert-manager
helm --namespace cert-manager delete cert-manager

# step 2 - delete namespace
kubectl delete namespace cert-manager
```


## Certificate 
cert-manager 에 의해 도메인에 대한 인증서를 생성 및 관리하고 Ingress 컨트롤러에 TLS 프로토콜을 지원할 수 있습니다.

- [end-to-end-encryption-on-amazon-eks](https://github.com/aws-samples/end-to-end-encryption-on-amazon-eks/tree/main)
### 1. Create a ClusterIssuer
```yaml
apiVersion: cert-manager.io/v1
```

### Check Certificates
```
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```
