#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Configuring Home Assistant as a docker instance.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

sudo adduser $USER dialout
sudo adduser $USER video

# Still needed after a fresh install.
sudo apt update
sudo apt upgrade -y

# Prerequisites
sudo apt install -y \
  apg ca-certificates curl git gnupg tmux vim
  bluez \
  dbus-broker
sudo systemctl enable dbus-broker.service

./rsc/setup-tailscale.sh
./rsc/setup-docker.sh
./rsc/setup-mosquitto.sh
./rsc/setup-systemd.sh homeassistant-docker.service
echo "Success!"
