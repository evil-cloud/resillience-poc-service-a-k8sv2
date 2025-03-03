{{/*
Expand the name of the chart.
*/}}
{{- define "service-a.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "service-a.fullname" -}}
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
{{- define "service-a.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels (Used in all resources)
*/}}
{{- define "service-a.labels" -}}
helm.sh/chart: {{ include "service-a.chart" . }}
{{ include "service-a.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Istio-specific labels (Only for Deployment, Service, and ServiceAccount)
*/}}
{{- define "service-a.istioLabels" -}}
app: {{ include "service-a.fullname" . }}
version: {{ .Values.version | default .Chart.AppVersion }}
{{- end }}

{{/*
Selector labels (Used in matchLabels for Deployment and Service)
*/}}
{{- define "service-a.selectorLabels" -}}
app: {{ include "service-a.fullname" . }}
app.kubernetes.io/name: {{ include "service-a.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "service-a.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "service-a.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

