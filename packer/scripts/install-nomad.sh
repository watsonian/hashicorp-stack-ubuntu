#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

version=1.1.6+ent

apt install nomad-enterprise=${version}

nomad -autocomplete-install