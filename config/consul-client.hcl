data_dir = "/opt/consul/data"
log_level = "trace"

server = false

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

# this is added at bootstrap as a separate file that references
# the exact IP address that the VM obtained when it started
# advertise_addr = "{{ GetInterfaceIP \"eth1\" }}"

ports {
  https = -1
  grpc  = 8502
}

encrypt = "Bz6jxAkOeAW2ADxzHfax5TL4Tvl4Qb0P3oaONibmFgY="

enable_central_service_config = true

connect {
  enabled = true
}

license_path = "/vagrant/consul.lic"