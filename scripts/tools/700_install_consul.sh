#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/700_install_consul.sh
#!/usr/bin/env bash

converted_arch=$(convert_arch "$ARCH")
echo "Converted ARCH: $converted_arch"

echo "==> arch: $arch / ${ARCH}"

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_$arch.zip
unzip consul_${CONSUL_VERSION}_linux_$arch.zip
sudo chown root:root consul
sudo mv consul /usr/local/bin/
rm consul_${CONSUL_VERSION}_linux_$arch.zip

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

# Prepare TLS certificates (create a certificate per server)
consul tls ca create
consul tls cert create -server -dc homelab
consul tls cert create -server -dc homelab
consul tls cert create -server -dc homelab
consul tls cert create -client -dc homelab

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

cat <<EOF > /etc/consul.d/consul.hcl
datacenter = "homelab"
data_dir = "/opt/consul"
encrypt = "${CONSUL_ENCRYPTION_KEY}"
ca_file = "/etc/consul.d/consul-agent-ca.pem"
cert_file = "/etc/consul.d/homelab-server-consul-${CONSUL_CERTIFICATE_ID}.pem"
key_file = "/etc/consul.d/homelab-server-consul-${CONSUL_CERTIFICATE_ID}-key.pem"
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true
retry_join = ["192.168.2.221","192.168.2.222","192.168.2.223"]
bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"192.168.2.0/23\" | attr \"address\" }}"

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
bootstrap_expect = 3

EOF