# Docker Hub

The default self-hosted examples are prepared to use Docker Hub images.

## Images

```txt
observai/observai-api
observai/observai-web
```

## Versioning

Use explicit versions for production:

```env
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0
```

Avoid relying only on `latest` in production.

## Alternative registries

Images are configurable through `.env`.

Example using GHCR:

```env
OBSERVAI_API_IMAGE=ghcr.io/guferreira1/observai-api
OBSERVAI_WEB_IMAGE=ghcr.io/guferreira1/observai-web
```

Example using a private registry:

```env
OBSERVAI_API_IMAGE=registry.example.com/observai/observai-api
OBSERVAI_WEB_IMAGE=registry.example.com/observai/observai-web
```
