FROM node:18.20.4-bookworm AS build
ARG ARCH

WORKDIR /app
RUN <<-eof
    set -eux
    npm install @stoplight/prism-cli@5.10.0
    curl -L "https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_$(uname -m)" -o /app/dumb-init
    chmod +x /app/dumb-init
eof
COPY openai-openapi/openapi.yaml /app/openapi.yaml

FROM gcr.io/distroless/nodejs18-debian12@sha256:78672f5dce342e7724e1f691c0573cddae9379b617d7932066077e667a8d7df0
WORKDIR /app
COPY  --from=build /app /app
ENTRYPOINT ["/app/dumb-init", "--", "/nodejs/bin/node"]
CMD ["/app/node_modules/.bin/prism", "mock", "-h", "0.0.0.0", "/app/openapi.yaml"]
