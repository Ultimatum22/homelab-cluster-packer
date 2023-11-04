#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

echo "${SYSTEM_USER} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/010_pi-nopasswd
cat /etc/sudoers.d/010_pi-nopasswd

cat <<EOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

chown ${SYSTEM_USER}:${SYSTEM_USER} /home/${SYSTEM_USER}/.ssh/ -R

for ((i = 0; i < ${#CLUSTER_IPS[@]}; i++)); do
    echo "${SYSTEM_USER_PASSWORD}" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \${PUBLIC_SSH_KEYS[$i]}
done

cat <<SEOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

chown ${SYSTEM_USER}:${SYSTEM_USER} /home/${SYSTEM_USER}/.ssh/ -R

for ((i = 0; i < ${#CLUSTER_IPS[@]}; i++)); do
  echo "\\\${PUBLIC_SSH_KEYS[$i]}" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \\\${PUBLIC_SSH_KEYS[$i]}
    echo "${SYSTEM_USER_PASSWORD}" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \${PUBLIC_SSH_KEYS[$i]}
done

SEOF

EOF

chmod +x /opt/startup/102_startup_nodes_ssh.sh