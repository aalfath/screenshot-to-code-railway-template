# Screenshot to Code backend (FastAPI + Playwright Chromium) for Railway.
# Upstream publishes no releases or images, so we build a pinned upstream commit.
FROM python:3.12.16-slim-bookworm@sha256:935c3c5b12357a7e10caa9c1e6ca5692344d97cf229832ef584be2cec9fc03df

# abi/screenshot-to-code commit (2026-11-15). Bump it here and note it in CHANGELOG.md.
ARG S2C_COMMIT=f2e5bbdd1dd5d93c259548d9bccf54e2a5f06a30
ARG POETRY_VERSION=2.4.1

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

ADD https://github.com/abi/screenshot-to-code/archive/${S2C_COMMIT}.tar.gz /tmp/s2c.tar.gz
RUN mkdir -p /tmp/s2c \
    && tar -xzf /tmp/s2c.tar.gz --strip-components=1 -C /tmp/s2c \
    && mv /tmp/s2c/backend /app \
    && rm -r /tmp/s2c /tmp/s2c.tar.gz

WORKDIR /app
# Install the locked dependencies into the system Python, then drop Poetry.
RUN python -m venv /opt/poetry \
    && /opt/poetry/bin/pip install "poetry==${POETRY_VERSION}" \
    && POETRY_VIRTUALENVS_CREATE=false /opt/poetry/bin/poetry install --only main --no-root --no-interaction --no-ansi \
    && rm -r /opt/poetry \
    && playwright install --with-deps chromium \
    && (rm -r /var/lib/apt/lists/* /root/.cache 2>/dev/null || true)

COPY start.sh /usr/local/bin/s2c-backend
COPY serve.py /usr/local/bin/s2c-serve.py
RUN chmod 755 /usr/local/bin/s2c-backend

# Design systems, saved assets and run logs live here: mount a volume on /data.
ENV SCREENSHOT_TO_CODE_DATA_DIR=/data \
    LOCAL_ASSET_DIR=/data/local_assets \
    LOGS_PATH=/data
EXPOSE 7001
CMD ["/usr/local/bin/s2c-backend"]
