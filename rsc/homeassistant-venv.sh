#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

# This file is located under rsc/.
cd "$(dirname $0)"
cd ..

source .venv/bin/activate
hass -c "$(pwd)/homeassistant"
