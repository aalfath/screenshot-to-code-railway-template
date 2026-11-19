# Changelog

## 2026-11-19: first release

- Screenshot to Code at upstream commit `f2e5bbd` (2026-11-15).
- Two services: **Screenshot to Code** (Caddy 2.11.9 serving the built frontend, basic auth with a generated password, `/healthz`) and **Backend** (FastAPI + Playwright Chromium on Python 3.12.16, private only, volume on `/data`).
- Backend listens on one dual-stack socket so Railway's private network reaches it over IPv6 and IPv4.
- Deploy on Railway button in the README.
