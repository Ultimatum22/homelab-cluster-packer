#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/700_install_consul.sh
#!/usr/bin/env bash

arch=${ARCH}

if [[ ${ARCH} == "aarch64" ]]; then
	arch=arm64
elif [[ ${ARCH} == "armhf" ]]; then
	arch=arm
fi

echo "==> arch: ${arch} / ${ARCH}"

CONSUL_VERSION=1.16.3

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${arch}.zip
unzip consul_${CONSUL_VERSION}_linux_${arch}.zip
sudo chown root:root consul
sudo mv consul /usr/local/bin/
rm consul_${CONSUL_VERSION}_linux_${arch}.zip

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
EOF

chmod +x /opt/startup/700_install_consul.sh