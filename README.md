[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/screenshot-to-code?utm_medium=integration&utm_source=button&utm_campaign=screenshot-to-code)

# Screenshot to Code on Railway

A Railway template for [Screenshot to Code](https://github.com/abi/screenshot-to-code) (MIT): turn a screenshot, mockup, screen recording or text prompt into HTML/Tailwind, React, Vue, Bootstrap or Ionic code with OpenAI, Anthropic or Gemini models.

**Version:** upstream commit [`f2e5bbd`](https://github.com/abi/screenshot-to-code/commit/f2e5bbdd1dd5d93c259548d9bccf54e2a5f06a30) (2026-11-15). Upstream publishes no releases, tags or images, so both services build that exact commit.

## What it deploys

| Service | Folder | What it does |
|---|---|---|
| **Screenshot to Code** (public) | `web/` | The React frontend, built at the pinned commit and served by Caddy 2.11.9. HTTP basic auth on everything except `/healthz`. It forwards `/generate-code` (WebSocket), `/api/*` and `/local-assets/*` to Backend over Railway's private network. Upstream's eval and debug routes are not exposed. |
| **Backend** (private) | `backend/` | Upstream's FastAPI backend with Playwright Chromium (used for URL screenshots and the agent's preview check). No public domain. Volume on `/data` for design systems, saved image assets and run logs. |

Base images, pinned by digest: `python:3.12.16-slim-bookworm`, `node:22.23.5-bookworm-slim` (build only), `caddy:2.11.9-alpine`.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| Screenshot to Code | `BASIC_AUTH_USERNAME` | `admin` | Login name. |
| Screenshot to Code | `BASIC_AUTH_PASSWORD` | `${{secret(32)}}` | Generated login password. The service refuses to start without one. |
| Screenshot to Code | `BACKEND_URL` | `http://${{Backend.RAILWAY_PRIVATE_DOMAIN}}:${{Backend.PORT}}` | Private address of Backend. |
| Screenshot to Code | `PORT` | `8080` | |
| Backend | `PORT` | `7001` | |

No AI key is asked for at deploy time. Open the app, click the gear icon and paste an OpenAI, Anthropic or Gemini key: the browser keeps it and sends it with each request. To set a key for every user of your instance instead, add `OPENAI_API_KEY`, `ANTHROPIC_API_KEY` or `GEMINI_API_KEY` (and optionally `OPENAI_BASE_URL`, `REPLICATE_API_KEY`) to the **Backend** service.

## After deploying

1. Open the **Screenshot to Code** service's variables and copy `BASIC_AUTH_PASSWORD`.
2. Open its public URL and log in as `admin`.
3. Click the gear icon, add a model provider key, then upload a screenshot.

## Updates

Railway tells deployers when this repo's `main` changes. Each update bumps `S2C_COMMIT` in both Dockerfiles (and the base image pins when needed) and is listed in [CHANGELOG.md](CHANGELOG.md), breaking changes first. Your data stays on the Backend volume across updates.

## Run locally

```sh
BASIC_AUTH_PASSWORD=change-me docker compose up --build
# open http://localhost:8080 and log in as admin / change-me
```
