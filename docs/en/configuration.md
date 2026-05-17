# Configuration Guide (English)

This repository uses `.env` and environment file variables in `docker-compose*.yml`,
Helm values, and Kubernetes manifests.

## 1) Images and versions

```env
OBSERVAI_API_IMAGE=observai/observai-api
OBSERVAI_WEB_IMAGE=observai/observai-web
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0
```

Use explicit tags (`v0.1.x`) in production. Avoid `latest`.

## 2) API routing and web behavior

`NEXT_PUBLIC_OBSERVAI_API_URL` is the base path used by the browser.
Keep it on the same-origin Web proxy path:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
```

`OBSERVAI_API_URL` is used by the Next.js server-side proxy to reach the API from inside the deployment network:

```env
OBSERVAI_API_URL=http://observai-api:8080
```

With this model:

```txt
Browser -> /api/observai/* -> observai-web -> observai-api:8080
```

Also available for UI labeling:

```env
NEXT_PUBLIC_APP_NAME=ObservAI
NEXT_PUBLIC_APP_ENV=self-hosted
NEXT_PUBLIC_APP_VERSION=0.0.0-dev
NEXT_PUBLIC_APP_BUILD_HASH=local
```

## 3) API bootstrap variables

`OBSERVAI_API_PORT` is the port the Go API listens on inside the container.
`OBSERVAI_API_HOST_PORT` is the host-side port Docker publishes for the API
service in the bundled Compose stack — set it when something else on the host
already binds 8080. Both default to 8080, so the two can stay aligned or
diverge independently.

```env
OBSERVAI_API_PORT=8080
OBSERVAI_API_HOST_PORT=8080
OBSERVAI_ENV=self-hosted
OBSERVAI_MODE=local
OBSERVAI_TIMEZONE=Local

OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations
```

`OBSERVAI_DATABASE_DSN` and `OBSERVAI_REDIS_URL` are required when using PostgreSQL and Redis-backed runtime behavior.

## 4) Secret variables

Use the current API environment variable names:

```env
OBSERVAI_JWT_SECRET=change-me-local-jwt-secret-minimum-32-bytes
OBSERVAI_ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

`OBSERVAI_JWT_SECRET` should be at least 32 bytes for non-demo environments.
`OBSERVAI_ENCRYPTION_KEY` must decode to exactly 32 bytes. A 64-character hex value is the recommended format.

Generate compatible values with:

```bash
bash scripts/generate-secrets.sh
```

## 5) PostgreSQL and Redis services

```env
POSTGRES_DB=observai
POSTGRES_USER=observai
POSTGRES_PASSWORD=change-me
POSTGRES_PORT=5432

REDIS_PORT=6379
```

`POSTGRES_*` drives the bundled PostgreSQL container.

`REDIS_PORT` drives the bundled Redis container and `OBSERVAI_REDIS_URL` drives the API connection.

## 6) Production-only tuning

In addition to self-hosted settings, you can pass any API variable from
`observai-api` in `.env`.

Common values:

- `OBSERVAI_QUEUE_BACKEND`
- `OBSERVAI_QUEUE_CONCURRENCY`
- `OBSERVAI_QUEUE_DEQUEUE_TIMEOUT`
- `OBSERVAI_CHAT_LOCK_TTL`
- `OBSERVAI_CHAT_LOCK_WAIT`
- `OBSERVAI_ANALYSIS_CONTEXT_CACHE_TTL`

Set `OBSERVAI_ANALYSIS_CONTEXT_CACHE_TTL` only when your analysis context cache
needs to be tuned.

## 7) Environment-specific defaults

| Scenario | NEXT_PUBLIC_OBSERVAI_API_URL | OBSERVAI_API_URL | `OBSERVAI_MODE` | Notes |
| --- | --- | --- | --- | --- |
| Local Docker Compose | `/api/observai` | `http://observai-api:8080` | `local` | browser uses Web proxy |
| Reverse proxy | `/api/observai` | `http://observai-api:8080` | `local` | same-origin API path |
| Kubernetes/Helm | `/api/observai` | `http://observai-api:8080` | `local` | ingress routes to Web proxy |

## 8) Validation checks

After changing environment variables:

```bash
docker compose up -d
docker compose exec observai-api env | grep "OBSERVAI_"
docker compose exec observai-web env | grep "OBSERVAI_API_URL\|NEXT_PUBLIC_OBSERVAI_API_URL"
```

Then verify:

```bash
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/readyz
curl -fsS http://localhost:3000/api/observai/health
```
