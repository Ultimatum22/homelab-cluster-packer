#!/usr/bin/env bash

set -e

chown ${CONFIG_SYSTEM_USER}:${CONFIG_SYSTEM_USER} /opt -R

# Clean apt cache
apt-get clean

rm -rf /var/lib/apt/lists/*
