#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/701_install_nomad.sh
#!/usr/bin/env bash
arch=${ARCH}

if [ "$arch" == "aarch64" ]; then
    arch=arm64
elif [ "$arch" == "armhf" ]; then
    arch=arm
fi

echo "==> arch: ${arch} / ${ARCH}"

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_${arch}.zip
unzip nomad_${NOMAD_VERSION}_linux_${arch}.zip
sudo chown root:root nomad
sudo mv nomad /usr/local/bin/
rm nomad_${NOMAD_VERSION}_linux_${arch}.zip

# Check if everything is correct
nomad version

# Install autocomplete functionality
nomad -autocomplete-install
complete -C /usr/local/bin/nomad nomad

# Prepare configuration
sudo mkdir --parents /opt/nomad
sudo mkdir --parents /etc/nomad.d
sudo chmod 700 /etc/nomad.d
sudo touch /etc/nomad.d/nomad.hcl

# Start cluster
sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad

EOF

chmod +x /opt/startup/701_install_nomad.sh

# Nomad service startup

cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://developer.hashicorp.com/nomad/docs
Wants=network-online.target
After=network-online.target

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
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

sudo mkdir -p /etc/nomad.d
sudo chmod 700 /etc/nomad.d

cat <<EOF > /etc/nomad.d/nomad.hcl
datacenter = "homelab"
data_dir = "/opt/nomad"

EOF

cat <<EOF > /etc/nomad.d/server.hcl
server {
  enabled = true
  bootstrap_expect = 3
}

acl {
  enabled = true
}
EOF