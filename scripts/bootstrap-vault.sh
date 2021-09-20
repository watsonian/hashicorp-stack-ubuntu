#!/bin/bash

ROLE="${ROLE:=client}"

sudo ln -sf /vagrant/config/vault-${ROLE}.hcl /etc/vault.d/vault.hcl

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
