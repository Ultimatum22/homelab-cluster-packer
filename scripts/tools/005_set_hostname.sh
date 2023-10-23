#!/usr/bin/env bash

set -e

echo ${HOSTNAME}

if [[ ${HOSTNAME} != "" ]]; then
    sed -i "s/raspberrypi/${HOSTNAME}/g" /etc/hosts
    echo "${HOSTNAME}" > /etc/hostname

    cat /etc/hosts
    cat /etc/hostname
fi