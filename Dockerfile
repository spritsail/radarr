FROM debian:jessie
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=901 GID=900

ARG TINI_VERSION=v0.14.0
ARG SU_EXEC_VER=v0.2

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
ADD https://github.com/javabean/su-exec/releases/download/v0.2/su-exec.amd64 /usr/bin/su-exec
ADD entrypoint.sh /usr/bin/entrypoint

RUN apt-get update \
 && apt-get install -y curl libmono-cil-dev mediainfo 

RUN chmod +x /usr/bin/* \
 && radarr_tag=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" | awk '/tag_name/{print $4;exit}' FS='[""]') \
 && curl -L https://github.com/Radarr/Radarr/releases/download/${radarr_tag}/Radarr.develop.${radarr_tag#v}.linux.tar.gz | tar zxf - 


VOLUME ["/config", "/media"]

EXPOSE 7878

ENTRYPOINT ["tini","--","/usr/bin/entrypoint"]
CMD ["mono","/Radarr/Radarr.exe","--no-browser","-data=/config"]

