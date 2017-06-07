#!/bin/sh
set -e

exec su-exec "$UID:$GID" "$@"
