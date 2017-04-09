FROM debian:jessie
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=901 UNAME=radarr GID=900 GNAME=media

RUN apt-get update \
 && apt-get install -y curl libmono-cil-dev mediainfo 

RUN groupadd -g $GID $GNAME \
 && useradd -rM -u $UID -G $GNAME -s /usr/sbin/nologin $UNAME \
 && radarr_tag=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" | awk '/tag_name/{print $4;exit}' FS='[""]') \
 && curl -L https://github.com/Radarr/Radarr/releases/download/${radarr_tag}/Radarr.develop.${radarr_tag#v}.linux.tar.gz | tar zxf - \
 && chown -R $UID:$UID /Radarr

USER $UNAME

VOLUME ["/config", "/media"]

EXPOSE 7878

CMD ["mono","/Radarr/Radarr.exe","--no-browser","-data=/config"]

