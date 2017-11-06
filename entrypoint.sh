#!/bin/sh
set -e

export CFG_DIR="${CFG_DIG:-/config}"

if ! su-exec "$UID:$GID" touch "$CFG_DIR/.write-test"; then
    chown $UID:$GID "$CFG_DIR"
    chmod o+rw "$CFG_DIR"
fi
# Remove temporary file
rm -f touch "$CFG_DIR/.write-test"

su-exec "$UID:$GID" gen-config.sh

exec su-exec "$UID:$GID" "$@"
