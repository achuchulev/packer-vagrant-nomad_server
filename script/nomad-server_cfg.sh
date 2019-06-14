#!/bin/bash

mkdir -p /etc/nomad.d
chmod a+w /etc/nomad.d

mkdir -p /opt/nomad

cat <<EOF > /etc/nomad.d/server.hcl

data_dir  = "/opt/nomad"

bind_addr = "0.0.0.0"

server {
  enabled = true
  bootstrap_expect = 3
  authoritative_region = "global"
  server_join {
    retry_join = ["192.168.10.11", "192.168.10.12", "192.168.10.13"]
    retry_max = 5
    retry_interval = "15s"
  }
}
EOF
