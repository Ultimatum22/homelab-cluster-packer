#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/701_install_nomad.sh
#!/usr/bin/env bash

converted_arch=$(convert_arch "$ARCH")
echo "Converted ARCH: $converted_arch"

echo "==> arch: $converted_arch / ${ARCH}"

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_$converted_arch.zip
unzip nomad_${NOMAD_VERSION}_linux_$converted_arch.zip
sudo chown root:root nomad
sudo mv nomad /usr/local/bin/
rm nomad_${NOMAD_VERSION}_linux_$converted_arch.zip

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

nomad acl bootstrap > /etc/nomad.d/acl.keys

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

cluster_ips_array=($(space_string_to_array "$CLUSTER_IPS"))

cat <<EOF > /etc/nomad.d/nomad.hcl
datacenter = "homelab"
data_dir = "/opt/nomad"

EOF

cat <<EOF > /etc/nomad.d/server.hcl
server {
  enabled = true
  bootstrap_expect = ${#cluster_ips_array[@]}
}

acl {
  enabled = true
}

EOF

cat <<EOF > /etc/nomad.d/client.hcl
client {
  enabled = true
  network_interface = "eth0"
  server_join {
    retry_join = [
      "127.0.0.1"
    ]
    retry_max = 3
    retry_interval = "15s"
  }
}

EOF
