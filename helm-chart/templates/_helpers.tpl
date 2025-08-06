{{- define "rickmorty-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "rickmorty-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}
