#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

converted_arch=$(convert_arch "$ARCH")
echo "Converted ARCH: $converted_arch"

echo "==> arch: $converted_arch / ${ARCH}"

cat <<EOF > /opt/startup/702_install_vault.sh
#!/usr/bin/env bash

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_$converted_arch.zip
unzip vault_${VAULT_VERSION}_linux_$converted_arch.zip
sudo chown root:root vault
sudo mv vault /usr/local/bin/
rm vault_${VAULT_VERSION}_linux_$converted_arch.zip

# Check if everything is correct
vault version

# Install autocomplete functionality
vault -autocomplete-install
complete -C /usr/local/bin/vault vault

# Create user
sudo useradd --system --home /etc/vault.d --shell /bin/false vault
sudo mkdir -p /opt/vault
sudo chown -R vault:vault /opt/vault

# Prepare configuration
sudo mkdir -p /etc/vault.d

# Start cluster
sudo systemctl enable vault
sudo systemctl start vault
sudo systemctl status vault

EOF

chmod +x /opt/startup/702_install_vault.sh

# Nomad service startup

cat <<EOF > /etc/systemd/system/vault.service
[Unit]
Description=Vault
Documentation=https://developer.hashicorp.com/vault/docs
Wants=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.json

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/vault server -config /etc/vault.d/vault.json
KillMode=process
KillSignal=SIGINT
LimitNOFILE=infinity
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity

[Install]
WantedBy=multi-user.target

EOF

# Nomad configuration

sudo mkdir -p /etc/vault.d
sudo chmod 700 /etc/vault.d

cat <<EOF > /etc/vault.d/vault.json
{
  "api_addr": "http://${IP_ADDRESS}:8200",
  "cluster_addr": "http://${IP_ADDRESS}:8201",
  "pid_file": "",
  "ui": true,
  "listener": {
    "tcp": {
      "address": "0.0.0.0:8200",
      "tls_disable": true
    }
  },
  "storage": {
    "consul": {
      "address": "127.0.0.1:8500",
      "path": "vault/"
    }
  }
}

EOF
