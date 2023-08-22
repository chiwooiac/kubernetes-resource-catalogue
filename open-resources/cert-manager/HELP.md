# cert-manager 

cert-manager를 사용하면 Kubernetes 클러스터 내에서 SSL/TLS 인증서를 효율적으로 발급하고 관리하며, 보안 및 자동화 측면에서 많은 이점을 얻을 수 있습니다.  
cert-manager는 Let's Encrypt와 같은 인증서 발급기관과 통합하여 클러스터 내의 서비스에 대한 보안된 연결을 설정하고 유지하는 데 도움이 되는 Kubernetes 네이티브 도구입니다.

##  주요 기능

- SSL/TLS 보안 강화: 인증서를 사용하여 트래픽을 암호화하면 데이터의 기밀성과 무결성을 유지할 수 있습니다.
- 자동 갱신: 인증서의 만료 일정을 자동으로 모니터링하고 갱신합니다.
- 자동화 및 편의성: Kubernetes의 Custom Resource Definition (CRD)를 사용하여 인증서를 관리합니다. 이를 통해 인증서 발급 및 갱신 프로세스를 코드화하고, 템플릿화하여 반복적인 작업을 자동화할 수 있습니다.
- Let's Encrypt 통합: cert-manager는 Let's Encrypt와 통합되어 무료로 인증서를 발급하고 갱신할 수 있습니다.
- cert-manager는 Kubernetes API와 완벽하게 통합되어 Kubernetes 리소스로 인증서를 정의하고 관리합니다. 


## Installation

### 1. Add the Helm repository

```
helm repo add jetstack https://charts.jetstack.io
```

### 2. Update your local Helm chart repository cache:

```
helm repo update
```

### 3. Install the cert-manager Helm chart

```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.12.0 --set installCRDs=true

# Example: disabling prometheus using a Helm parameter
# --set prometheus.enabled=false 
# Example: changing the webhook timeout using a Helm parameter
# --set webhook.timeoutSeconds=4   
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
