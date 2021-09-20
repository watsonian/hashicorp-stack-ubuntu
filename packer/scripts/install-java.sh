#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get -y --no-install-recommends install openjdk-8-jre-headless