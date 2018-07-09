FROM debian:stretch-slim

ARG RADARR_TAG=0.2.0.1120
ARG TINI_VER=v0.17.0
ARG SU_EXEC_VER=v0.3

LABEL maintainer="Spritsail <radarr@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Radarr" \
      org.label-schema.url="https://radarr.video" \
      org.label-schema.description="A movie management and downloader tool" \
      org.label-schema.version=${RADARR_TAG} \
      io.spritsail.version.radarr=${RADARR_TAG} \
      io.spritsail.version.tini=${TINI_VER} \
      io.spritsail.version.su-exec=${SU_EXEC_VER}

ENV UID=901 GID=900

# Copy in bootstrap scripts
COPY *.sh /usr/local/bin/

RUN apt-get update \
 && apt-get install -y libmono-cil-dev mediainfo xmlstarlet curl jq \
 && curl -fsSLo sbin/su-exec https://github.com/frebib/su-exec/releases/download/${SU_EXEC_VER}/su-exec-x86_64 \
 && curl -fsSLo sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VER}/tini-amd64 \
 && chmod +x sbin/su-exec sbin/tini usr/local/bin/*.sh \
 && mkdir -p /radarr \
 && curl -fL "https://github.com/Radarr/Radarr/releases/download/v${RADARR_TAG}/Radarr.develop.${RADARR_TAG}.linux.tar.gz" \
        | tar xz -C /radarr --strip-components=1 \
 && find /radarr -type f -exec chmod 644 {} + \
 && find /radarr -type d -o -name '*.exe' -exec chmod 755 {} + \
    \
 && apt-get remove -y curl jq openssl \
 && apt-get autoremove -y

VOLUME ["/config", "/media"]
ENV XDG_CONFIG_HOME=/config

EXPOSE 7878

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["mono", "/radarr/Radarr.exe", "--no-browser", "--data=/config"]
