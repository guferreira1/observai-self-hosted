# Kubernetes

Kubernetes support is provided as an advanced deployment path.

The same Docker images used by Docker Compose can be used by Kubernetes.

## Options

- Raw manifests in `k8s/base`
- Helm Chart in `helm/observai`

## Recommended production model

For production Kubernetes environments, prefer managed services for stateful dependencies:

- managed PostgreSQL
- managed Redis
- Kubernetes Secrets or External Secrets
- Ingress Controller
- TLS with cert-manager or cloud load balancer

## Raw manifests

Apply examples:

```bash
kubectl apply -f k8s/base
```

## Helm

Install example:

```bash
helm install observai ./helm/observai --namespace observai --create-namespace
```

Override values:

```bash
helm upgrade --install observai ./helm/observai \
  --namespace observai \
  --create-namespace \
  --values values.production.yaml
```

## Ingress model

Recommended routing:

```txt
https://observai.example.com      -> observai-web
https://observai.example.com/api  -> observai-api
```
