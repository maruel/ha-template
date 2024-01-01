#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Configuring Home Assistant in a virtual env.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

# Still needed after a fresh install.
sudo apt update
sudo apt upgrade -y

# Prerequisites
sudo apt install -y apg build-essential git mosquitto mosquitto-clients tmux vim

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.12 python3.12-dev python3.12-venv

# Tailscale; https://tailscale.com/download/linux
if [ ! -f /usr/bin/tailscale ]; then
  curl -fsSL https://tailscale.com/install.sh | sh
  # The user will have to sign in.
  sudo tailscale up --ssh
fi

# Only generate a new MQTT password if it didn't exist.
if [ ! -f ./homeassistant/secrets.yaml ]; then
  U=homeassistant
  P="$(apg -m 32 -n 1)"
  echo "Creating mosquitto account $U:$P"
  sudo /usr/bin/mosquitto_passwd -b /etc/mosquitto/.passwd "$U" "$P"
  cat <<EOF | sudo tee /etc/mosquitto/conf.d/ha-template.conf
# See https://github.com/maruel/ha-template
persistence true
#persistence_location /mosquitto/data/
password_file /etc/mosquitto/.passwd

listener 1883
protocol mqtt

listener 1884
protocol websockets

allow_duplicate_messages false
# Size of firmware.bin for a d1_mini for OTA updates rounded up to 1Mib.
message_size_limit 1048576

allow_anonymous false
EOF
  sudo systemctl restart mosquitto
  sudo systemctl status mosquitto
  echo "mqtt_user: $U" >> ./homeassistant/secrets.yaml
  echo "mqtt_pass: $P" >> ./homeassistant/secrets.yaml
fi

python3.12 -m venv .venv
source .venv/bin/activate
pip3 install -U wheel
pip3 install -r requirements.txt
#pip3 install -U homeassistant


# Always forcibly reinstall the service.
mkdir -p ~/.config/systemd/user
cp rsc/homeassistant-venv.service ~/.config/systemd/user/homeassistant.service
systemctl --user daemon-reload
systemctl --user enable homeassistant
systemctl --user restart homeassistant
systemctl --user status homeassistant

echo "Success!"
