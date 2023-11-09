#!/usr/bin/env bash

set -e

apt-get update && apt-get install -y git sshpass \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
