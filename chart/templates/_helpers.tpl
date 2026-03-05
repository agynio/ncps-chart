{{- define "ncps.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ncps.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "ncps.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "ncps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "ncps.labels" -}}
{{- $labels := dict "app.kubernetes.io/name" (include "ncps.name" .) "app.kubernetes.io/instance" .Release.Name "app.kubernetes.io/managed-by" "Helm" "app.kubernetes.io/version" .Chart.AppVersion "helm.sh/chart" (include "ncps.chart" .) -}}
{{- toYaml $labels -}}
{{- end -}}

{{- define "ncps.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ncps.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "ncps.persistence.claimName" -}}
{{- if .Values.persistence.existingClaim -}}
{{- .Values.persistence.existingClaim -}}
{{- else -}}
{{- printf "%s-storage" (include "ncps.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "ncps.migrationJobName" -}}
{{ printf "%s-migrate" (include "ncps.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ncps.mergeExtraVolumes" -}}
{{- $values := index . "Values" -}}
{{- $ctx := index . "Ctx" -}}
{{- $volumes := default (list) $values.extraVolumes -}}
{{- if and $values.persistence.enabled (not (empty $values.persistence)) -}}
  {{- $volumeNames := dict -}}
  {{- range $volumes }}{{- if .name }}{{- $_ := set $volumeNames .name true -}}{{- end -}}{{- end -}}
  {{- if not (hasKey $volumeNames "storage") -}}
    {{- $storage := dict "name" "storage" "persistentVolumeClaim" (dict "claimName" (include "ncps.persistence.claimName" $ctx)) -}}
    {{- $volumes = append $volumes $storage -}}
  {{- end -}}
{{- end -}}
{{- toYaml $volumes -}}
{{- end -}}

{{- define "ncps.mergeExtraVolumeMounts" -}}
{{- $values := index . "Values" -}}
{{- $ctx := index . "Ctx" -}}
{{- $mounts := default (list) $values.extraVolumeMounts -}}
{{- if and $values.persistence.enabled (not (empty $values.persistence)) -}}
  {{- $mountNames := dict -}}
  {{- range $mounts }}{{- if .name }}{{- $_ := set $mountNames .name true -}}{{- end -}}{{- end -}}
  {{- if not (hasKey $mountNames "storage") -}}
    {{- $storageMount := dict "name" "storage" "mountPath" "/storage" -}}
    {{- $mounts = append $mounts $storageMount -}}
  {{- end -}}
{{- end -}}
{{- toYaml $mounts -}}
{{- end -}}
