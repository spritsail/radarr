[hub]: https://hub.docker.com/r/adamant/radarr

# [adamant/radarr][hub]

[![](https://images.microbadger.com/badges/image/adamant/radarr.svg)](https://microbadger.com/images/adamant/radarr) [![Docker Pulls](https://img.shields.io/docker/pulls/adamant/radarr.svg)][hub] [![Docker Stars](https://img.shields.io/docker/stars/adamant/radarr.svg)][hub] [![Build Status](https://drone.adam-ant.co.uk/api/badges/Adam-Ant/docker-radarr/status.svg)](https://drone.adam-ant.co.uk/Adam-Ant/docker-radarr)

[Radarr](https://github.com/Radarr/Radarr) running in Alpine Linux on (for now) experimental Mono builds. This container provides some simple initial configuration scripts to set some runtime variables (see [#Configuration](#configuration) for details)

## Usage

Basic usage with default configuration:
```bash
docker run -dt
    --name=radarr
    --restart=always
    -v $PWD/config:/config
    -p 7878:7878
    adamant/radarr
```

**Note:** _Is is important to use `-t` (pseudo-tty) as without it there are no logs produced._

Advanced usage with custom configuration:
```bash
docker run -dt
    --name=radarr
    --restart=always
    -v $PWD/config:/config
    -p 7878:7878
    -e URL_BASE=/radarr
    -e ANALYTICS=false
    -e ...
    adamant/radarr
```

### Volumes

* `/config` - Radarr configuration file and database storage. Should be readable and writeable by `$UID` 

Other files accessed by Radarr such as movie directories should also be readable and writeable by `$UID` or `$GID` with sufficient permissions.

### Configuration

These configuration options set the respective options in `config.xml` and are provided as a Docker convenience.

* `LOG_LEVEL` - Options are:  `Trace`, `Debug`, `Info`. Default is `Info`
* `URL_BASE`  - Configurable by the user. Default is _empty_
* `BRANCH`    - Upstream tracking branch for updates. Options are: `master`, `develop`, _other_. Default is `develop`
* `ANALYTICS` - Truthy or falsy value `true`, `false` or similar. Default is `true`

