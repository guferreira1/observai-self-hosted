#!/usr/bin/env bash
set -euo pipefail

generate_secret() {
  openssl rand -base64 48 | tr -d '\n'
}

generate_encryption_key() {
  openssl rand -hex 32
}

cat <<EOF
OBSERVAI_JWT_SECRET=$(generate_secret)
OBSERVAI_ENCRYPTION_KEY=$(generate_encryption_key)
POSTGRES_PASSWORD=$(generate_secret)
EOF
