# Upgrade (English)

## Before upgrade

1. Backup PostgreSQL:

```bash
./scripts/backup-postgres.sh
```

2. Check release notes for both `observai-api` and `observai-web`.
3. Choose a maintenance window and, if possible, a rollback point.

## Compose upgrade

Update image versions:

```env
OBSERVAI_API_VERSION=v0.1.1
OBSERVAI_WEB_VERSION=v0.1.1
```

Apply:

```bash
docker compose pull
docker compose up -d
```

Validate:

```bash
docker compose ps
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/readyz
```

## Helm upgrade

```bash
helm upgrade --install observai ./helm/observai \
  --namespace observai \
  --set image.api.tag=v0.1.1 \
  --set image.web.tag=v0.1.1
```

## Rollback

If an upgrade introduces instability:

1. Reapply previous `OBSERVAI_*_VERSION` values or previous Helm tags.
2. Re-run the deployment.
3. Re-check health/readiness before opening traffic.

If a database migration is irreversible, restore from the latest backup before retry.
