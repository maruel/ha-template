# Home Assistant template

## Setup

1. Install [Ubuntu Desktop](https://ubuntu.com/download/desktop). Ubuntu
   Server would work too but a desktop version enables the user to try to debug
   things a bit. Options:
   - Call the machine `home`
   - Do not enable auto-login.
   - Do not use full disk encryption.
2. Run the setup script (curl is not installed by default on Ubuntu Minimal):
   ```
   wget -q -O - https://raw.githubusercontent.com/maruel/ha-template/main/rsc/bootstrap.sh | bash
   ```
3. Navigate to http://home:81233 or http://home.tailABC.ts.net:8123/ and set it
   up.
