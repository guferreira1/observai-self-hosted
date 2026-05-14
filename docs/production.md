# Production

The recommended first production model is a Linux VM with Docker Compose and a reverse proxy.

## Recommended model

```txt
https://observai.example.com      -> ObservAI Web
https://observai.example.com/api  -> ObservAI API
```

This avoids most CORS complexity and keeps the deployment easier to operate.

## Production checklist

- Use a real domain.
- Enable HTTPS with Nginx, Traefik, Caddy or a cloud load balancer.
- Change all default secrets.
- Use strong Postgres credentials.
- Configure backups.
- Protect the server firewall.
- Avoid exposing Postgres and Redis publicly.
- Use `TRUST_PROXY=true` behind a reverse proxy.
- Use `NEXT_PUBLIC_OBSERVAI_API_URL=/api` when proxying API through the same domain.

## Run with Nginx example

```bash
cp .env.example .env
```

Update `.env`:

```env
OBSERVAI_DOMAIN=observai.example.com
OBSERVAI_PUBLIC_URL=https://observai.example.com
NEXT_PUBLIC_OBSERVAI_API_URL=/api
OBSERVAI_ALLOWED_ORIGINS=https://observai.example.com
TRUST_PROXY=true
```

Start:

```bash
docker compose -f docker-compose.prod.yml up -d
```

The included Nginx example listens on port 80. TLS can be terminated by another proxy, load balancer, Cloudflare, or extended in the Nginx configuration.
