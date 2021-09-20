source "vagrant" "bento" {
  source_path = "bento/ubuntu-21.04"
  box_name = "watsonian/hashicorp-stack-ubuntu"
  provider = "virtualbox"
  output_dir = "build"
  communicator = "ssh"
  add_force = true
}

build {
    sources = ["sources.vagrant.bento"]

    provisioner "shell" {
        execute_command = "{{.Vars}} sudo -E -S bash '{{.Path}}'"

        scripts =  [
            "scripts/base-apt.sh",
            "scripts/install-cloudflare-utilities.sh",
            "scripts/install-cni-plugins.sh",
            "scripts/install-docker.sh",
            "scripts/install-java.sh",
            "scripts/install-qemu.sh",
            "scripts/add-hashicorp-apt-repo.sh",
            "scripts/install-consul.sh",
            "scripts/install-nomad.sh",
            "scripts/install-vault.sh",
            "scripts/install-libc6-from-groovy.sh",
            "scripts/configure-consul-dns-resolution.sh",
            "scripts/cleanup.sh"
        ]
    }
}
