# Atualização (Português)

## Antes da atualização

1. Gere backup:

```bash
./scripts/backup-postgres.sh
```

2. Consulte changelogs de `observai-api` e `observai-web`.
3. Defina janela de manutenção e ponto de rollback.

## Atualizar com Compose

Atualize as versões:

```env
OBSERVAI_API_VERSION=v0.1.1
OBSERVAI_WEB_VERSION=v0.1.1
```

Aplique:

```bash
docker compose pull
docker compose up -d
```

Valide:

```bash
docker compose ps
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/readyz
```

## Atualizar com Helm

```bash
helm upgrade --install observai ./helm/observai \
  --namespace observai \
  --set image.api.tag=v0.1.1 \
  --set image.web.tag=v0.1.1
```

## Rollback

Se houver instabilidade:

1. Restaure versões anteriores em `.env` ou Helm values.
2. Refaça o deploy.
3. Valide `health`/`readyz` antes de liberar tráfego.

Se houver alteração de schema sem rollback seguro, restaure o backup antes de
tentar a versão anterior.
