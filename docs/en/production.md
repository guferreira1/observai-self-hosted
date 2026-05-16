# Production Checklist (English)

## Recommended architecture

Use one public domain and route API calls through `/api`:

```txt
https://observai.example.com      -> observai-web
https://observai.example.com/api  -> observai-api
```

This pattern avoids CORS issues and centralizes TLS.

## Pre-production checklist

- Use fixed image tags (`v0.1.x`) and avoid `latest`.
- Keep `OBSERVAI_MIGRATE_ON_START=true` for first production boot.
- Use strong secrets and never reuse them between environments.
- Keep PostgreSQL and Redis with non-default credentials.
- Expose only needed ports.
- Validate backups before opening traffic.
- Add alerting and logs for health and readiness probes.

Security checklist:

- HTTPS only, with redirect from HTTP.
- Set `Secure` cookie policy at the reverse proxy.
- Use `Content-Security-Policy`, `X-Frame-Options`, `Referrer-Policy` and `HSTS`
  according to your security baseline.
- Keep management ports internal only.

## Suggested production `.env` values

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api
NEXT_PUBLIC_APP_ENV=production
LOG_LEVEL=info

OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000
OBSERVAI_MIGRATE_ON_START=true
```

## Production startup

```bash
cp .env.example .env
docker compose -f docker-compose.prod.yml up -d
```

`docker-compose.prod.yml` binds internal service ports and forwards traffic through
`nginx` on port 80. If you need HTTPS and automatic certificates, use
`traefik/docker-compose.traefik.yml`.

## Reverse proxy hardening

- Force HTTPS with HSTS.
- Keep websocket support enabled when needed by frontend features.
- If reverse proxy strips headers, forward `Host`, `X-Forwarded-*` and protocol
  correctly.

## Production rollout

1. Deploy in staging with production-like traffic.
2. Run first-run setup and login flow.
3. Verify:
   - `GET /health`
   - `GET /healthz`
   - `GET /readyz`
4. Validate backup procedure.
5. Promote DNS only after all probes pass.
