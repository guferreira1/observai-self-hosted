# Installation

## Requirements

- Docker
- Docker Compose

## Quick start

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
cp .env.example .env
docker compose up -d
```

Open:

```txt
http://localhost:3000
```

API:

```txt
http://localhost:8080
```

## Check containers

```bash
docker compose ps
```

## View logs

```bash
docker compose logs -f observai-api
docker compose logs -f observai-web
```

## Stop

```bash
docker compose down
```

## Remove volumes

This deletes local Postgres and Redis data.

```bash
docker compose down -v
```
