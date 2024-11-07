#!/bin/bash
# read variables from .env file
while IFS== read -r key value; do
  printf -v "$key" %s "$value" && export "$key"
done <.env
# install ansible
echo "Installing Python and Ansible..."
sudo apt update
sudo apt install python3, unzip
python3 -m pip install ansible
# download and run ansible scripts
if [[ $APP = "mattermost" ]]; then
  echo "Installing Mattermost..."
else
  echo "Unknown app. Currently only mattermost and rocketchat are supported."
  exit 1
fi
curl -o ./ansible.zip "https://download-directory.github.io?url=https://github.com/FeDaniil/discord-alternatives/tree/master/$APP/ansible"
unzip -q ansible.zip
cd ansible
ansible-playbook -i inventory install.yml
echo "Done!"
