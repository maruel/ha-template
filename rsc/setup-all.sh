#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Configuring Home Assistant as a docker instance.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

# Still needed after a fresh install.
sudo apt update
sudo apt upgrade -y

# Prerequisites
sudo apt install -y apg ca-certificates curl git gnupg tmux vim

./rsc/setup-tailscale.sh
./rsc/setup-docker.sh
#./rsc/setup-docker-network.sh

# Only generate a new MQTT password if it didn't exist.
if [ ! -f ./homeassistant/secrets.yaml ]; then
  U=homeassistant
  P="$(apg -m 32 -n 1)"
  echo "Creating mosquitto account $U:$P"
  touch ./mosquitto/config/mosquitto_passwd
  chmod 0700 ./mosquitto/config/mosquitto_passwd
  docker compose run --rm -it mosquitto /usr/bin/mosquitto_passwd -b /mosquitto/config/mosquitto_passwd "$U" "$P"
  echo "mqtt_user: $U" >> ./homeassistant/secrets.yaml
  echo "mqtt_pass: $P" >> ./homeassistant/secrets.yaml
fi

./rsc/setup-systemd.sh homeassistant-docker.service
echo "Success!"
