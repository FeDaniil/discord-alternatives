#!/bin/bash
# read variables from .env file
while IFS== read -r key value; do
  printf -v "$key" %s "$value" && export "$key"
done <.env
# install ansible
echo "Installing Python and Ansible..."
sudo apt install python3
python3 -m pip install ansible
# download and run ansible scripts
if [[ $APP = "mattermost" ]]; then
  echo "Installing Mattermost..."
fi
