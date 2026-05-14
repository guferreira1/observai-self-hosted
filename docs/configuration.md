# Configuration

ObservAI Self-Hosted is configured through environment variables.

Copy the example file before starting:

```bash
cp .env.example .env
```

## Images

```env
OBSERVAI_API_IMAGE=observai/observai-api
OBSERVAI_WEB_IMAGE=observai/observai-web
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0
```

## URLs

Local mode:

```env
OBSERVAI_PUBLIC_URL=http://localhost:3000
NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080
OBSERVAI_ALLOWED_ORIGINS=http://localhost:3000
TRUST_PROXY=false
```

Production with reverse proxy:

```env
OBSERVAI_PUBLIC_URL=https://observai.example.com
NEXT_PUBLIC_OBSERVAI_API_URL=/api
OBSERVAI_ALLOWED_ORIGINS=https://observai.example.com
TRUST_PROXY=true
```

## Database

The default stack runs Postgres internally.

```env
POSTGRES_DB=observai
POSTGRES_USER=observai
POSTGRES_PASSWORD=change-me
DATABASE_URL=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
```

For external Postgres, update `DATABASE_URL` and remove or ignore the internal Postgres service.

## Redis

```env
REDIS_URL=redis://redis:6379/0
```

For external Redis, update `REDIS_URL` and remove or ignore the internal Redis service.

## Security

Change all default secrets before production:

```env
JWT_SECRET=change-me
REFRESH_TOKEN_SECRET=change-me
ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

Do not commit `.env` files.
