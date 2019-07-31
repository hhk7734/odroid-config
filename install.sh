#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    printf "Must run as root privileges. Try 'sudo sh install.sh'\n"
    exit 1
fi

SCRIPT_PATH=$(dirname "$(realpath "$0")")

if [ ! -e /usr/lib/odroid-config ]; then
    mkdir -p /usr/lib/odroid-config
fi
cp "$SCRIPT_PATH"/odroid-config-*.sh /usr/lib/odroid-config/

cp "$SCRIPT_PATH"/odroid-config /usr/bin/odroid-config
chmod +x /usr/bin/odroid-config