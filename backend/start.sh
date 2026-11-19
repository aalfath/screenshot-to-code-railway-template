#!/bin/sh
set -eu
mkdir -p "${SCREENSHOT_TO_CODE_DATA_DIR:-/data}" "${LOCAL_ASSET_DIR:-/data/local_assets}"
cd /app
# "::" listens on IPv6 and IPv4, so Railway's private network reaches it either way.
exec python -m uvicorn main:app --host "${HOST:-::}" --port "${PORT:-7001}" --ws-max-size 67108864
