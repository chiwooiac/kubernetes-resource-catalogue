{{/*
Expand the name of the chart.
*/}}
{{- define "mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mysql.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mysql.labels" -}}
helm.sh/chart: {{ include "mysql.chart" . }}
{{ include "mysql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes/version: {{ .Chart.KubeVersion | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ include "mysql.name" . }}
app-version: {{ .Chart.Version | quote }}
{{- end }}

{{/*
    Selector labels

    # include "mysql.selectorLabels" .
*/}}
{{- define "mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mysql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mysql.pvLabels" -}}
app: {{ include "mysql.name" . }}
{{- if eq .Values.clusterType "minikube" }}
type: minikube
{{- else if eq .Values.clusterType "nks" }}
type: nks
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mysql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mysql.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mysql.serviceName" -}}
{{ include "mysql.name" . }}-service
{{- end }}

{{- define "mysql.pvName" -}}
{{ include "mysql.name" . }}-pv
{{- end }}

{{- define "mysql.pvcName" -}}
{{ include "mysql.name" . }}-pvc
{{- end }}

{{- define "mysql.storageClassName" -}}
{{- if eq .Values.clusterType "minikube" }}
{{- .Values.volume.minikube.storageClassName }}
{{- else }}
filepath
{{- end }}
{{- end }}

{{/*
    User define function
    (tuple "value" | include "mysql.fnServiceName")
*/}}
{{- define "mysql.fnServiceName" }}
{{- $value := (int (index . 0)) -}}
  {{- if eq $value 0 }}
  {{- print "svc" }}
  {{- else if eq $value 1 }}
  {{- print "slave-svc" }}
  {{- else }}
  {{- print "slave-svc" $value }}
  {{- end }}
{{- end }}
