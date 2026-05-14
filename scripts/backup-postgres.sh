#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-backups}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/observai-postgres-${TIMESTAMP}.dump"

mkdir -p "${BACKUP_DIR}"

docker compose exec -T postgres pg_dump \
  -U "${POSTGRES_USER:-observai}" \
  -d "${POSTGRES_DB:-observai}" \
  -Fc > "${BACKUP_FILE}"

echo "Backup created: ${BACKUP_FILE}"
