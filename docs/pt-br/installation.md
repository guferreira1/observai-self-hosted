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

# Exposição local
OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000

# Caminho usado pelo navegador e destino interno Web -> API
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
NEXT_PUBLIC_APP_ENV=self-hosted

# Runtime da API
OBSERVAI_ENV=self-hosted
OBSERVAI_MODE=local
OBSERVAI_TIMEZONE=Local
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

Para login inicial, assinatura de sessão e criptografia de credenciais de provedores, gere segredos fortes:

```env
OBSERVAI_JWT_SECRET=change-me-local-jwt-secret-minimum-32-bytes
OBSERVAI_ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

Use o script:

```bash
bash scripts/generate-secrets.sh
```

`OBSERVAI_ENCRYPTION_KEY` precisa decodificar exatamente para 32 bytes. O formato recomendado pelo script é hexadecimal com 64 caracteres.

Validações básicas:

- `OBSERVAI_DATABASE_DSN` e `POSTGRES_*` devem corresponder.
- `OBSERVAI_REDIS_URL` e `REDIS_PORT` devem corresponder.
- `NEXT_PUBLIC_OBSERVAI_API_URL` deve permanecer `/api/observai` para o navegador usar o proxy do Web.
- `OBSERVAI_API_URL` deve apontar para a API acessível pelo container Web.

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

Use `docker-compose.prod.yml` e mantenha o caminho do navegador como `/api/observai`:

```bash
cp .env.example .env
# defina OBSERVAI_DOMAIN, OBSERVAI_PUBLIC_URL e segredos.
# OBSERVAI_ALLOWED_ORIGINS só é necessário quando Web e API rodam em origens
# diferentes (veja docs/pt-br/production.md "Split deployment").
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
curl http://localhost:3000/api/observai/health
```

## 6) Dependências externas

Se usar PostgreSQL/Redis externos:

```env
OBSERVAI_DATABASE_DSN=postgres://<user>:<senha>@<host>:5432/observai?sslmode=require
OBSERVAI_REDIS_URL=redis://<host>:6379/0
```

Mantenha `postgres` e `redis` internos desativados conforme seu `docker-compose override`.
