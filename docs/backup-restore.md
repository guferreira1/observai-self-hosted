# Backup and restore

PostgreSQL is the most important service to back up.

Redis is used for cache and runtime data. Persist Redis only when the application requires durable queue/session data.

## Create backup

```bash
./scripts/backup-postgres.sh
```

Backups are written to:

```txt
backups/
```

## Restore backup

```bash
./scripts/restore-postgres.sh backups/observai-postgres-YYYYMMDD-HHMMSS.dump
```

## Production recommendations

- Store backups outside the server.
- Encrypt backups when they contain sensitive data.
- Test restore regularly.
- Use managed Postgres backups when using a cloud provider.
- Back up before upgrades.
