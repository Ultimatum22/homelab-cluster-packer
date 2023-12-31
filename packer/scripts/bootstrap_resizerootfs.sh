#!/bin/bash
# source: https://github.com/mkaczanowski/packer-builder-arm/blob/master/scripts/bootstrap_resizerootfs.sh

set -o errtrace -o nounset -o pipefail -o errexit

# set up one shot resize root fs for first boot
mv /tmp/resizerootfs/resizerootfs.service /etc/systemd/system
mv /tmp/resizerootfs/resizerootfs /usr/sbin/
systemctl enable resizerootfs.service
