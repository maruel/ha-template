#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Configuring Tailscale

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

# Tailscale; https://tailscale.com/download/linux
if [ ! -f /usr/bin/tailscale ]; then
  curl -fsSL https://tailscale.com/install.sh | sh
  # The user will have to sign in.
  sudo tailscale up --ssh
fi
