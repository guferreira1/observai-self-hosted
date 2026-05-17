# Installation Guide (English)

## Prerequisites

- Docker 24+
- Docker Compose v2+
- At least 4 GB RAM for local use
- Domain and DNS for production

## 1) Clone and prepare

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
cp .env.example .env
```

## 2) Edit `.env`

Set the minimum values before starting:

```env
# Images
OBSERVAI_API_IMAGE=observai/observai-api
OBSERVAI_WEB_IMAGE=observai/observai-web
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0

# Local exposure
# OBSERVAI_API_PORT is the port the API listens on inside its container.
# OBSERVAI_API_HOST_PORT is the host port Docker publishes; change only if 8080 is busy.
OBSERVAI_API_PORT=8080
OBSERVAI_API_HOST_PORT=8080
OBSERVAI_WEB_PORT=3000

# Browser API path and internal Web-to-API target
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
NEXT_PUBLIC_APP_ENV=self-hosted

# API runtime
OBSERVAI_ENV=self-hosted
OBSERVAI_MODE=local
OBSERVAI_TIMEZONE=Local
OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations

# Database service
POSTGRES_DB=observai
POSTGRES_USER=observai
POSTGRES_PASSWORD=change-me
POSTGRES_PORT=5432

# Redis service
REDIS_PORT=6379
```

For first login, session signing and provider credential encryption, generate strong secrets and set:

```env
OBSERVAI_JWT_SECRET=change-me-local-jwt-secret-minimum-32-bytes
OBSERVAI_ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

You can generate values with:

```bash
bash scripts/generate-secrets.sh
```

`OBSERVAI_ENCRYPTION_KEY` must decode to exactly 32 bytes. The recommended generated format is a 64-character hex value.

### Validation examples

- `OBSERVAI_DATABASE_DSN` and `POSTGRES_*` must match.
- `OBSERVAI_REDIS_URL` and `REDIS_PORT` must match.
- `NEXT_PUBLIC_OBSERVAI_API_URL` should remain `/api/observai` so the browser uses the Web proxy path.
- `OBSERVAI_API_URL` must point to the API address reachable from the Web container.

## 3) Start local stack

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
docker compose logs -f observai-api
docker compose logs -f observai-web
```

## 4) Start in production mode (with reverse proxy)

Use the production compose file and keep the browser API path as `/api/observai`:

```bash
cp .env.example .env
# Set OBSERVAI_DOMAIN and secrets.
# OBSERVAI_ALLOWED_ORIGINS is only needed when Web and API run on different
# origins (see docs/en/production.md "Split deployment").
# LETSENCRYPT_EMAIL is only needed with the Traefik compose profile.
docker compose -f docker-compose.prod.yml up -d
```

Expose public traffic only on port 80/443 through `nginx` or `traefik`.

## 5) Open the app and complete first setup

1. Open `http://localhost:3000`.
2. Create the first admin user on first run.
3. Log in and configure providers.

If the UI waits for the API, verify:

```bash
docker compose logs -f observai-api
curl http://localhost:8080/healthz
curl http://localhost:3000/api/observai/health
```

## 6) External PostgreSQL/Redis

If you use external dependencies, replace these internal addresses:

```env
OBSERVAI_DATABASE_DSN=postgres://<user>:<password>@<host>:5432/observai?sslmode=require
OBSERVAI_REDIS_URL=redis://<host>:6379/0
```

Keep `postgres` and `redis` services disabled/removed in your local compose override
according to your infrastructure design.
