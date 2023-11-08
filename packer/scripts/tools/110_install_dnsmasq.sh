#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/110_install_dnsmasq.sh
#!/usr/bin/env bash

apt-get install -y dnsmasq=${DNSMASQ_VERSION}

# Start cluster
sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq
sudo systemctl status dnsmasq

EOF

chmod +x /opt/startup/110_install_dnsmasq.sh

# Dnsmasq configuration

sudo mkdir -p /etc/dnsmasq.d
sudo chmod 700 /etc/dnsmasq.d

cat <<EOF > /etc/dnsmasq.d/dnsmasq.conf
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600

rev-server=0.0.0.0/8,127.0.0.1#8600
rev-server=10.0.0.0/8,127.0.0.1#8600
rev-server=127.0.0.1/8,127.0.0.1#8600
rev-server=169.254.0.0/16,127.0.0.1#8600
rev-server=192.168.2.0/24,127.0.0.1#8600
server=67.207.67.2
server=67.207.67.3
server=8.8.8.8
server=8.8.4.4

EOF

cat <<EOF > /etc/dnsmasq.conf
# Accept DNS queries only from hosts whose address is on a local subnet.
local-service

# Don't poll /etc/resolv.conf for changes.
no-poll

# Don't read /etc/resolv.conf. Get upstream servers only from the command
# line or the dnsmasq configuration file (see the "server" directive below).
no-resolv

# Specify IP address(es) of other DNS servers for queries not handled
# directly by consul. There is normally one 'server' entry set for every
# 'nameserver' parameter found in '/etc/resolv.conf'. See dnsmasq(8)'s
# 'server' configuration option for details.
#server=1.2.3.4
#server=208.67.222.222
#server=8.8.8.8

# Set the size of dnsmasq's cache. The default is 150 names. Setting the
# cache size to zero disables caching.
cache-size=65536

EOF
