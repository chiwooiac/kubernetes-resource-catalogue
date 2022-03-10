{{/*
    Expand the name of the chart.
*/}}
{{- define "hello.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Create a default fully qualified app name.
*/}}
{{- define "hello.fullname" -}}
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
{{- define "hello.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Common labels
*/}}
{{- define "hello.labels" -}}
helm.app/chart: {{ include "hello.chart" . }}
helm.app/version: {{ .Chart.AppVersion | quote }}
{{ include "hello.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app-version: {{ .Chart.Version | quote }}
app.kubernetes.io/version: {{ .Chart.KubeVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
    Selector labels
*/}}
{{- define "hello.selectorLabels" -}}
app: {{ include "hello.name" . }}
{{- end }}

{{/*
    Create the name of the service account to use
*/}}
{{- define "hello.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hello.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
