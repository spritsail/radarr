[hub]: https://hub.docker.com/r/spritsail/radarr
[git]: https://github.com/spritsail/radarr
[drone]: https://drone.spritsail.io/spritsail/radarr
[mbdg]: https://microbadger.com/images/spritsail/radarr

# [Spritsail/Radarr][hub]
[![Layers](https://images.microbadger.com/badges/image/spritsail/radarr.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/radarr.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/radarr.svg)][git]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/radarr.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/radarr.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/radarr/status.svg)][drone]


[Radarr](https://github.com/Radarr/Radarr) running in Debian Stretch. This container provides some simple initial configuration scripts to set some runtime variables (see [#Configuration](#configuration) for details)

## Usage

Basic usage with default configuration:
```bash
docker run -dt
    --name=radarr
    --restart=on-failure:10
    -v $PWD/config:/config
    -p 7878:7878
    spritsail/radarr
```

**Note:** _Is is important to use `-t` (pseudo-tty) as without it there are no logs produced._

Advanced usage with custom configuration:
```bash
docker run -dt
    --name=radarr
    --restart=on-failure:10
    -v $PWD/config:/config
    -p 7878:7878
    -e URL_BASE=/radarr
    -e ANALYTICS=false
    -e ...
    spritsail/radarr
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

