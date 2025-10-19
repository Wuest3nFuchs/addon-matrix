ARG BUILD_FROM=ghcr.io/hassio-addons/base-aarch64
FROM ${BUILD_FROM}


ENV LANG C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


# System packages: python3 + pip + common tools
RUN apk add --no-cache python3 py3-pip curl bash openssl ca-certificates tzdata sqlite


# create data user
RUN adduser -D -H -s /bin/sh synapse


WORKDIR /data


# Install a reasonably recent synapse. Pin if you want a specific version.
RUN pip3 install --no-cache-dir "matrix-synapse"


# Copy run script
COPY run.sh /run.sh
RUN chmod a+x /run.sh


USER synapse


ENTRYPOINT ["/run.sh"]
CMD []
