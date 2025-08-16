{{/*
Expand the name of the chart
*/}}
{{- define "protonmail-bridge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "protonmail-bridge.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "protonmail-bridge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "protonmail-bridge.labels" -}}
helm.sh/chart: {{ include "protonmail-bridge.chart" . }}
{{ include "protonmail-bridge.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "protonmail-bridge.selectorLabels" -}}
app.kubernetes.io/name: {{ include "protonmail-bridge.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Get the storage class for PVC
*/}}
{{- define "protonmail-bridge.storageClass" -}}
{{- if .Values.persistence.storageClass -}}
{{- if (eq "-" .Values.persistence.storageClass) -}}
storageClassName: ""
{{- else }}
storageClassName: {{ .Values.persistence.storageClass | quote }}
{{- end -}}
{{- end -}}
{{- end -}}