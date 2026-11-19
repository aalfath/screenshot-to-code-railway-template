#!/bin/sh
set -eu
mkdir -p "${SCREENSHOT_TO_CODE_DATA_DIR:-/data}" "${LOCAL_ASSET_DIR:-/data/local_assets}"
cd /app
exec python /usr/local/bin/s2c-serve.py
