# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

#mlock = true
#disable_mlock = true

storage "raft" {
  path = "/opt/vault/data"
  node_id = "vault1"
}

api_addr     = "http://0.0.0.0:8200"
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

# Enterprise license_path
# This will be required for enterprise as of v1.8
license_path = "/vagrant/vault.lic"
