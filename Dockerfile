FROM node:18.20.4-bookworm AS build

ENV PRISM_VERSION=5.10.0
ENV DUMB_INIT_VERSION=1.2.5
ENV YQ_VERSION=4.44.3

WORKDIR /app
RUN npm install @stoplight/prism-cli@${PRISM_VERSION}
RUN <<-eof
    set -eux
    curl -L "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_$(uname -m)" -o /app/dumb-init
    chmod +x /app/dumb-init
    curl -L "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_$(uname -m | sed 's/aarch64/arm64/')" -o /app/yq
    chmod +x /app/yq
eof
COPY openai-openapi/openapi.yaml /app/openapi.yaml

FROM gcr.io/distroless/nodejs18-debian12@sha256:78672f5dce342e7724e1f691c0573cddae9379b617d7932066077e667a8d7df0
WORKDIR /app
COPY  --from=build /app /app
ENTRYPOINT ["/app/dumb-init", "--", "/nodejs/bin/node"]
CMD ["/app/node_modules/.bin/prism", "mock", "-h", "0.0.0.0", "/app/openapi.yaml"]
