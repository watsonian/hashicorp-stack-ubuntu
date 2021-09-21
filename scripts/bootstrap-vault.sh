#!/bin/bash

ROLE="${ROLE:=client}"

sudo ln -sf /vagrant/config/vault-${ROLE}.hcl /etc/vault.d/vault.hcl

# drop the Consul service registration file. this is required because
# Vault currently doesn't support go-sockaddr templates.
cat <<-EOF >> /etc/vault.d/consul-service-registration.hcl
# We aren't using Consul as the storage backend, but we still want
# to register the Vault service with Consul
service_registration "consul" {
  address = "127.0.0.1:8500"
  service_address = "$(cat /vagrant/env/${HOSTNAME}_ip)"
}
EOF

# Right now the defaut Vault unit file sources a specific config file
# rather than the config directory. This modifies that so it's sourcing
# the directory instead.
sudo sed -i 's/-config=\/etc\/vault.d\/vault.hcl/-config=\/etc\/vault.d/' /lib/systemd/system/vault.service

sudo systemctl enable vault.service
sudo systemctl start vault

sleep 2

#
# Unseal Vault
#
echo "Unsealing Vault..."
export VAULT_ADDR="http://127.0.0.1:8200"
vault operator init -key-shares=1 -key-threshold=1 -format=json > /vagrant/vault-keys.json
vault operator unseal $(jq -r '.unseal_keys_hex[0]' /vagrant/vault-keys.json)
echo
echo "Your Vault root token is:"
echo
jq -r '.root_token' /vagrant/vault-keys.json
echo
