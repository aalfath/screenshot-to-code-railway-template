#!/bin/sh
set -eu
# Never serve the app without a login.
if [ -z "${BASIC_AUTH_PASSWORD:-}" ]; then
  echo "BASIC_AUTH_PASSWORD is empty: refusing to start without a login." >&2
  exit 1
fi
: "${BACKEND_URL:?BACKEND_URL is required, for example http://backend.railway.internal:7001}"
export PORT="${PORT:-8080}"
export BASIC_AUTH_USERNAME="${BASIC_AUTH_USERNAME:-admin}"
BASIC_AUTH_HASH="$(caddy hash-password --plaintext "$BASIC_AUTH_PASSWORD")"
export BASIC_AUTH_HASH
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
