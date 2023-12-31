#!/usr/bin/env bash

set -e

FMT_ERROR=0

for file in "$@"
do
    packer fmt -diff --recursive "$file" || FMT_ERROR=$?
done

exit $FMT_ERROR
