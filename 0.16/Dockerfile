FROM frolvlad/alpine-glibc:alpine-3.6

MAINTAINER https://github.com/dtandersen/docker_factorio_server

ARG USER=factorio
ARG GROUP=factorio
ARG PUID=845
ARG PGID=845

ENV PORT=34197 \
    RCON_PORT=27015 \
    VERSION=0.16.1 \
    SHA1=1247cdb57b8146896f1972c60911fe45119c384b

VOLUME /factorio

RUN mkdir -p /opt && \
    apk add --update --no-cache pwgen && \
    apk add --update --no-cache --virtual .build-deps curl && \
    curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 \
        -o /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    echo "$SHA1  /tmp/factorio_headless_x64_$VERSION.tar.xz" | sha1sum -c && \
    tar xf /tmp/factorio_headless_x64_$VERSION.tar.xz --directory /opt && \
    chmod -R ugo=rwx /opt/factorio && \
    rm /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    ln -s /factorio/saves /opt/factorio/saves && \
    ln -s /factorio/mods /opt/factorio/mods && \
    apk del .build-deps && \
    addgroup -g $PGID -S $GROUP && \
    adduser -u $PUID -G $USER -s /bin/sh -SDH $GROUP && \
    chown -R $USER:$GROUP /opt/factorio /factorio

EXPOSE $PORT/udp $RCON_PORT/tcp

COPY ./docker-entrypoint.sh /

USER $USER

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/factorio/bin/x64/factorio", \
    "--port", "$PORT", \
    "--start-server-load-latest", \
    "--server-settings $CONFIG/server-settings.json", \
    "--server-whitelist $CONFIG/server-whitelist.json", \
    "--server-banlist $CONFIG/server-banlist.json", \
    "--rcon-port $RCON_PORT", \
    "--rcon-password", "$(cat $CONFIG/rconpw)", \
    "--server-id /factorio/config/server-id.json" \
    ]
