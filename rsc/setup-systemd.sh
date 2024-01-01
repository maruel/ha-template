#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Configuring Home Assistant as a systemd service unit.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

SERVICE=homeassistant-docker.service
if [ $# -ne 0 ]; then
  SERVICE=$1
fi
# Always forcibly reinstall the service.
mkdir -p ~/.config/systemd/user
cp "rsc/${SERVICE}" "~/.config/systemd/user/homeassistant.service"
systemctl --user daemon-reload
systemctl --user enable homeassistant
systemctl --user restart homeassistant
systemctl --user status homeassistant
