# Upgrade

Use explicit image versions for production.

## Basic upgrade

1. Back up Postgres.
2. Update `.env` versions.
3. Pull images.
4. Restart the stack.

```bash
./scripts/backup-postgres.sh
```

Update:

```env
OBSERVAI_API_VERSION=v0.1.1
OBSERVAI_WEB_VERSION=v0.1.1
```

Apply:

```bash
docker compose pull
docker compose up -d
```

## Rollback

Set previous versions in `.env` and restart:

```bash
docker compose pull
docker compose up -d
```

If database migrations are not backward compatible, restore from backup.
