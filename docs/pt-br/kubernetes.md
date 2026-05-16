# Kubernetes (Português)

## Opções disponíveis

- Manifests estáticos em `k8s/base`
- Helm chart em `helm/observai`

## 1) Manifests base

```bash
kubectl create namespace observai --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f k8s/base
```

Validação:

```bash
kubectl get ns observai
kubectl get pods -n observai
kubectl get svc -n observai
kubectl logs -n observai deploy/observai-api
kubectl logs -n observai deploy/observai-web
```

## 2) Helm

Instalação/upgrade:

```bash
helm upgrade --install observai ./helm/observai \
  --namespace observai \
  --create-namespace \
  --set image.api.tag=v0.1.1 \
  --set image.web.tag=v0.1.1 \
  --set ingress.enabled=true \
  --set ingress.host=observai.example.com
```

## Modelo de ingress

```txt
https://observai.example.com      -> observai-web
https://observai.example.com/api  -> observai-api
```

## Monitoramento operacional

- API readiness: `GET /readyz`
- API liveness: `GET /health`
- UI: `GET /`
