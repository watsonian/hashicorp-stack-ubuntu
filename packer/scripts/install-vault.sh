#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

version=1.8.2+ent

apt install vault-enterprise=${version}