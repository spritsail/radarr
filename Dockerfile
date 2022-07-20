FROM spritsail/alpine:3.16

ARG RADARR_VER=4.2.0.6438
ARG RADARR_BRANCH=develop

ENV SUID=901 SGID=900

LABEL maintainer="Spritsail <radarr@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Radarr" \
      org.label-schema.url="https://radarr.video" \
      org.label-schema.description="A movie management and downloader tool" \
      org.label-schema.version=${RADARR_VER} \
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
