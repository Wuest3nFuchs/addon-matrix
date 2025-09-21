ARG BUILD_FROM=ghcr.io/hassio-addons/base-python/amd64:6.0.0
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH=amd64
COPY bin/yq_${BUILD_ARCH} /usr/bin/yq
COPY requirements.txt /tmp/

# Build-time deps and runtime deps separated for smaller final image
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        libjpeg-turbo-dev \
        libressl-dev \
        libxslt-dev \
        linux-headers \
        musl-dev \
        postgresql-dev \
        zlib-dev \
        curl \
        ca-certificates; \
    apk add --no-cache \
        libffi \
        libjpeg-turbo \
        libpq \
        libressl \
        libxslt \
        lua-resty-http \
        nginx-mod-http-lua \
        nginx \
        su-exec \
        tiff \
        zlib \
        bash; \
    pip3 install --no-cache-dir --find-links "https://wheels.home-assistant.io/alpine-3.11/${BUILD_ARCH}/" -r /tmp/requirements.txt; \
    mkdir -p /opt/riot; \
    curl -fSL -o /tmp/riot.tar.gz "https://github.com/vector-im/element-web/releases/download/v1.11.112/element-v1.11.112.tar.gz"; \
    echo "REPLACE_SHA256  /tmp/riot.tar.gz" | sha256sum -c -; \
    tar -xzf /tmp/riot.tar.gz -C /opt/riot --strip-components=1; \
    rm -rf /root/.cache/pip /tmp/pip-* /tmp/*.log /var/cache/apk/* /tmp/riot.tar.gz; \
    find /usr/local -type d \$ -name test -o -name tests -o -name '__pycache__' \$ -prune -exec rm -rf '{}' +; \
    chown -R root:root /opt/riot; \
    apk del --purge .build-deps; \
    rm -f /etc/nginx/conf.d/default.conf || true

COPY rootfs /

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Timmo <contact@timmo.xyz>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Timmo <contact@timmo.xyz>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
