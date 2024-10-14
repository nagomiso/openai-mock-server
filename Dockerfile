ARG NODE_IMAGE_TAG=18.20.4-bookworm

FROM node:${NODE_IMAGE_TAG} AS build

ENV PRISM_VERSION=5.10.0
ENV DUMB_INIT_VERSION=1.2.5
ENV YQ_VERSION=4.44.3

WORKDIR /app
RUN npm install @stoplight/prism-cli@${PRISM_VERSION}
COPY entrypoint.sh /app/entrypoint.sh
RUN <<-eof
    set -eux
    curl -L "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_$(uname -m)" -o /app/dumb-init
    chmod +x /app/dumb-init
    mkdir -p /app/bin
    curl -L "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_$(uname -m | sed 's/aarch64/arm64/')" -o /app/bin/yq
    chmod +x /app/bin/yq
    chmod +x /app/entrypoint.sh
eof
COPY openai-openapi/openapi.yaml /app/openapi.yaml

ARG NODE_IMAGE_TAG
FROM node:${NODE_IMAGE_TAG}-slim

ARG UID=1001
ARG GID=1001
ENV PATH="/app/bin:${PATH}"

RUN <<-eof
    set -eux
    groupadd -g ${GID} worker
    useradd -m -u ${UID} -g ${GID} worker
eof
USER worker
WORKDIR /app
COPY  --from=build --chown=woker:worker \
    /app /app
ENTRYPOINT ["/app/dumb-init", "--", "/app/entrypoint.sh"]
CMD ["/app/node_modules/.bin/prism", "mock", "-h", "0.0.0.0", "/tmp/openapi.yaml"]
