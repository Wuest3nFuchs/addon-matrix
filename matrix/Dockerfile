ARG BUILD_FROM=ghcr.io/hassio-addons/base:14  # Alpine + Python 3.12
# Installs Synapse, Element, PostgreSQL deps
COPY rootfs/ /
RUN apk add --no-cache python3 py3-pip ...
# Builds Matrix-Server
WORKDIR /matrix
CMD ["/usr/bin/with-contenv", "bash", "/matrix/run.sh"]
