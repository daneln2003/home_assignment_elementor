{{- define "rickmorty-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "rickmorty-app.fullname" -}}
{{ .Chart.Name }}-{{ .Release.Name }}
{{- end }}
