#!/usr/bin/env bash
set -euo pipefail

# setup systemd-resolved to send *.consul DNS requests to Consul
mkdir -p /etc/systemd/resolved.conf.d/

cat <<-EOF > /etc/systemd/resolved.conf.d/consul.conf
[Resolve]
DNS=127.0.0.1:8600
Domains=~consul
EOF

cat <<-EOF > /etc/systemd/resolved.conf.d/nomad.conf
[Resolve]
# this is required to get systemd-resolved listening on the nomad
# bridge interface.
DNSStubListenerExtra=172.26.64.1
EOF

cat <<-EOF > /etc/docker/daemon.json
{ "dns" : [ "172.26.64.1" , "8.8.8.8" ] }
EOF