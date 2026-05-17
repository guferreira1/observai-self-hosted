# Production Checklist (English)

## Recommended architecture

Use one public domain and keep browser API calls on the Web proxy path:

```txt
https://observai.example.com                  -> observai-web
https://observai.example.com/api/observai     -> API access path through observai-web
observai-web                                  -> observai-api:8080
```

This pattern avoids CORS issues, centralizes TLS and keeps the frontend aligned with the built-in Next.js proxy. In this default layout, leave `OBSERVAI_ALLOWED_ORIGINS` empty — the API never sees a cross-origin request.

### Split deployment (advanced)

If you serve the Web and API from different origins (for example `https://app.example.com` and `https://api.example.com`), enable CORS on the API by listing the Web origin in `OBSERVAI_ALLOWED_ORIGINS`:

```env
OBSERVAI_ALLOWED_ORIGINS=https://app.example.com
```

Notes:

- Comma-separate multiple origins; each entry must be an exact origin (`https://host[:port]`).
- Wildcards (`*`) are rejected. The API always sends `Access-Control-Allow-Credentials: true` so cookie-based login keeps working, and the CORS spec forbids credentials with wildcard origins.
- Preflight responses are cached for 5 minutes.
- Point the browser at the API directly with `NEXT_PUBLIC_OBSERVAI_API_URL=https://api.example.com` and unset `OBSERVAI_API_URL` (or keep it for server-side rendering only).

## Pre-production checklist

- Use fixed image tags (`v0.1.x`) and avoid `latest`.
- Keep `OBSERVAI_MIGRATE_ON_START=true` for first production boot.
- Use `NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai`.
- Use `OBSERVAI_API_URL=http://observai-api:8080` when Web and API share the same Docker/Kubernetes network.
- Use strong `OBSERVAI_JWT_SECRET` and `OBSERVAI_ENCRYPTION_KEY` values.
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
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
NEXT_PUBLIC_APP_ENV=production
LOG_LEVEL=info

OBSERVAI_ENV=self-hosted
OBSERVAI_MODE=local
OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations
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
- Keep `/api/observai` routed to the Web service unless you configure an explicit rewrite to the API root.
- If reverse proxy strips headers, forward `Host`, `X-Forwarded-*` and protocol correctly.

## Production rollout

1. Deploy in staging with production-like traffic.
2. Run first-run setup and login flow.
3. Verify:
   - `GET /health`
   - `GET /healthz`
   - `GET /readyz`
   - `GET /api/observai/health`
4. Validate backup procedure.
5. Promote DNS only after all probes pass.
