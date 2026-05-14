# Troubleshooting

## Containers are not starting

Check status:

```bash
docker compose ps
```

Check logs:

```bash
docker compose logs -f
```

## Web cannot reach API

Check `NEXT_PUBLIC_OBSERVAI_API_URL`.

Local mode:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080
```

Reverse proxy mode:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api
```

## CORS errors

Check `OBSERVAI_ALLOWED_ORIGINS`.

Example:

```env
OBSERVAI_ALLOWED_ORIGINS=https://observai.example.com
```

## Database connection errors

Check:

```env
DATABASE_URL
POSTGRES_DB
POSTGRES_USER
POSTGRES_PASSWORD
```

Then inspect Postgres logs:

```bash
docker compose logs -f postgres
```

## Redis connection errors

Check:

```env
REDIS_URL=redis://redis:6379/0
```

Then inspect Redis logs:

```bash
docker compose logs -f redis
```

## Reverse proxy not routing API

The recommended routing is:

```txt
/    -> observai-web:3000
/api -> observai-api:8080
```

Check Nginx, Traefik or Ingress configuration.
