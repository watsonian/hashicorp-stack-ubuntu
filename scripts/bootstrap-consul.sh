#!/bin/bash

ROLE="${ROLE:=client}"

sudo ln -sf /vagrant/config/consul-${ROLE}.hcl /etc/consul.d/consul.hcl

sudo systemctl enable consul.service
sudo systemctl start consul
