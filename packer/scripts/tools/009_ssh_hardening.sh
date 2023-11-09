#!/usr/bin/env bash

set -e

echo 'Setting up sshd...'

touch /boot/ssh

sed -i -r -e 's/#?.*?PermitRootLogin.*?$/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sed -i -r -e 's/#?.*?PasswordAuthentication.*?$/PasswordAuthentication no/g' /etc/ssh/sshd_config

mkdir -p /home/${SYSTEM_USER}/.ssh/
chmod 700 /home/${SYSTEM_USER}/.ssh
touch /home/${SYSTEM_USER}/.ssh/authorized_keys

PUBLIC_SSH_KEYS=("ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAFM0iEBuZCiOXBON8eJButuRzyxdTaKHRwngXRO0Y5QIfINiM4qlK0NOo5YSlNuoR2i4A7R9aq/j++RHb84vYIS9QDztV2zJl4Z4tjSF11EOvLPt7Vq7kMfc3x3Wh7GrszNsSNc+u4MD1ZZNJ0h/YNk/Hi2SLWhvsJdFHYJGhli03A/SA== dave@ares" "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGHSUPSrpC0od7iCatOMeXv1HjSWhZVGaVPf0J+ycHsUfKlHUBsV2P9ld4jHRddZx0ik4ROs0i5oEtoKEmUcJlMYwHJD7M6E3jlv/3AK2NcROeNponVLap18eqCtX4QhdrcigV/+JJz+TRMckPXsxDlrw2gJFyGC8aOXRYif0f3jdEAGA== dave@artemis")

for ((i = 0; i < ${#PUBLIC_SSH_KEYS[@]}; i++)); do
    echo ${PUBLIC_SSH_KEYS[$i]}
    echo ${PUBLIC_SSH_KEYS[$i]} >> /home/${SYSTEM_USER}/.ssh/authorized_keys
done

chmod 644 /home/${SYSTEM_USER}/.ssh/authorized_keys

systemctl restart sshd.service
