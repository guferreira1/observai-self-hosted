# DNS and Reverse Proxy (English)

ObservAI self-hosted does not provision DNS, certificates, or WAF rules.
It expects the operator to configure these parts in their platform.

## Domain model

```txt
https://observai.example.com                  -> ObservAI Web
https://observai.example.com/api/observai     -> API access path through ObservAI Web
```

The browser should call `/api/observai`. The Web container then forwards requests to the API through `OBSERVAI_API_URL`.

## Nginx proxy mode (`docker-compose.prod.yml`)

`docker-compose.prod.yml` includes an Nginx container with:

- `location /` -> `observai-web:3000`
- `location /api/observai/` -> `observai-api:8080/`

The web must be configured with:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
```

The Nginx sample proxies `/api/observai/*` directly to the API root. Other reverse proxy implementations may route `/api/observai/*` to `observai-web:3000` and let the built-in Next.js proxy forward to the API.

## Traefik mode (`traefik/docker-compose.traefik.yml`)

Traefik routes the browser-facing model to the Web service:

- Web: `Host(${OBSERVAI_DOMAIN})`
- API path: `Host(${OBSERVAI_DOMAIN}) && PathPrefix(/api/observai)` -> `observai-web:3000`

Set:

```env
OBSERVAI_DOMAIN=observai.example.com
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
```

## DNS and certificate steps

1. Create `A`/`AAAA` record:

```txt
observai.example.com -> SERVER_PUBLIC_IP
```

2. Issue HTTPS certificates using your preferred ingress layer (Let's Encrypt, ACME,
   managed cert, etc.).

3. Keep `/api/observai` path available only through HTTPS.

## Verification

```bash
curl -I https://observai.example.com/
curl -I https://observai.example.com/api/observai/health
curl -I https://observai.example.com/api/observai/v1/setup/status
```

Expected: response `200` or the API's standard health/setup codes.
