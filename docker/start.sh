#!/bin/sh

export USER=wh
setids() {
    PUID=${PUID:-1000}
    PGID=${PGID:-1000}
    groupmod -o -g "$PGID" $USER
    usermod -o -u "$PUID" $USER
}

setids

# Exec CMD or S6 by default if nothing present
if [ $# -gt 0 ];then
    gosu "$USER"  "/app/webhook" "$@"
else
    gosu "$USER" "/app/webhook"
fi
