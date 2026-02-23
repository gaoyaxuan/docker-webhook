#!/bin/sh

set -e

WH_USER=wh

setids() {
    PUID=${PUID:-1000}
    PGID=${PGID:-1000}
    groupmod -o -g "$PGID" "$WH_USER"
    usermod -o -u "$PUID" "$WH_USER"
}

setids

if [ $# -gt 0 ]; then
    exec gosu "$WH_USER" "/app/webhook" "$@"
else
    exec gosu "$WH_USER" "/app/webhook"
fi
