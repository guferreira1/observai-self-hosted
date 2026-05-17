# Solução de Problemas (Português)

## Containers não iniciam

```bash
docker compose ps
docker compose logs -f
```

Causas comuns:

- Variáveis obrigatórias ausentes.
- Conflito de portas (`8080`, `3000`, `5432`, `6379`).
- Usuário/senha do banco incorretos.
- Segredo inválido (formato/tamanho).

## API encerra logo no início

```bash
docker compose logs -f observai-api
```

Verifique:

- `OBSERVAI_DATABASE_DSN`
- `OBSERVAI_REDIS_URL`
- `OBSERVAI_MIGRATE_ON_START` em banco novo.
- `OBSERVAI_JWT_SECRET`
- `OBSERVAI_ENCRYPTION_KEY`

## Web não alcança a API

Use o caminho do proxy do Web para chamadas do navegador e a URL interna da API para chamadas server-side.

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
```

Valide no browser e no endpoint:

```bash
curl -I http://localhost:3000/api/observai/health
curl -I https://observai.example.com/api/observai/v1/setup/status
```

## Health e readiness

Checks diretos na API:

```bash
curl -i http://localhost:8080/health
curl -i http://localhost:8080/healthz
curl -i http://localhost:8080/readyz
```

Check via proxy do Web:

```bash
curl -i http://localhost:3000/api/observai/health
```

`/readyz` é o endpoint principal para validação de dependências.

## PostgreSQL e Redis

```bash
docker compose logs -f postgres
docker compose exec postgres pg_isready -U observai -d observai

docker compose logs -f redis
docker compose exec redis redis-cli ping
```

## Setup inicial inacessível

1. Confirme API ativa e `readyz` com código `200`.
2. Acesse:
   - API direta: `http://localhost:8080/v1/setup/status`
   - via proxy do Web: `http://localhost:3000/api/observai/v1/setup/status`
   - produção: `https://observai.example.com/api/observai/v1/setup/status`
3. Limpe cache/cookies e tente novamente.
