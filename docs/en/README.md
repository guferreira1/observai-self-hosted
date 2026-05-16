# ObservAI Self-Hosted Documentation

This repository contains everything needed to run ObservAI in a self-hosted environment:

- `observai-api` (backend API)
- `observai-web` (frontend dashboard)
- PostgreSQL and Redis
- Docker Compose and Kubernetes deployment examples

The backend and frontend source code is maintained in:

- `observai-api`
- `observai-web`

## Recommended reading

- [Installation](installation.md)
- [Configuration](configuration.md)
- [Production guide](production.md)
- [DNS and reverse proxy](dns-and-reverse-proxy.md)
- [Kubernetes](kubernetes.md)
- [Docker Hub registry](docker-hub.md)
- [Upgrade](upgrade.md)
- [Troubleshooting](troubleshooting.md)
- [Backup and restore](backup-restore.md)

## Supported documentation languages

- English: `docs/en/*`
- Portuguese: `docs/pt-br/*`

## Quick architecture

### Local (default)

```txt
Browser
  -> observai-web (HTTP 3000)
     -> NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080
        -> observai-api (HTTP 8080)
  -> PostgreSQL (stateful)
  -> Redis (queue/cache)
```

### Production with reverse proxy

```txt
https://observai.example.com      -> observai-web
https://observai.example.com/api  -> observai-api
```

In production we recommend `NEXT_PUBLIC_OBSERVAI_API_URL=/api` so browser requests
are same-origin and proxy routing is clear.

## Minimal startup

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
cp .env.example .env
docker compose up -d
```

Then open:

- `http://localhost:3000` (web)
- `http://localhost:8080/healthz` (API readiness probe)

## Why this repository

If you need operational assets for production deployment (proxy, Kubernetes, upgrade,
backup/restore and troubleshooting), this is the right place to use.

If you need backend domain contracts, API internals or provider adapters, use
the `observai-api` repository instead.
