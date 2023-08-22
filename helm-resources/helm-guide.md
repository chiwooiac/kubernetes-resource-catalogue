# helm

## helm 명령어  

### 신규 chart 생성

```
helm create hello
```

### chart 디렉토리 전개 구조
```
.
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt           도움말
│   ├── _helpers.tpl        차트 전체에서 사용되는 핼퍼를 지정
│   ├── deployment.yaml     kubernetes 디플로이 manifests
│   ├── hpa.yaml            HPA 구성
│   ├── ingress.yaml        Ingress 구성
│   ├── service.yaml        Service 구성
│   ├── serviceaccount.yaml ServiceAccount 구성
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

### chart 검증
```shell
helm lint hello
```

### chart manifest 확인 
```shell
helm install hello ./hello --dry-run --debug
```

### chart 패키징
```shell
helm package hello
```

### chart 서비스 배포
```shell
helm install hello ./hello
```

## helm 저장소

### repo 목록

```shell
helm repo list
```

### chart 검색
- Local 에 등록된 저장소에서 chart 를 검색 합니다.
```shell
helm search repo redis
```

- Public 에 공개된 chart 를 검색 합니다.  
  (만약 `No results found` 와 같이 검색되지 않는다면 Public 에서 검색할 수 있습니다.)
```shell
helm search hub redis --list-repo-url
```

- repo 등록 및 chart 검색
```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo redis
```

## Custom chart 배포
helm chart 를 패키지 하고 리모트 저장소(github)에 업로드 합니다.

Github 계정 및 저장소 생성 [create-a-repo](https://docs.github.com/en/get-started/quickstart/create-a-repo) 가이드를 참고 하세요.

### hello 패키지 
```shell
helm package hello ./hello
```

### index 목록 추가 / 갱신
```
helm repo index .
```

### hello 패키지 업로드
패키징 된 tgz 파일과 index.yaml 인덱스 파일만 저장소에 추가하여 github 로 push 합니다.
```shell
git add hello-0.1.0.tgz
git index.yaml
git commit -m "deploy hello helm chart"
git push
```

### 리모트 저장소(Github) 등록 및 확인
```
# 사전에 github 저장소를 GitHub Pages 로 발행 해야 한다. (저장소의 Settings > Pages 에서 설정 가능)  
# https://chiwooiac.github.io/catalogue-resource/helm-charts 에 push 한 경우  
helm repo add chiwoo https://chiwooiac.github.io/catalogue-resource/helm-charts

helm repo list
```

### hello 서비스 배포
새로운 namespace 에 애플리케이션을 배포하기 위해 'sample' 네임스페이스를 생성하고 여기에 서비스를 배포 합니다.
```
helm search repo hello

kubectl create namespace sample

helm install hello chiwoo/hello --namespace sample

# 배포 내역 확인 
helm list -A
```

### hello 서비스 삭제
```
helm uninstall hello -n sample

# 배포 내역 확인
helm list -A
[aSaA]()
```

## Helm 가이드

```
helm create hello 
```

### hello

```shell
aa
```

[deployment.yaml](example/hello/templates/deployment.yaml)

Helm 의 템플릿 지시어는 `{{ }}` 으로 정의 합니다.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  # _helpers.tpl 의 {{- define "hello.fullname" -}} 으로 정의 합니다.
  # 특히 include <속성명> . 에서 `'` 은 현재 위치에 렌더링 하라는 포지션 입니다
  name: {{ include "hello.fullname" . }}
  # _helpers.tpl 의 {{- define "hello.labels" -}} 으로 정의 합니다.
  # include 앞의 `-` 는 빈줄을 제거하는 지시자 이고, | nindent 4 는 파이프라인 지시자로 4 칸의 뛰어쓰기와 
  # include 지시자가 첫번째 칼럼에 오지 않아도 된다는 의미 입니다.  
  labels:
    {{- include "hello.labels" . | nindent 4 }}

    affinity:
      {{- toYaml . | nindent 8 }}
```


- 
- include "hello.labels" . | nindent 4 }}
```
- {{ include "hello.fullname" . }} 의 경우 _helpers.tpl 의 아래와 같이 정의 되어 있습니다.

```shell
{{- define "hello.fullname" -}}
{{- end }}
```

