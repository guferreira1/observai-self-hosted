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

`NEXT_PUBLIC_OBSERVAI_API_URL` is the base path used by the frontend.

```env
# Local mode
NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080

# Production proxy mode
# NEXT_PUBLIC_OBSERVAI_API_URL=/api
```

Use `/api` when browser traffic for API and web share the same domain.

Also available for UI labeling:

```env
NEXT_PUBLIC_APP_NAME=ObservAI
NEXT_PUBLIC_APP_ENV=self-hosted
NEXT_PUBLIC_APP_VERSION=0.0.0-dev
NEXT_PUBLIC_APP_BUILD_HASH=local
```

## 3) API bootstrap variables

```env
OBSERVAI_API_PORT=8080
OBSERVAI_ENV=local
OBSERVAI_MODE=local
OBSERVAI_TIMEZONE=Local

OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations
```

`OBSERVAI_DATABASE_DSN` and `OBSERVAI_REDIS_URL` are required for startup.

## 4) Secret variables

This repository accepts these compatibility names:

```env
JWT_SECRET=change-me
REFRESH_TOKEN_SECRET=change-me
ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

If you are using the API image directly and prefer current backend naming,
use:

```env
OBSERVAI_JWT_SECRET=change-me
OBSERVAI_ENCRYPTION_KEY=change-me-32-byte-minimum-secret
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

`REDIS_*` drives the bundled Redis container and API connection.

Compatibility aliases are optional:

```env
DATABASE_URL=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
REDIS_URL=redis://redis:6379/0
```

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

| Scenario | NEXT_PUBLIC_OBSERVAI_API_URL | `OBSERVAI_MODE` | Notes |
| --- | --- | --- | --- |
| Local machine | `http://localhost:8080` | `local` | direct API access |
| Reverse proxy | `/api` | `local` | same-origin API path |

## 8) Validation checks

After changing environment variables:

```bash
docker compose up -d
docker compose exec observai-api env | rg "OBSERVAI_|NEXT_PUBLIC_"
```

Then verify:

```bash
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/readyz
```
