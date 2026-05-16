# DNS and Reverse Proxy (English)

ObservAI self-hosted does not provision DNS, certificates, or WAF rules.
It expects the operator to configure these parts in their platform.

## Domain model

```txt
https://observai.example.com      -> ObservAI Web
https://observai.example.com/api  -> ObservAI API
```

## Nginx proxy mode (`docker-compose.prod.yml`)

`docker-compose.prod.yml` includes an Nginx container with:

- `location /` -> `observai-web:3000`
- `location /api/` -> `observai-api:8080`

The web must be configured with:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api
```

## Traefik mode (`traefik/docker-compose.traefik.yml`)

Traefik routes the same model via labels:

- Web: `Host(${OBSERVAI_DOMAIN})`
- API: `Host(${OBSERVAI_DOMAIN}) && PathPrefix(/api)`

Set:

```env
OBSERVAI_DOMAIN=observai.example.com
```

## DNS and certificate steps

1. Create `A`/`AAAA` record:

```txt
observai.example.com -> SERVER_PUBLIC_IP
```

2. Issue HTTPS certificates using your preferred ingress layer (Let's Encrypt, ACME,
   managed cert, etc.).

3. Keep `/api` path available only through HTTPS.

## Verification

```bash
curl -I https://observai.example.com/
curl -I https://observai.example.com/api/health
curl -I https://observai.example.com/api/v1/setup/status
```

Expected: response `200` or the API's standard health codes.
