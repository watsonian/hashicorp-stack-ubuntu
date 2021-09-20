# hashicorp-stack-ubuntu box

These are the packer build files for the `watsonian/hashicorp-stack-ubuntu` box.
The box itself is based on the `bento/ubuntu-21.04` box and pre-loads the following:

- Consul Enterprise, Nomad Enterprise, and Vault Enterprise pre-installed.
- `jq`, `cfssl`, `cfssljson`, and `cfssl-certinfo` pre-installed.
- Consul DNS setup for `*.consul` domains.
- Docker, Java, QEMU, and CNI plugins pre-installed for Nomad.

## Building the Box

To build a new version of the box file, simply [install Packer](https://www.packer.io/downloads)
and then run the following from this directory:

```
packer build hashicorp-stack-ubuntu.pkr.hcl
```

This will cause the required base box to be fetched, will spin it up, and then
apply all of the provisioning scripts before finally creating a new box. The
new box will be stored in `build/package.box`.

## Adding the built Box to Vagrant

Once the box has been built with any modifications you want, you can add it to
Vagrant by running:

```
vagrant box add build/package.box --name "hashicorp-stack-ubuntu"
```

You can then reference it in your Vagrant files as simply `hashicorp-stack-ubuntu`.

# Acknowledgements

Kudos go to Kris Hicks. He has a similar project available here:

https://github.com/krishicks/vagrant-nomad

and I pulled some of the installation scripts from him after adding some additional
modifications. Hicks' image doesn't use the apt repository installation and
instead fetches the binaries with curl. As such, he also has some stuff in place
that allows you to override the binaries by dropping them in a special directory.
This project may end up having similar functionality, but for now it doesn't.