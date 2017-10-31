#!/bin/sh
set -e

CFG_FILE="$CFG_DIR/config.xml"

function getOpt { xmlstarlet sel -t -c /Config/"$1" "$CFG_FILE"; }
function setOpt {
    # If element exists
    if xml sel -Q -t -c "/Config/$1" "$CFG_FILE"; then
        # Update the existing element
        xmlstarlet ed -O -L -u "/Config/$1" -v "$2" "$CFG_FILE"
    else
        # Insert a new sub-element
        xmlstarlet ed -O -L -s /Config -t elem -n "$1" -v "$2" "$CFG_FILE"
    fi
}
function bool {
    local var="$(echo $1 | tr 'A-Z' 'a-z')"
    case "$var" in
        y|ye|yes|t|tr|tru|true|1)
            echo True;;
        n|no|f|fa|fal|fals|false|0)
            echo False;;
    esac
}

# Create empty config.xml file
if [ ! -f "$CFG_FILE" ]; then
    (echo '<Config>'; echo '</Config>') > "$CFG_FILE"
fi

# Add options that are specified in the environment
if [ -n "$LOG_LEVEL" ]; then
    setOpt LogLevel $LOG_LEVEL
fi
if [ -n "$URL_BASE" ]; then
    setOpt UrlBase $URL_BASE
fi
if [ -n "$BRANCH" ]; then
    setOpt Branch $BRANCH
fi
if [ -n "$ANALYTICS" ]; then
    setOpt AnalyticsEnabled $(bool $ANALYTICS)
fi

# Disable automatic updates
setOpt UpdateAutomatically False
# Don't launch a browser
setOpt LaunchBrowser False

# Format the document pretty :)
xmlstarlet fo "$CFG_FILE" &>/dev/null
