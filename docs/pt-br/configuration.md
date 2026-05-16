# Configuração (Português)

Este repositório lê variáveis de ambiente em `.env`, em `docker-compose*.yml`,
Helm e manifestos do Kubernetes.

## 1) Imagens e versões

```env
OBSERVAI_API_IMAGE=observai/observai-api
OBSERVAI_WEB_IMAGE=observai/observai-web
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0
```

Em produção, prefira tags explícitas (`v0.1.x`) e evite `latest`.

## 2) Roteamento da API no frontend

`NEXT_PUBLIC_OBSERVAI_API_URL` define a base de chamadas do dashboard:

```env
# Modo local
NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080

# Modo produção com proxy
# NEXT_PUBLIC_OBSERVAI_API_URL=/api
```

Quando o tráfego passa pelo mesmo domínio, use `/api`.

Também há variáveis para identificação visual:

```env
NEXT_PUBLIC_APP_NAME=ObservAI
NEXT_PUBLIC_APP_ENV=self-hosted
NEXT_PUBLIC_APP_VERSION=0.0.0-dev
NEXT_PUBLIC_APP_BUILD_HASH=local
```

## 3) Bootstrap da API

```env
OBSERVAI_API_PORT=8080
OBSERVAI_ENV=local
OBSERVAI_MODE=local
OBSERVAI_TIMEZONE=Local

OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations
```

`OBSERVAI_DATABASE_DSN` e `OBSERVAI_REDIS_URL` são obrigatórias.

## 4) Segredos

Este repositório usa nomes de compatibilidade:

```env
JWT_SECRET=change-me
REFRESH_TOKEN_SECRET=change-me
ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

Se preferir o padrão atual do backend:

```env
OBSERVAI_JWT_SECRET=change-me
OBSERVAI_ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

## 5) PostgreSQL e Redis

```env
POSTGRES_DB=observai
POSTGRES_USER=observai
POSTGRES_PASSWORD=change-me
POSTGRES_PORT=5432

REDIS_PORT=6379
```

`POSTGRES_*` afeta o container PostgreSQL.

`REDIS_PORT` e `OBSERVAI_REDIS_URL` afetam Redis e conexão do API.

Aliases opcionais:

```env
DATABASE_URL=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
REDIS_URL=redis://redis:6379/0
```

## 6) Ajustes avançados

Você pode repassar quaisquer variáveis do `observai-api`:

- `OBSERVAI_QUEUE_BACKEND`
- `OBSERVAI_QUEUE_CONCURRENCY`
- `OBSERVAI_QUEUE_DEQUEUE_TIMEOUT`
- `OBSERVAI_CHAT_LOCK_TTL`
- `OBSERVAI_CHAT_LOCK_WAIT`
- `OBSERVAI_ANALYSIS_CONTEXT_CACHE_TTL`

## 7) Perfil por cenário

| Cenário | NEXT_PUBLIC_OBSERVAI_API_URL | `OBSERVAI_MODE` | Observação |
| --- | --- | --- | --- |
| Local | `http://localhost:8080` | `local` | acesso direto à API |
| Proxy | `/api` | `local` | chamadas no mesmo domínio |

## 8) Validação

Após ajustar o `.env`:

```bash
docker compose up -d
docker compose exec observai-api env | rg "OBSERVAI_|NEXT_PUBLIC_"
```

E validar:

```bash
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/readyz
```
