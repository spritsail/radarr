FROM spritsail/alpine:3.13

ARG RADARR_VER=3.2.1.5070

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
 && wget -O- https://github.com/Radarr/Radarr/releases/download/v${RADARR_VER}/Radarr.master.${RADARR_VER}.linux-musl-core-x64.tar.gz \
        | tar xz --strip-components=1 \
 && rm -rf Radarr.Update

VOLUME /config
ENV XDG_CONFIG_HOME=/config

EXPOSE 7878

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null 'http://localhost:7878/api/system/status' \
            --header "x-api-key: $(xmlstarlet sel -t -v '/Config/ApiKey' /config/config.xml)"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["/radarr/Radarr", "--no-browser", "--data=/config"]
