FROM spritsail/alpine:3.18

ARG RADARR_VER=5.4.5.8715
ARG RADARR_BRANCH=develop

ENV SUID=901 SGID=900

LABEL org.opencontainers.image.authors="Spritsail <radarr@spritsail.io>" \
      org.opencontainers.image.title="Radarr" \
      org.opencontainers.image.url="https://radarr.video" \
      org.opencontainers.image.description="A movie management and downloader tool" \
      org.opencontainers.image.version=${RADARR_VER} \
      io.spritsail.version.radarr=${RADARR_VER}

WORKDIR /radarr

COPY --chmod=755 *.sh /usr/local/bin/

RUN apk add --no-cache \
        icu-libs \
        libintl \
        libmediainfo \
        sqlite-libs \
        xmlstarlet \
 && test "$(uname -m)" = aarch64 && ARCH=arm64 || ARCH=x64 \
 && wget -O- https://github.com/Radarr/Radarr/releases/download/v${RADARR_VER}/Radarr.${RADARR_BRANCH}.${RADARR_VER}.linux-musl-core-${ARCH}.tar.gz \
        | tar xz --strip-components=1 \
 && rm -rf Radarr.Update

VOLUME /config
ENV XDG_CONFIG_HOME=/config

EXPOSE 7878

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null 'http://localhost:7878/api/v3/system/status' \
            --header "x-api-key: $(xmlstarlet sel -t -v '/Config/ApiKey' /config/config.xml)"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["/radarr/Radarr", "--no-browser", "--data=/config"]
