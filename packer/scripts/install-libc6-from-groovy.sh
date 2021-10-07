#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if ! grep "deb http://us.archive.ubuntu.com/ubuntu groovy main" /etc/apt/sources.list
then
    echo "deb http://us.archive.ubuntu.com/ubuntu groovy main" >> /etc/apt/sources.list
fi
apt-get -y update

apt-get -y --no-install-recommends install libc6-dev