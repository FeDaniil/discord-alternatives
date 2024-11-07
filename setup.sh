#!/bin/bash
# read variables from .env file
while IFS== read -r key value; do
  printf -v "$key" %s "$value" && export "$key"
done <.env
# install ansible
echo "Installing Ansible..."
sudo apt update
sudo apt install -y ansible unzip
# download and run ansible scripts
if [[ $APP = "mattermost" ]]; then
  echo "Installing Mattermost..."
else
  echo "Unknown app. Currently only mattermost and rocketchat are supported."
  exit 1
fi
curl -L -o master.zip "https://github.com/FeDaniil/discord-alternatives/archive/master.zip"
unzip -q master.zip
cd discord-alternatives-master/$APP/ansible
sudo ansible-playbook -i inventory install.yml

echo "Done!"
