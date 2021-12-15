data_dir = "/opt/nomad/data"

bind_addr = "0.0.0.0"

log_level = "trace"

enable_debug = true

advertise {
    http = "{{ GetInterfaceIP \"eth1\" }}"
    rpc  = "{{ GetInterfaceIP \"eth1\" }}"
    serf = "{{ GetInterfaceIP \"eth1\" }}"
}

server {
    enabled = true
    bootstrap_expect = 1

    license_path = "/vagrant/nomad.lic"
}

client {
    enabled = false
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

plugin "qemu" {
  config {
    image_paths = ["/mnt/image/paths"]
  }
}
