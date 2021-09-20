# hashicorp-stack-ubuntu

This is a Vagrant project that spins up a fully functional HashiCorp stack. It
uses a custom box that has all necessary packages pre-installed and by default
spins up an environment with:

- Consul Server x1
- Nomad Server x1
- Vault server x1
- Nomad Client x2
- Consul Clients on all nodes

The Nomad clients have the required packages to run Docker, Java and QEMU jobs.
`systemd-resolved` has been configured to send `*.consul` DNS queries to Consul,
so Consul DNS discovery is in a working state as well.

## Getting Started

This should work out-of-the-box with a single exception. This is pre-configured
with Enterprise versions of Consul, Nomad, and Vault. As such, you need to add
licenses for each of these to work properly. They're expected to be in the root
directory (where this README is located) with the following names:

* `consul.lic`
* `nomad.lic`
* `vault.lic`

## Spinning up the Environment

Once the licenses are in place, you can spin up the environment by running:

```
vagrant up
```

The initial boot time may take a bit if you haven't previously downloaded the
`watsonian/hashicorp-stack-ubuntu` box because it's 2.5GB. Once you have that
box on your local system, booting up the stack should take around 4 minutes.

## Access the Web UI

The web UI should be accessible at the following locations:

* Consul: http://localhost:8500
* Nomad: http://localhost:4646
* Vault: http://localhost:8200

## Vault Token & Unseal Key

The Vault token is printed during the `vagrant up` process, but can also be
found in the `vault-keys.json` file in the root directory of this project after
you've performed a successful deployment. Vault is unsealed during the
provisioning process, but it isn't automatically unsealed after a reboot. As
such, if you end up rebooting the Vault server for any reason, you'll need to
manually unseal it again by running:

```
vagrant ssh vault-server-1
```

and then running:

```
export VAULT_ADDR="http://127.0.0.1:8200"
vault operator unseal $(jq -r '.unseal_keys_hex[0]' /vagrant/vault-keys.json)
```

## Nomad Host Volumes

If you want any Nomad host volumes setup on the Nomad clients, you can create a
file at `config/nomad-client-host-volumes.hcl` that defines them and it will
get linked into the correct location to be loaded during the vagrant provisioning.
The contents of a config file like that might look something like this:

```
client {
  host_volume "some-host-volume-name" {
    path      = "/vagrant/host_volumes/some-host-volume-name"
    read_only = false
  }
}
```
