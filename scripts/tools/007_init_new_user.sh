#!/usr/bin/env bash

set -e

if [[ ${var.system_user} != "pi" ]]; then
  useradd -m -s /usr/bin/bash ${var.system_user}
  groupadd ${var.system_user}
  echo "${var.system_user_password} | passwd "${var.system_user}" --stdin
fi