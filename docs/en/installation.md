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

# API exposure
OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000

# API URL used by browser (local mode)
NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080
NEXT_PUBLIC_APP_ENV=self-hosted

# Core dependencies
OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true

# Database service
POSTGRES_DB=observai
POSTGRES_USER=observai
POSTGRES_PASSWORD=change-me
POSTGRES_PORT=5432

# Redis service
REDIS_PORT=6379
```

For first login and session security, generate strong secrets and set:

```env
JWT_SECRET=change-me
REFRESH_TOKEN_SECRET=change-me
ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

You can generate values with:

```bash
bash scripts/generate-secrets.sh
```

The self-hosted templates in this repository still accept these compatibility names for
the API auth secrets. If you run the API container with a custom configuration,
prefer the upstream API names:

```env
OBSERVAI_JWT_SECRET=change-me
OBSERVAI_ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

### Validation examples

- `OBSERVAI_DATABASE_DSN` and `POSTGRES_*` must match.
- `OBSERVAI_REDIS_URL` and `REDIS_PORT` must match.
- `NEXT_PUBLIC_OBSERVAI_API_URL` must match your deployment topology.

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

Use the production compose file and point the web app through `/api`:

```bash
cp .env.example .env
# Set:
NEXT_PUBLIC_OBSERVAI_API_URL=/api
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
```

## 6) External PostgreSQL/Redis

If you use external dependencies, replace these internal addresses:

```env
OBSERVAI_DATABASE_DSN=postgres://<user>:<password>@<host>:5432/observai?sslmode=require
OBSERVAI_REDIS_URL=redis://<host>:6379/0
```

Keep `postgres` and `redis` services disabled/removed in your local compose override
according to your infrastructure design.
