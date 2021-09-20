# -*- mode: ruby -*-
# vi: set ft=ruby :

NOMAD_CLIENTS  = 2  # should work with any number of nodes
NOMAD_SERVERS  = 1  # should work with any number of nodes
CONSUL_SERVERS = 1  # currently only tested with 1 node
VAULT_SERVERS  = 1  # currently only tested with 1 node

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant"
  
  1.upto(CONSUL_SERVERS) do |n|
    config.vm.define "consul-server-#{n}" do |server|
      server.vm.box = "watsonian/hashicorp-stack-ubuntu"
      server.vm.hostname = "consul-server-#{n}"
      server.vm.network "private_network", type: "dhcp"

      if n == 1
        server.vm.network "forwarded_port", guest: 8500, host: 8500, auto_correct: true, host_ip: "127.0.0.1"
      end

      server.vm.provision "shell", path: "scripts/bootstrap-ip.sh", privileged: false, env: {"INTERFACE": "eth1"}
      server.vm.provision "shell", path: "scripts/bootstrap-consul.sh", privileged: false, env: {"ROLE": "server"}

      server.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
  end

  1.upto(VAULT_SERVERS) do |n|
    config.vm.define "vault-server-#{n}" do |server|
      server.vm.box = "watsonian/hashicorp-stack-ubuntu"
      server.vm.hostname = "vault-server-#{n}"
      server.vm.network "private_network", type: "dhcp"

      if n == 1
        server.vm.network "forwarded_port", guest: 8200, host: 8200, auto_correct: true, host_ip: "127.0.0.1"
        server.vm.network "forwarded_port", guest: 8201, host: 8201, auto_correct: true, host_ip: "127.0.0.1"
      end

      server.vm.provision "shell", path: "scripts/bootstrap-ip.sh", privileged: false, env: {"INTERFACE": "eth1"}
      server.vm.provision "shell", path: "scripts/bootstrap-consul.sh", privileged: false, env: {"ROLE": "client"}
      server.vm.provision "shell", path: "scripts/bootstrap-vault.sh", privileged: false, env: {"ROLE": "server"}

      server.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
  end

  1.upto(NOMAD_SERVERS) do |n|
    config.vm.define "nomad-server-#{n}" do |server|
      server.vm.box = "watsonian/hashicorp-stack-ubuntu"
      server.vm.hostname = "nomad-server-#{n}"
      server.vm.network "private_network", type: "dhcp"

      if n == 1
        server.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true, host_ip: "127.0.0.1"
      end
  
      server.vm.provision "shell", path: "scripts/bootstrap-ip.sh", privileged: false, env: {"INTERFACE": "eth1"}
      server.vm.provision "shell", path: "scripts/bootstrap-consul.sh", privileged: false, env: {"ROLE": "client"}
      server.vm.provision "shell", path: "scripts/bootstrap-nomad.sh", privileged: false, env: {"ROLE": "server"}
  
      server.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
  end

  1.upto(NOMAD_CLIENTS) do |n|
    config.vm.define "nomad-client-#{n}" do |server|
      server.vm.box = "watsonian/hashicorp-stack-ubuntu"
      server.vm.hostname = "nomad-client-#{n}"
      server.vm.network "private_network", type: "dhcp"

      server.vm.provision "shell", path: "scripts/bootstrap-ip.sh", privileged: false, env: {"INTERFACE": "eth1"}
      server.vm.provision "shell", path: "scripts/bootstrap-consul.sh", privileged: false, env: {"ROLE": "client"}
      server.vm.provision "shell", path: "scripts/bootstrap-nomad.sh", privileged: false, env: {"ROLE": "client"}

      server.vm.provider "virtualbox" do |vb|
        vb.memory = "6144"
      end
    end
  end
end
