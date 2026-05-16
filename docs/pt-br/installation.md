# Guia de Instalação (Português)

## Pré-requisitos

- Docker 24+
- Docker Compose v2+
- Pelo menos 4 GB de RAM para uso local
- Domínio e DNS configurados para produção

## 1) Clonar e preparar

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
cp .env.example .env
```

## 2) Editar `.env`

Defina os valores mínimos antes de subir a stack:

```env
# Imagens
OBSERVAI_API_IMAGE=observai/observai-api
OBSERVAI_WEB_IMAGE=observai/observai-web
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0

# Exposição da API
OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000

# URL usada pelo navegador (modo local)
NEXT_PUBLIC_OBSERVAI_API_URL=http://localhost:8080
NEXT_PUBLIC_APP_ENV=self-hosted

# Dependências principais
OBSERVAI_DATABASE_DSN=postgres://observai:change-me@postgres:5432/observai?sslmode=disable
OBSERVAI_REDIS_URL=redis://redis:6379/0
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations

# Serviço PostgreSQL
POSTGRES_DB=observai
POSTGRES_USER=observai
POSTGRES_PASSWORD=change-me
POSTGRES_PORT=5432

# Serviço Redis
REDIS_PORT=6379
```

Para autenticação e sessão, gere segredos fortes:

```env
JWT_SECRET=change-me
REFRESH_TOKEN_SECRET=change-me
ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

Use o script:

```bash
bash scripts/generate-secrets.sh
```

Os templates deste repositório aceitam esses nomes de compatibilidade.
Se você executar o API diretamente com nomeação atualizada, pode usar:

```env
OBSERVAI_JWT_SECRET=change-me
OBSERVAI_ENCRYPTION_KEY=change-me-32-byte-minimum-secret
```

Validações básicas:

- `OBSERVAI_DATABASE_DSN` e `POSTGRES_*` devem corresponder.
- `OBSERVAI_REDIS_URL` e `REDIS_PORT` devem corresponder.
- `NEXT_PUBLIC_OBSERVAI_API_URL` deve refletir o cenário real.

## 3) Subir em ambiente local

```bash
docker compose up -d
```

Verifique:

```bash
docker compose ps
docker compose logs -f observai-api
docker compose logs -f observai-web
```

## 4) Subir em produção (proxy reverso)

Use `docker-compose.prod.yml` e configure a URL do navegador como `/api`:

```bash
cp .env.example .env
# defina:
NEXT_PUBLIC_OBSERVAI_API_URL=/api
docker compose -f docker-compose.prod.yml up -d
```

Exponha tráfego público em 80/443 por `nginx` ou `traefik`.

## 5) Configuração inicial

1. Acesse `http://localhost:3000`.
2. Crie o primeiro usuário admin.
3. Faça login e configure os provedores.

Se a UI ficar aguardando API:

```bash
docker compose logs -f observai-api
curl http://localhost:8080/healthz
```

## 6) Dependências externas

Se usar PostgreSQL/Redis externos:

```env
OBSERVAI_DATABASE_DSN=postgres://<user>:<senha>@<host>:5432/observai?sslmode=require
OBSERVAI_REDIS_URL=redis://<host>:6379/0
```

Mantenha `postgres` e `redis` internos desativados conforme seu `docker-compose override`.
