#!/usr/bin/env bash

set -e

mkdir -p /opt/tools/nomad

arch=${ARCH}

if [[ ${ARCH} == "aarch64" ]]; then
	arch=arm64
elif [[ ${ARCH} == "armhf" ]]; then
	arch=arm
fi

echo "==> arch: ${arch} / ${ARCH}"

nomad_data_dir=/opt/nomad
nomad_version=1.6.3
nomad_datacenter=homelab

# Nomad install

cat <<EOF > /opt/startup/700_install_nomad.sh
curl --silent --remote-name https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_${arch}.zip
unzip nomad_${nomad_version}_linux_${arch}.zip

sudo chown root:root nomad
sudo mv nomad /usr/local/bin/
nomad version
nomad -autocomplete-install
complete -C /usr/local/bin/nomad nomad
sudo mkdir --parents ${nomad_data_dir}
sudo useradd --system --home /etc/nomad.d --shell /bin/false nomad

sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad
EOF

# Nomad service startup

chmod +x /opt/startup/700_install_nomad.sh

cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://www.nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

# When using Nomad with Consul it is not necessary to start Consul first. These
# lines start Consul before Nomad as an optimization to avoid Nomad logging
# that Consul is unavailable at startup.
#Wants=consul.service
#After=consul.service

[Service]

# Nomad server should be run as the nomad user. Nomad clients
# should be run as root
User=nomad
Group=nomad

ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=65536
LimitNPROC=infinity
Restart=on-failure
RestartSec=2

## Configure unit start rate limiting. Units which are started more than
## *burst* times within an *interval* time span are not permitted to start any
## more. Use `StartLimitIntervalSec` or `StartLimitInterval` (depending on
## systemd version) to configure the checking interval and `StartLimitBurst`
## to configure how many starts per interval are allowed. The values in the
## commented lines are defaults.

# StartLimitBurst = 5

## StartLimitIntervalSec is used for systemd versions >= 230
# StartLimitIntervalSec = 10s

## StartLimitInterval is used for systemd versions < 230
# StartLimitInterval = 10s

TasksMax=infinity
OOMScoreAdjust=-1000

[Install]
WantedBy=multi-user.target

EOF

# Nomad configuration

sudo mkdir -p /etc/nomad.d
sudo chmod 700 /etc/nomad.d

cat <<EOF > /etc/nomad.d/nomad.hcl
datacenter = "${nomad_datacenter}"
data_dir = "${nomad_data_dir}"

EOF

cat <<EOF > /etc/nomad.d/server.hcl
server {
  enabled = true
  bootstrap_expect = 1
}

bind_addr = "0.0.0.0"
ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

acl {
  enabled = false
}

EOF

cat <<EOF > /etc/nomad.d/client.hcl
client {
  enabled = true
  network_interface = "eth0"
  server_join {
    retry_join = [
      "192.168.2.223"
    ]
    retry_max = 3
    retry_interval = "15s"
  }
}

EOF
