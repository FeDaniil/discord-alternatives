#!/bin/bash
# read variables from .env file
while IFS== read -r key value; do
  printf -v "$key" %s "$value" && export "$key"
done <.env
# install ansible and svn (needed to download single folder of github repo)
echo "Installing Ansible..."
sudo apt update
sudo apt install -y ansible svn
# download and run ansible scripts
if [[ $APP = "mattermost" ]]; then
  echo "Installing Mattermost..."
else
  echo "Unknown app. Currently only mattermost and rocketchat are supported."
  exit 1
fi
svn export https://github.com/FeDaniil/discord-alternatives/trunk/$APP/ansible
cd ansible
ansible-playbook -i inventory install.yml

echo "Done!"
