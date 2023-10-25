#!/usr/bin/env bash

set -e

echo "SYSTEM_USER ${SYSTEM_USER}"
if [[ ${SYSTEM_USER} != "pi" ]]; then
  # useradd -m -s /usr/bin/bash -U -G users ${SYSTEM_USER}
  useradd -m -s /usr/bin/bash ${SYSTEM_USER}
  # echo "${SYSTEM_USER_PASSWORD}" | passwd "${SYSTEM_USER}" --stdin
fi