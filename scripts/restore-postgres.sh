#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: ./scripts/restore-postgres.sh <backup-file>"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "Backup file not found: ${BACKUP_FILE}"
  exit 1
fi

cat "${BACKUP_FILE}" | docker compose exec -T postgres pg_restore \
  -U "${POSTGRES_USER:-observai}" \
  -d "${POSTGRES_DB:-observai}" \
  --clean \
  --if-exists

echo "Restore completed from: ${BACKUP_FILE}"
