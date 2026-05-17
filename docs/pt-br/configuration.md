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

`NEXT_PUBLIC_OBSERVAI_API_URL` define a base usada pelo navegador.
Mantenha no caminho do proxy do Web:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
```

`OBSERVAI_API_URL` é usado pelo proxy server-side do Next.js para acessar a API dentro da rede do deploy:

```env
OBSERVAI_API_URL=http://observai-api:8080
```

Com esse modelo:

```txt
Browser -> /api/observai/* -> observai-web -> observai-api:8080
```

Também há variáveis para identificação visual:

```env
NEXT_PUBLIC_APP_NAME=ObservAI
NEXT_PUBLIC_APP_ENV=self-hosted
NEXT_PUBLIC_APP_VERSION=0.0.0-dev
NEXT_PUBLIC_APP_BUILD_HASH=local
```

## 3) Bootstrap da API

`OBSERVAI_API_PORT` é a porta em que o processo Go escuta dentro do container.
`OBSERVAI_API_HOST_PORT` é a porta que o Docker publica no host na stack Compose
padrão — ajuste quando algo no host já estiver usando a 8080. As duas têm 8080
como default e podem variar independentemente.

```env
OBSERVAI_API_PORT=8080
OBSERVAI_API_HOST_PORT=8080
OBSERVAI_ENV=self-hosted
OBSERVAI_MODE=local
OBSERVAI_TIMEZONE=Local

OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations
```

`OBSERVAI_DATABASE_DSN` e `OBSERVAI_REDIS_URL` são necessárias quando a stack roda com PostgreSQL e Redis.

## 4) Segredos

Use os nomes atuais esperados pela API:

```env
OBSERVAI_JWT_SECRET=change-me-local-jwt-secret-minimum-32-bytes
OBSERVAI_ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

`OBSERVAI_JWT_SECRET` deve ter pelo menos 32 bytes em ambientes não demonstrativos.
`OBSERVAI_ENCRYPTION_KEY` precisa decodificar exatamente para 32 bytes. O formato recomendado é hexadecimal com 64 caracteres.

Gere valores compatíveis com:

```bash
bash scripts/generate-secrets.sh
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

`REDIS_PORT` afeta o container Redis e `OBSERVAI_REDIS_URL` afeta a conexão da API.

## 6) Ajustes avançados

Você pode repassar quaisquer variáveis do `observai-api`:

- `OBSERVAI_QUEUE_BACKEND`
- `OBSERVAI_QUEUE_CONCURRENCY`
- `OBSERVAI_QUEUE_DEQUEUE_TIMEOUT`
- `OBSERVAI_CHAT_LOCK_TTL`
- `OBSERVAI_CHAT_LOCK_WAIT`
- `OBSERVAI_ANALYSIS_CONTEXT_CACHE_TTL`

## 7) Perfil por cenário

| Cenário | NEXT_PUBLIC_OBSERVAI_API_URL | OBSERVAI_API_URL | `OBSERVAI_MODE` | Observação |
| --- | --- | --- | --- | --- |
| Docker Compose local | `/api/observai` | `http://observai-api:8080` | `local` | navegador usa proxy do Web |
| Proxy reverso | `/api/observai` | `http://observai-api:8080` | `local` | chamadas no mesmo domínio |
| Kubernetes/Helm | `/api/observai` | `http://observai-api:8080` | `local` | ingress aponta para o proxy do Web |

## 8) Validação

Após ajustar o `.env`:

```bash
docker compose up -d
docker compose exec observai-api env | grep "OBSERVAI_"
docker compose exec observai-web env | grep "OBSERVAI_API_URL\|NEXT_PUBLIC_OBSERVAI_API_URL"
```

E validar:

```bash
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/readyz
curl -fsS http://localhost:3000/api/observai/health
```
