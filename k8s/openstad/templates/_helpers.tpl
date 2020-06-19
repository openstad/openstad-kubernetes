{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openstad.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openstad.fullname" -}}
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

{{- define "openstad.frontend.fullname" -}}
{{- printf "%s-%s" (include "openstad.fullname" .) .Values.frontend.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openstad.adminer.fullname" -}}
{{- printf "%s-%s" (include "openstad.fullname" .) .Values.adminer.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openstad.auth.fullname" -}}
{{- printf "%s-%s" (include "openstad.fullname" .) .Values.auth.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openstad.api.fullname" -}}
{{- printf "%s-%s" (include "openstad.fullname" .) .Values.api.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openstad.image.fullname" -}}
{{- printf "%s-%s" (include "openstad.fullname" .) .Values.image.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openstad.clusterIssuer.staging.fullname" -}}
    {{ .Values.clusterIssuer.stagingIssuerName }}
{{- end -}}

{{- define "openstad.clusterIssuer.prod.fullname" -}}
    {{ .Values.clusterIssuer.prodIssuerName }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openstad.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openstad.labels" -}}
helm.sh/chart: {{ include "openstad.chart" . }}
{{ include "openstad.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openstad.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openstad.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
    URL Creation
*/}}

{{- define "openstad.api.url" -}}
{{- if .Values.api.subdomain -}}
www.{{ .Values.api.subdomain }}.{{ .Values.host.base }}
{{- else -}}
www.{{ .Values.host.base }}
{{- end -}}
{{- end -}}

{{- define "openstad.auth.url" -}}
{{- if .Values.auth.subdomain -}}
www.{{ .Values.auth.subdomain }}.{{ .Values.host.base }}
{{- else -}}
www.{{ .Values.host.base }}
{{- end -}}
{{- end -}}

{{- define "openstad.frontend.url" -}}
{{- if .Values.frontend.subdomain -}}
www.{{ .Values.frontend.subdomain }}.{{ .Values.host.base }}
{{- else -}}
www.{{ .Values.host.base }}
{{- end -}}
{{- end -}}

{{- define "openstad.image.url" -}}
{{- if .Values.image.subdomain -}}
www.{{ .Values.image.subdomain }}.{{ .Values.host.base }}
{{- else -}}
www.{{ .Values.host.base }}
{{- end -}}
{{- end -}}

{{- define "openstad.adminer.url" -}}
{{- if .Values.adminer.subdomain -}}
www.{{ .Values.adminer.subdomain }}.{{ .Values.host.base }}
{{- else -}}
www.{{ .Values.host.base }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "openstad.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "openstad.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
