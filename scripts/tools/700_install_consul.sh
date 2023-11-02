#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

converted_arch=$(convert_arch "$ARCH")
echo "Converted ARCH: $converted_arch"

echo "==> arch: $converted_arch / ${ARCH}"

cat <<EOF > /opt/startup/700_install_consul.sh
#!/usr/bin/env bash

converted_arch=$(convert_arch "$ARCH")
echo "Converted ARCH: $converted_arch"

echo "==> arch: $converted_arch / ${ARCH}"

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_$converted_arch.zip
unzip consul_${CONSUL_VERSION}_linux_$converted_arch.zip
sudo chown root:root consul
sudo mv consul /usr/local/bin/
rm consul_${CONSUL_VERSION}_linux_$converted_arch.zip

# Check if everything is correct
consul version

# Install autocomplete functionality
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

# Create user
sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir --parents /opt/consul
sudo chown --recursive consul:consul /opt/consul

# Prepare configuration
sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

consul validate /etc/consul.d/consul.hcl

# Start cluster
sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl status consul

# Check cluster
consul members

EOF

chmod +x /opt/startup/700_install_consul.sh

# Consul service startup

cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
Type=exec
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

EOF

# Consul configuration

sudo mkdir -p /etc/consul.d
sudo chmod 700 /etc/consul.d

cluster_ips_array=($(space_string_to_array "$CLUSTER_IPS"))
retry_join_array=$(bash_array_to_json cluster_ips_array)

cat <<EOF > /etc/consul.d/consul.hcl
datacenter = "homelab"
data_dir = "/opt/consul"
encrypt = "${CONSUL_ENCRYPTION_KEY}"
retry_join = $retry_join_array
bind_addr = "${IP_ADDRESS}"

ui_config = {
  enabled = true
}

tls = {
  defaults = {
    ca_file = "/etc/consul.d/consul-agent-ca.pem"
    cert_file = "/etc/consul.d/homelab-server-consul-${CONSUL_CERTIFICATE_ID}.pem"
    key_file = "/etc/consul.d/homelab-server-consul-${CONSUL_CERTIFICATE_ID}-key.pem"
    verify_incoming = true
    verify_outgoing = true
  }

  internal_rpc = {
    verify_server_hostname = true.
  }
}

acl = {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true
}

performance {
  raft_multiplier = 1
}

EOF

cat <<EOF > /etc/consul.d/server.hcl
server = true
bootstrap_expect = ${#cluster_ips_array[@]}

EOF