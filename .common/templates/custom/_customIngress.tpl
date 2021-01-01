{{- define "common.customIngress" -}}
{{- if .Values.customIngress.enabled -}}
{{- if .Values.customIngress.host -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
    traefik.ingress.kubernetes.io/router.middlewares: traefik-middlewares-chain-public@kubernetescrd
    {{- if .Values.customIngress.authForwardUrl -}}
    traefik.ingress.kubernetes.io/router.middlewares: traefik-middlewares-{{ .Release.Name }}-auth-forward@kubernetescrd
    {{- end }}
  name: {{ .Release.Name }}
spec:
  rules:
  - host: {{ .Values.customIngress.host }}
    http:
      paths:
      - path: /
        backend:
          serviceName: {{ .Release.Name }}
          servicePort: {{.Values.customIngress.port}}
  tls: {{- if .Values.customIngress.selfsigned -}}{{ else if .Values.customIngress.existingCert }}
    secretName: {{ .Values.customIngress.existingCert }}
  {{ else if .Values.customIngress.wildcard }}
    secretName: wilddcardcert
  {{ else }}
  - hosts:
      - {{ .Values.customIngress.host }}
    secretName: {{ .Release.Name }}
  {{ end }}
{{- if .Values.customIngress.authForwardUrl -}}
---
# Forward authentication
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: {{ .Release.Name }}-auth-forward
  namespace: traefik-middlewares
spec:
  forwardAuth:
    address: '{{ .Values.customIngress.authForwardUrl }}'
    trustForwardHeader: true
    authResponseHeaders:
       - Remote-User
       - Remote-Groups
       - Remote-Name
       - Remote-Email
{{- end }}
{{- end }}
{{- end }}
{{- end }}