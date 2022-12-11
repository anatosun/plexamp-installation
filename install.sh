#!/usr/bin/env bash
. ~/.profile
. ~/.bashrc
. ~/.nvm/nvm.sh


NODE_VERSION=16

if ! [ -x "$(command -v jq)" ]; then
    echo "jq is not installed..."
    echo "installing jq"
    sudo apt install jq -y
fi

if ! [ -x "$(command -v curl)" ]; then
    echo "curl not installed"
    echo "installing curl"
    sudo apt install curl -y
fi

if ! [ -x "$(command -v nvm)" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
fi

cd
PLEXAMP_URL=$(curl -s "https://plexamp.plex.tv/headless/version$1.json" | jq -r '.updateUrl')  
nvm install $NODE_VERSION
nvm use $NODE_VERSION
wget -q "$PLEXAMP_URL" -O plexamp.tar.bz2
if [[ -d ./plexamp.last ]]; then
    rm -rf plexamp.last
fi
if [[ -d ./plexamp ]]; then
    mv plexamp plexamp.last
fi
tar xfj plexamp.tar.bz2
rm plexamp.tar.bz2
chown -R "${USER}:${USER}" plexamp

if ! [ -d ~/.local/share/Plexamp ]; then
    echo "authentication needed, follow the instructions below"
    cd plexamp
    node js/index.js
    cd
fi

sudo echo "[Unit]
Description=Plexamp
After=network-online.target
Requires=network-online.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/plexamp
ExecStart=$(which node) /home/pi/plexamp/js/index.js
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /lib/systemd/system/plexamp.service

sudo systemctl daemon-reload
sudo systemctl enable plexamp
sudo systemctl -q restart plexamp
