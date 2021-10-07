#!/bin/bash

ROLE="${ROLE:=client}"

sudo ln -sf /vagrant/config/nomad-${ROLE}.hcl /etc/nomad.d/nomad.hcl

if [ -f /vagrant/config/nomad-${ROLE}-host-volumes.hcl ]; then
    sudo ln -sf /vagrant/config/nomad-${ROLE}-host-volumes.hcl /etc/nomad.d/host-volumes.hcl
fi

token=$(jq -r '.auth.client_token' /vagrant/nomad-server-vault-token.json)

# drop the Vault configuration file
if [ "$ROLE" = "client" ]; then
    cat <<-EOF > /etc/nomad.d/vault.hcl
vault {
  enabled          = true
  address          = "http://vault.service.consul:8200"
}
EOF
else
    cat <<-EOF > /etc/nomad.d/vault.hcl
vault {
  enabled          = true
  address          = "http://vault.service.consul:8200"
  token            = "${token}"
  create_from_role = "nomad-cluster"
}
EOF
fi

sudo systemctl enable nomad.service
sudo systemctl start nomad