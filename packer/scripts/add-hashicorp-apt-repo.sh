#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

arch=$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=${arch}] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update