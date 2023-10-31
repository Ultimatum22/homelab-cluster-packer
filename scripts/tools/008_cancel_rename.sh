#!/usr/bin/env bash

set -e

echo "get_boot_cli: $(raspi-config nonint get_boot_cli)"

INIT="$(ps --no-headers -o comm 1)"

if [ "$(raspi-config nonint get_boot_cli)" -ne 0 ]; then

    # remove the autostart for the wizard
    rm -f /etc/xdg/autostart/piwiz.desktop

    # set up a self-deleting autostart to delete the wizard user
    cat <<- EOF > /etc/xdg/autostart/deluser.desktop
	[Desktop Entry]
	Type=Application
	Name=Delete Wizard User
	NoDisplay=true
	Exec=sudo sh -c 'userdel -r rpi-first-boot-wizard; rm -f /etc/sudoers.d/010_wiz-nopasswd /etc/xdg/autostart/deluser.desktop'
	EOF
fi

rm -f /var/lib/userconf-pi/autologin
rm -f /etc/ssh/sshd_config.d/rename_user.conf

systemctl --quiet disable userconfig
systemctl --quiet enable getty@tty1

if [ "$INIT" = "systemd" ]; then
    if systemctl --quiet is-active ssh; then
        systemctl --quiet reload ssh
    fi
    systemctl --quiet --no-block start getty@tty1
fi