#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Configuring docker networking.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

# https://community.home-assistant.io/t/using-homekit-component-inside-docker/45409/41
# https://github.com/TonyBrobston/tbro-server/blob/master/home-automation/docker-compose.yml

# Docker networking.
#docker network create \
#  --config-only \
#  --subnet="192.168.0.0/16" \
#  --ip-range="192.168.0.128/27" \
#  -o parent="$INTERFACE" \
#  $INTERMEDIARY
#
#docker network create \
#  -d macvlan \
#  --scope swarm \
#  --config-from $INTERMEDIARY \
#  $NETNAME
#
## https://community.home-assistant.io/t/how-to-run-homeassistant-on-docker-on-its-own-network-instead-of-the-host-network/189315/20
#docker network create -d macvlan -o parent=eno1 \
#  --subnet 192.168.178.0/24 \
#  --gateway 192.168.178.1 \
#  --ip-range 192.168.178.192/27 \
#  --aux-address 'host=192.168.178.223' \
#  mynet
#ip link add mynet-shim link eno1 type macvlan  mode bridge
#ip addr add 192.168.178.223/32 dev mynet-shim
#ip link set mynet-shim up
#ip route add 192.168.178.192/27 dev mynet-shim
