FROM spritsail/mono:4.5

ARG RADARR_VER=0.2.0.1120

ENV SUID=901 SGID=900

LABEL maintainer="Spritsail <radarr@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Radarr" \
      org.label-schema.url="https://radarr.video" \
      org.label-schema.description="A movie management and downloader tool" \
      org.label-schema.version=${RADARR_VER} \
      io.spritsail.version.radarr=${RADARR_VER}

WORKDIR /radarr

COPY *.sh /usr/local/bin/

RUN apk add --no-cache sqlite-libs libmediainfo-patched xmlstarlet \
 && wget -O- https://github.com/Radarr/Radarr/releases/download/v${RADARR_VER}/Radarr.develop.${RADARR_VER}.linux.tar.gz \
        | tar xz --strip-components=1 \
 && find -type f -exec chmod 644 {} + \
 && find -type d -o -name '*.exe' -exec chmod 755 {} + \
 && find -name '*.mdb' -delete \
# Where we're going, we don't need ~roads~ updates!
 && rm -rf NzbDrone.Update \
 && chmod +x /usr/local/bin/*.sh

VOLUME /config
ENV XDG_CONFIG_HOME=/config

EXPOSE 7878

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null 'http://localhost:7878/api/system/status' \
            --header "x-api-key: $(xmlstarlet sel -t -v '/Config/ApiKey' /config/config.xml)"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["mono", "/radarr/Radarr.exe", "--no-browser", "--data=/config"]