```shell
{{- include "hello.labels" . | nindent 4 }} 지시어는 

```


- install exam01-hello
helm install 명령을 통해 exam01-hello 배포 할 수 있습니다. 
```
helm install exam01-hello ./exam01-hello

-----------------------------------------
NAME: exam01-hello
LAST DEPLOYED: Tue Mar  8 23:44:54 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

- get exam01-hello
helm get 명령을 통해 배포된 manifest 를 조회 할 수 있습니다.
```
helm get manifest exam01-hello

-----------------------------------------
---
# Source: hello/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello-cm
data:
  value: "Hello World"
```

- uninstall exam01-hello
helm uninstall 명령을 통해 배포된 manifest 를 삭제 합니다.

```shell
helm uninstall exam01-hello
```


### exam02-hello - 템플릿 지시자
동적 속성 값의 바인딩은 templates 의 지시자 '{{ }}'를 통한 할 수 있습니다. 

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-cm
data:
  value: "Hello World"
```
위의 `{{ .Release.Name }}` 지시문에서 처음의 . 은 최상위 네임스페이스를 의미 합니다.   
최상위 . 노테이션을 기준으로 Release 하위의 Name 값을 적용하는 의미 입니다.  

- install exam02-hello
```
helm install exam02-hello ./exam02-hello
```

- helm get
```
helm get manifest exam02-hello
```

- install with --dry-run
`--debug --dry-run` 옵션을 통해 템플릿 렌더링을 테스트 할 수 있습니다.

```
helm install --debug --dry-run apple ./exam02-hello
```
name 속성이 `apple-cm` 으로 렌더링 됩니다.

## Built-In 객체
빌트인 객체에 대한 속성은 항상 대문자로 시작한다.

### Release
```shell
Release:            릴리스 자체를 객체로 정의
Release.Name:       릴리스 이름
Release.Namespace:  릴리스될 네임스페이스
Release.IsUpgrade:  현재 작업이 업그레이드 또는 롤백인 경우 true 로 설정된다.
Release.IsInstall:  현재 작업이 설치일 경우 true 로 설정.
Release.Revision:   이 릴리스의 리비전 번호. 설치시에는 이 값이 1이며 업그레이드나 롤백을 수행할 때마다 증가한다.
Release.Service:    현재 템플릿을 렌더링하는 서비스. Helm 에서는 항상 Helm 이다.
```

### Values & Chart
```shell
Values:   values.yaml 파일 및 사용자 제공 파일에서 템플릿으로 전달된 값.
Chart:    Chart.yaml 파일의 내용. Chart.yaml 안의 모든 데이터는 이 파일의 값을 참조 한다. `{{ .Chart.Name }}-{{ .Chart.Version }}` 은 hello-0.1.0 를 출력한다.
```

### Files
```shell
Files:            차트 내의 모든 파일에 대한 접근을 제공  템플릿에 접근하는 데에는 사용할 수 없지만, 차트 내의 다른 파일에 접근하는 데에는 사용할 수 있다. 자세한 내용은 Accessing Files 섹션을 참고하자.
Files.Get:        이름으로 파일을 가지고 오는 함수이다. (.Files.Get config.ini)
Files.GetBytes:   파일의 내용을 바이트로 가져오는 함수이다.
Files.Glob:       이름이 주어진 shell glob 패턴과 매치되는 파일 목록을 반환하는 함수이다.
Files.Lines:      파일을 한 줄씩 읽는 함수이다. 이것은 파일 내의 각 행을 순회(iterate)하는데 유용하다.
Files.AsSecrets:  파일 본문을 Base64로 인코딩된 문자열로 반환하는 함수이다.
Files.AsConfig:   파일 본문을 YAML 맵으로 반환하는 함수이다.
```

### Capabilities
```shell
Capabilities:                     쿠버네티스 클러스터가 지원하는 기능에 대한 정보를 제공한다.
Capabilities.APIVersions:         버전의 집합이다.
Capabilities.APIVersions.Has:     $version 은 'batch/v1' 버전이나 'apps/v1/Deployment' 리소스를 클러스터에서 사용할 수 있는지 여부를 나타낸다.
Capabilities.KubeVersion:         쿠버네티스 버전이다.
Capabilities.KubeVersion.Major:   쿠버네티스 메이저 버전이다.
Capabilities.KubeVersion.Minor:   쿠버네티스 마이너 버전이다.
```

