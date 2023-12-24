#/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

# Prerequisite to git clone
sudo apt install -y git

git clone --recurse https://github.com/maruel/ha-template home
cd home
./rsc/setup.sh
