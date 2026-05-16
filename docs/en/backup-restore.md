# Backup and Restore (English)

PostgreSQL holds the source of truth for ObservAI configuration and analysis history.
Redis is operational state and cache for queueing; treat it as rebuildable if needed.

## Backup

```bash
./scripts/backup-postgres.sh
```

Output pattern:

```txt
backups/observai-postgres-YYYYMMDD-HHMMSS.dump
```

## Restore

```bash
./scripts/restore-postgres.sh backups/observai-postgres-YYYYMMDD-HHMMSS.dump
```

Before opening traffic again:

- Run `/readyz`
- Validate login and admin flow
- Re-run at least one analysis creation path

## Operational recommendations

- Keep backups in object storage or a dedicated volume with retention rules.
- Encrypt backups if they contain sensitive evidence metadata.
- Test restore at least once per environment.
- Prefer native managed DB snapshots for cloud-hosted PostgreSQL.
- Automate backup retention and rotation.
