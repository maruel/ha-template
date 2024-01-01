#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

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
