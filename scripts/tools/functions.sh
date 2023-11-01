#!/usr/bin/env bash

convert_arch() {
    case "$1" in
        aarch64)
            echo "arm64"
            ;;
        armhf)
            echo "arm"
            ;;
        *)
            echo "$1"
            ;;
    esac
}