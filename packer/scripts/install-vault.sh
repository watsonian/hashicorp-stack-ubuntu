#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

version=1.8.4+ent

apt install vault-enterprise=${version}