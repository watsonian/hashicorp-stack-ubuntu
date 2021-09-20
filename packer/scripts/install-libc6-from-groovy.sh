#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "deb http://us.archive.ubuntu.com/ubuntu groovy main" >> /etc/apt/sources.list
apt-get -y update

apt-get -y --no-install-recommends install libc6-dev