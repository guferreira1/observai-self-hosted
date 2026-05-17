# Troubleshooting (English)

## Containers do not start

```bash
docker compose ps
docker compose logs -f
```

Common root causes:

- Required environment variables not set.
- Port conflicts (`8080`, `3000`, `5432`, `6379`).
- Database user/password mismatch.
- Invalid secret format/length.

## API container exits immediately

```bash
docker compose logs -f observai-api
```

Check:

- `OBSERVAI_DATABASE_DSN`
- `OBSERVAI_REDIS_URL`
- `OBSERVAI_MIGRATE_ON_START` if DB is empty.
- `OBSERVAI_JWT_SECRET`
- `OBSERVAI_ENCRYPTION_KEY`

## Web cannot reach API

Use the Web proxy path for browser calls and the internal API URL for server-side proxy calls.

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
```

Then verify browser calls in devtools and endpoint:

```bash
curl -I http://localhost:3000/api/observai/health
curl -I https://observai.example.com/api/observai/v1/setup/status
```

## Health and readiness

Direct API checks:

```bash
curl -i http://localhost:8080/health
curl -i http://localhost:8080/healthz
curl -i http://localhost:8080/readyz
```

Web proxy check:

```bash
curl -i http://localhost:3000/api/observai/health
```

`/readyz` is the main readiness gate for API dependencies.

## Database and Redis checks

```bash
docker compose logs -f postgres
docker compose exec postgres pg_isready -U observai -d observai

docker compose logs -f redis
docker compose exec redis redis-cli ping
```

## First setup unreachable

1. Confirm API is running and `readyz` is `200`.
2. Open:
   - direct API: `http://localhost:8080/v1/setup/status`
   - through Web proxy: `http://localhost:3000/api/observai/v1/setup/status`
   - production: `https://observai.example.com/api/observai/v1/setup/status`
3. Re-run browser with a clean cache/cookies.
