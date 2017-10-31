FROM alpine:edge
LABEL maintainer="Adam Dodman <adam.dodman@gmx.com>"

ENV UID=901 GID=900

ARG RADARR_TAG

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
 && apk --no-cache add mono@testing mediainfo xmlstarlet su-exec tini \
 && apk --no-cache add -t build_deps jq \
    \
 && if [ -z "$RADARR_TAG" ]; then \
        export RADARR_TAG="$(wget -O- "https://api.github.com/repos/Radarr/Radarr/releases" | jq -r '.[0].tag_name')"; \
    fi \
 && mkdir -p /radarr \
 && echo "Building Radarr $RADARR_TAG" \
 && wget -O- https://github.com/Radarr/Radarr/releases/download/${RADARR_TAG}/Radarr.develop.${RADARR_TAG#v}.linux.tar.gz \
        | tar xz -C /radarr --strip-components=1 \
 && find /radarr -type f -exec chmod 644 {} + \
 && find /radarr -type d -o -name '*.exe' -exec chmod 755 {} + \
    \
 && apk --no-cache del build_deps

VOLUME ["/config", "/media"]

EXPOSE 7878

COPY *.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["mono", "/radarr/Radarr.exe", "--no-browser", "--data=/config"]