### Template
```shell
Template:   실행 중인 현재 템플릿에 대한 정보를 포함한다.
Name:       현재 템플릿에 대한 네임스페이스 파일 경로 (예: mychart/templates/mytemplate.yaml)
BasePath:   현재 차트의 템플릿 디렉토리에 대한 네임스페이스 경로 (예: mychart/templates).
```

## values.yaml
`values.yaml` 파일은 사용자 정의 속성 및 값을 기술 합니다. 대게 소문자로 시작하는 것을 규칙으로 합니다.
helm install 을 통한 배포나 helm upgrade 를 통한 버전업을 할 때 -f 옵션을 통해 사용자 정의 옵션 및 값들을 전달 할 수 있습니다.
```shell
# values.yaml 파일을 통한 값의 전달
helm install -f values.yaml ./mychart

# 명령 파라미터를 통한 값의 전달
helm install --set foo=bar ./mychart
```

## dynamic examples

### exam03-hello - values.yaml 바인딩으로 동적 렌더링
[exam03-hello/values.yaml](./exam03-hello/values.yaml) 을 적용한 동적 바인딩 예제 입니다.

- [values.yaml](./exam03-hello/values.yaml) 파일을 통한 렌더링 테스트
```
helm install exam03-hello ./exam03-hello --dry-run --debug
```

- [values.yaml](./exam03-hello/values.yaml) 파일과 전달 파라미터의 우선 순위 처리를 위한 렌더링 테스트
```shell
helm install exam03-hello ./exam03-hello --dry-run --debug --set favoriteDrink=juice
```

### exam04-hello - 템플릿 함수 & 파이프라인 
[exam04-hello/templates/configmap.yaml](./exam04-hello/templates/configmap.yaml) 을 적용한 동적 바인딩 예제 입니다.

- [values.yaml](./exam04-hello/values.yaml)
```
favorite:
  fruit: Apple
  drink: coffee
  food: pizza
```

-- [configmap.yaml](./exam04-hello/templates/configmap.yaml)
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-cm
data:
  value: "Hello World"
  fruit: {{ .Values.favorite.fruit }}
  drink: {{ .Values.favorite.drink | quote }}
  food: {{ .Values.favorite.food | upper | quote }}
```


## Functions
[functions](https://helm.sh/ko/docs/chart_template_guide/function_list/) 함수 목록을 참고 하여 필요에 따라 사용 합니다.


## Practical Example

```
helm install exam05-ingress ./exam05-ingress --dry-run --debug
```
[exam05-ingress](./exam05-ingress/templates/deployment.yaml)

```
{{- if and (.Values.flower.enabled) (eq .Values.airflow.executor "CeleryExecutor") (.Values.ingress.enabled) }}
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: {{ include "airflow.fullname" . }}-flower
  {{- if .Values.ingress.flower.annotations }}
  annotations:
    {{- toYaml .Values.ingress.flower.annotations | nindent 4 }}
  {{- end }}
  labels:
    app: {{ include "airflow.labels.app" . }}
    component: flower
    chart: {{ include "airflow.labels.chart" . }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
    {{- if .Values.ingress.flower.labels }}
    {{- toYaml .Values.ingress.flower.labels | nindent 4 }}
    {{- end }}
spec:
  {{- if .Values.ingress.flower.tls.enabled }}
  tls:
    - hosts:
        - {{ .Values.ingress.flower.host }}
      secretName: {{ .Values.ingress.flower.tls.secretName }}
  {{- end }}
  rules:
    - http:
        paths:
          {{- range .Values.ingress.flower.precedingPaths }}
          - path: {{ .path }}
            backend:
              serviceName: {{ .serviceName }}
              servicePort: {{ .servicePort }}
          {{- end }}
          - path: {{ .Values.ingress.flower.path }}
            backend:
              serviceName: {{ include "airflow.fullname" . }}-flower
              servicePort: flower
          {{- range .Values.ingress.flower.succeedingPaths }}
          - path: {{ .path }}
            backend:
              serviceName: {{ .serviceName }}
              servicePort: {{ .servicePort }}
          {{- end }}
      host: {{ .Values.ingress.flower.host }}
{{- end }}
```
