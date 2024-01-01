#/bin/bash
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

# Tailscale; https://tailscale.com/download/linux
if [ ! -f /usr/bin/tailscale ]; then
  curl -fsSL https://tailscale.com/install.sh | sh
  # The user will have to sign in.
  sudo tailscale up --ssh
fi

# Docker; https://docs.docker.com/engine/install/ubuntu/
if ! $(docker run --rm hello-world &> /dev/null); then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  if [ ! $(getent group docker > /dev/null) ]; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker $USER
  newgrp docker
  docker run --rm hello-world
fi

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

# Always forcibly reinstall the service.
mkdir -p ~/.config/systemd/user
cp rsc/homeassistant-docker.service ~/.config/systemd/user/homeassistant.service
systemctl --user daemon-reload
systemctl --user enable homeassistant
systemctl --user restart homeassistant

echo "Success!"
