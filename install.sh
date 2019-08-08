#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    printf "Must run as root privileges. Try 'sudo sh install.sh'\n"
    exit 1
fi

apt update

if [ -z "$(command -v fdtput 2>/dev/null)" ]; then
    apt install -y device-tree-compiler
fi

SCRIPT_PATH=$(dirname "$(realpath "$0")")

if [ ! -e /usr/lib/odroid-config ]; then
    mkdir -p /usr/lib/odroid-config
fi
cp "$SCRIPT_PATH"/odroid-config-*.sh /usr/lib/odroid-config/
chmod +x /usr/lib/odroid-config/*.sh

cp "$SCRIPT_PATH"/odroid-config /usr/bin/odroid-config
chmod +x /usr/bin/odroid-config

cp "$SCRIPT_PATH"/odroid-config-settings.service /etc/systemd/system/odroid-config-settings.service
chmod +x /etc/systemd/system/odroid-config-settings.service
systemctl enable odroid-config-settings &&
systemctl restart odroid-config-settings