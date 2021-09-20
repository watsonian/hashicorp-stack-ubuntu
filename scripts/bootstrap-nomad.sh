#!/bin/bash

ROLE="${ROLE:=client}"

sudo ln -sf /vagrant/config/nomad-${ROLE}.hcl /etc/nomad.d/nomad.hcl

if [ -f /vagrant/config/nomad-${ROLE}-host-volumes.hcl ]; then
    sudo ln -sf /vagrant/config/nomad-${ROLE}-host-volumes.hcl /etc/nomad.d/host-volumes.hcl
fi

sudo systemctl enable nomad.service
sudo systemctl start nomad