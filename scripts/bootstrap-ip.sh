#!/bin/bash

mkdir -p /vagrant/env
sudo mkdir -p /etc/nomad.d /etc/consul.d /etc/vault.d
sudo chmod a+w /etc/nomad.d /etc/consul.d /etc/vault.d

INTERFACE="${INTERFACE:=eth0}"
ip=$(ifconfig ${INTERFACE} | grep "inet " | awk '{print $2}')

echo "Waiting for $INTERFACE IP address..."
while [ "$ip" = "" ]; do
  sleep 1
  ip=$(ifconfig ${INTERFACE} | grep "inet " | awk '{print $2}')
done

echo "IP address is $ip"

echo "$ip" > /vagrant/env/${HOSTNAME}_ip

# Drop config file with advertise_addr for Consul
(
cat <<-EOF
advertise_addr = "$ip"
EOF
) | sudo tee /etc/consul.d/advertise_addr.hcl

# Drop config file with retry_join for Consul
FIRST_CONSUL_SERVER_HOSTNAME="consul-server-1"
if [ -f /vagrant/env/${FIRST_CONSUL_SERVER_HOSTNAME}_ip ]; then
(
server_ip=$(cat /vagrant/env/${FIRST_CONSUL_SERVER_HOSTNAME}_ip)
cat <<-EOF
retry_join = ["$server_ip"]
EOF
) | sudo tee /etc/consul.d/retry_join.hcl
fi
