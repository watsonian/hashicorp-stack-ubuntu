#!/usr/bin/env bash
set -euo pipefail

# taken from https://docs.docker.com/engine/install/ubuntu/

export DEBIAN_FRONTEND=noninteractive

apt-get update

echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

if ! apt-key fingerprint 0EBFCD88 | grep "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88" >/dev/null; then
  echo "failed to add Docker GPG key"
  exit 1
fi

arch=$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)

add-apt-repository \
  "deb [arch=${arch}] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

apt-get update
apt-get install -f -y docker-ce docker-ce-cli containerd.io

# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
service docker restart

# Make sure we can actually use docker as the vagrant user
usermod -aG docker vagrant