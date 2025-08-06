{{- define "rickmorty-app.name" -}}
rickmorty-app
{{- end }}

{{- define "rickmorty-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}
