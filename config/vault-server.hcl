# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

#mlock = true
#disable_mlock = true

storage "raft" {
  path = "/opt/vault/data"
  node_id = "vault1"
}

api_addr     = "http://172.28.128.253:8200"
cluster_addr = "http://127.0.0.1:8201"

# HTTP listener
listener "tcp" {
 address = "0.0.0.0:8200"
 tls_disable = 1
}

# HTTPS listener
# listener "tcp" {
#   address       = "0.0.0.0:8200"
#   tls_cert_file = "/opt/vault/tls/tls.crt"
#   tls_key_file  = "/opt/vault/tls/tls.key"
# }

# We aren't using Consul as the storage backend, but we still want
# to register the Vault service with Consul
service_registration "consul" {
  address = "127.0.0.1:8500"
  service_address = "172.28.128.253"
}

# Enterprise license_path
# This will be required for enterprise as of v1.8
license_path = "/vagrant/vault.lic"
