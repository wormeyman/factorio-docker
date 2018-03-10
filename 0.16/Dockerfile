FROM frolvlad/alpine-glibc:alpine-3.7

MAINTAINER https://github.com/dtandersen/docker_factorio_server

ARG USER=factorio
ARG GROUP=factorio
ARG PUID=845
ARG PGID=845

VOLUME /factorio

ENV PORT=34197 \
    RCON_PORT=27015 \
    VERSION=0.16.28 \
    SHA1=3596b267e249bfb38444ee679bffba0e17a09e31

RUN mkdir -p /opt /factorio && \
    apk add --update --no-cache pwgen && \
    apk add --update --no-cache --virtual .build-deps curl && \
    curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 \
        -o /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    echo "$SHA1  /tmp/factorio_headless_x64_$VERSION.tar.xz" | sha1sum -c && \
    tar xf /tmp/factorio_headless_x64_$VERSION.tar.xz --directory /opt && \
    chmod ugo=rwx /opt/factorio && \
    rm /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    ln -s -F -f /factorio/saves /opt/factorio/saves && \
    ln -s -F -f /factorio/mods /opt/factorio/mods && \
    ln -s -F -f /factorio/scenarios /opt/factorio/scenarios && \
    ln -s -F -f /factorio/entrypoints /opt/factorio/entrypoints && \
    apk del .build-deps && \
    addgroup -g $PGID -S $GROUP && \
    adduser -u $PUID -G $GROUP -s /bin/sh -SDH $USER && \
    chown -R $USER:$GROUP /opt/factorio /factorio



EXPOSE $PORT/udp $RCON_PORT/tcp

COPY ./docker-entrypoint.sh /
COPY ./scenario2map.sh /factorio/entrypoints
COPY ./scenario.sh /factorio/entrypoints

USER $USER

ENTRYPOINT ["/docker-entrypoint.sh"]
