#!/bin/bash

ROLE="${ROLE:=client}"

sudo ln -sf /vagrant/config/vault-${ROLE}.hcl /etc/vault.d/vault.hcl

# drop the Consul service registration file. this is required because
# Vault currently doesn't support go-sockaddr templates.
cat <<-EOF > /etc/vault.d/consul-service-registration.hcl
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

root_token=$(jq -r '.root_token' /vagrant/vault-keys.json)
export VAULT_TOKEN="$root_token"

echo "Your Vault root token is:"
echo
echo "$root_token"
echo

# wait for Vault to be healthy
echo "Waiting for Vault to be healthy..."
resp_code=""
until [ "${resp_code}" = "200" ]; do
  sleep 1
  resp_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8200/v1/sys/health)
done

#
# Create Nomad policy, role, and token for Nomad
#

# Download the policy and token role
curl https://nomadproject.io/data/vault/nomad-server-policy.hcl -O -s -L
curl https://nomadproject.io/data/vault/nomad-cluster-role.json -O -s -L

# Write the policy to Vault
vault policy write nomad-server nomad-server-policy.hcl

# Create the token role with Vault
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json

# Create the Vault token based on the token role
vault token create -policy nomad-server -period 72h -orphan -format=json > /vagrant/nomad-server-vault-token.json

# Enable kv v2 secrets engine
vault secrets enable -version=2 kv
