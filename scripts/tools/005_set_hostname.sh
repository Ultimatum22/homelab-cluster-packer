#!/usr/bin/env bash

set -e

if [[ ${var.hostname} != "" ]]; then
    sed -i "s/raspberrypi/${var.hostname}/g" /etc/hosts
    echo "${var.hostname}" > /etc/hostname

    cat /etc/hosts
    cat /etc/hostname
fi