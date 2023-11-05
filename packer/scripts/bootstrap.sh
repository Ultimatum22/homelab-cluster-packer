#!/usr/bin/env bash

set -e

for script in $(ls -1 /tmp/tools/ | grep -E '^[0-9]{3}.*'); do
    echo "--------------------------------------------"
    echo ">> exec ${script}"
    echo "--------------------------------------------"
    source /tmp/tools/_functions.sh
    source /tmp/tools/${script}
done

exit 0