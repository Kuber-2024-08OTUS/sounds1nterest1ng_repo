{{- define "hw-helm-chart.namespace" -}}
{{- .Values.namespace | default .Release.Namespace -}}
{{- end -}}
