#!/bin/sh
set -e

export CFG_DIR="${CFG_DIG:-/config}"

if ! su-exec "$UID:$GID" touch "$CFG_DIR/.write-test"; then
    2>&1 echo "Error: No write access to $CFG_DIR"
    exit 28
fi
# Remove temporary file
rm -f touch "$CFG_DIR/.write-test"

su-exec "$UID:$GID" gen-config.sh

exec su-exec "$UID:$GID" "$@"
