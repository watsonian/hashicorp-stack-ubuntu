#!/usr/bin/env bash
set -euo pipefail

if [ -d /opt/cni/bin ]; then
  return
fi

arch=$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)
version="1.0.1"
url="https://github.com/containernetworking/plugins/releases/download/v${version}/cni-plugins-linux-${arch}-v${version}.tgz"

mkdir -p /opt/cni/bin

curl -sSL "$url" | tar -C /opt/cni/bin -xzf -

# Ensure container traffic through bridge networks is allowed
cat <<-EOF > /etc/sysctl.d/99-cni-bridge-settings.conf
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF