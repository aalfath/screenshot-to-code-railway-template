# Screenshot to Code web UI for Railway: the built React frontend served by Caddy,
# behind HTTP basic auth, proxying the API and WebSocket to the private backend.
FROM node:22.23.5-bookworm-slim@sha256:e9f565d32859f0cbfb52125eafe8be39390f24dac302dc3cdf566e8ba3ab21ee AS build

# Keep in step with backend/Dockerfile.
ARG S2C_COMMIT=f2e5bbdd1dd5d93c259548d9bccf54e2a5f06a30

ADD https://github.com/abi/screenshot-to-code/archive/${S2C_COMMIT}.tar.gz /tmp/s2c.tar.gz
RUN mkdir -p /src \
    && tar -xzf /tmp/s2c.tar.gz --strip-components=1 -C /src \
    && rm /tmp/s2c.tar.gz
WORKDIR /src/frontend
ENV NODE_OPTIONS=--max-old-space-size=3072 \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
    PUPPETEER_SKIP_DOWNLOAD=true
RUN corepack enable \
    && pnpm install --frozen-lockfile \
    && pnpm build

FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0
COPY --from=build /src/frontend/dist /srv
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /usr/local/bin/s2c-web
RUN chmod 755 /usr/local/bin/s2c-web
EXPOSE 8080
CMD ["/usr/local/bin/s2c-web"]
