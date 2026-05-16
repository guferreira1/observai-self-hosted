# Kubernetes (English)

## Deployment options

- Raw manifests in `k8s/base`
- Helm chart in `helm/observai`

## 1) Raw manifests

Create namespace and apply:

```bash
kubectl create namespace observai --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f k8s/base
```

Validate:

```bash
kubectl get ns observai
kubectl get pods -n observai
kubectl get svc -n observai
kubectl logs -n observai deploy/observai-api
kubectl logs -n observai deploy/observai-web
```

## 2) Helm

Install or upgrade with Helm:

```bash
helm upgrade --install observai ./helm/observai \
  --namespace observai \
  --create-namespace \
  --set image.api.tag=v0.1.1 \
  --set image.web.tag=v0.1.1 \
  --set ingress.enabled=true \
  --set ingress.host=observai.example.com
```

## Ingress model

Both manifests share the same model:

```txt
https://observai.example.com      -> observai-web
https://observai.example.com/api  -> observai-api
```

## Health and maintenance

- API readiness: `GET /readyz`
- API liveness: `GET /health`
- Public web availability: `GET /`
