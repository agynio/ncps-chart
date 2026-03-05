{{- define "ncps.fullname" -}}
{{ include "service-base.fullname" . }}
{{- end -}}

{{- define "ncps.chart" -}}
{{ include "service-base.chart" . }}
{{- end -}}

{{- define "ncps.labels" -}}
{{ include "service-base.labels" . }}
{{- end -}}

{{- define "ncps.selectorLabels" -}}
{{ include "service-base.selectorLabels" . }}
{{- end -}}

{{- define "ncps.storageClaimName" -}}
{{- if .Values.persistence.existingClaim -}}
{{ .Values.persistence.existingClaim }}
{{- else -}}
{{ printf "%s-storage" (include "ncps.fullname" .) }}
{{- end -}}
{{- end -}}

{{- define "ncps.storageVolume" -}}
name: storage
persistentVolumeClaim:
  claimName: {{ include "ncps.storageClaimName" . }}
{{- end -}}

{{- define "ncps.storageVolumeMount" -}}
name: storage
mountPath: {{ .Values.persistence.mountPath | default "/storage" }}
{{- end -}}

{{- define "ncps.migrationJobName" -}}
{{ printf "%s-migrate" (include "ncps.fullname" .) }}
{{- end -}}

{{- define "ncps.migrationJobImage" -}}
{{- $repository := default .Values.image.repository .Values.migrationJob.image.repository -}}
{{- $tag := default (include "service-base.imageTag" .) .Values.migrationJob.image.tag -}}
{{- $registry := "" -}}
{{- if .Values.migrationJob.image.registry -}}
{{- $registry = .Values.migrationJob.image.registry -}}
{{- else if .Values.global.imageRegistry -}}
{{- $registry = .Values.global.imageRegistry -}}
{{- else -}}
{{- $registry = .Values.image.registry -}}
{{- end -}}
{{- $registry = trimSuffix "/" ($registry | default "") -}}
{{- if $registry -}}
{{ printf "%s/%s:%s" $registry $repository $tag }}
{{- else -}}
{{ printf "%s:%s" $repository $tag }}
{{- end -}}
{{- end -}}
