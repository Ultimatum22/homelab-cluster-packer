#!/usr/bin/env bash

set -e

apt-get update && apt-get install raspi-config

mkdir -p /opt/startup

cat <<EOF > /opt/startup/141_firmware_optimization.sh
#!/usr/bin/env bash

raspi-config nonint do_boot_splash 0

raspi-config nonint do_configure_keyboard ${KEYBOARD}
raspi-config nonint do_change_timezone ${TIMEZONE}

echo Y | sudo rpi-update

EOF

chmod +x /opt/startup/141_firmware_optimization.sh
