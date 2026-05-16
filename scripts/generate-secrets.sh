#!/usr/bin/env bash
set -euo pipefail

generate_secret() {
  openssl rand -base64 48 | tr -d '\n'
}

cat <<EOF
JWT_SECRET=$(generate_secret)
REFRESH_TOKEN_SECRET=$(generate_secret)
ENCRYPTION_KEY=$(generate_secret)
POSTGRES_PASSWORD=$(generate_secret)
EOF
