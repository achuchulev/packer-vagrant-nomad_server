#!/bin/bash

mkdir -p /etc/nomad.d
chmod a+w /etc/nomad.d

mkdir -p /opt/nomad

cat <<EOF > /etc/nomad.d/server.hcl

data_dir  = "/opt/nomad"

region = "global"

datacenter = "dc1"

bind_addr = "0.0.0.0"

advertise {
  rpc = "{{ GetInterfaceIP \"eth0\" }}"
  http = "{{ GetInterfaceIP \"eth0\" }}"
  serf = "{{ GetInterfaceIP \"eth0\" }}"
}

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

# adjust interfce if not named eth0
[ -d /etc/nomad.d/ ] && {
  IFACE=`route -n | awk '$1 ~ "192.168.*.*" {print $8}'`
  sed -i "s/eth0/${IFACE}/g" /etc/nomad.d/*.hcl
}