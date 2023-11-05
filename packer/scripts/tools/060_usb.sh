#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/060_usb.sh
#!/usr/bin/env bash

mount_point="/mnt/storage"
usb_label="homelab-storage"
device_info=$(lsblk -o NAME,LABEL -n -l | grep "$usb_label")


mkdir -p /mnt/storage

if [ -n "$device_info" ]; then
  device_name=$(echo "$device_info" | awk '{print $1}')
  uuid=$(lsblk -o UUID -n -l /dev/"$device_name")

  if ! grep -q "UUID=$uuid" /etc/fstab; then
    echo "UUID=$uuid $mount_point auto defaults 0 0" | sudo tee -a /etc/fstab
    echo "Entry added to /etc/fstab."
  else
    echo "Entry for UUID $uuid already exists in /etc/fstab. Skipping."
  fi
else
  echo "USB drive with label '$usb_label' not found or UUID not available."
fi

systemctl daemon-reload
mount -a

chown -R ${SYSTEM_USER}:${SYSTEM_USER} $mount_point

EOF

chmod +x /opt/startup/060_usb.sh