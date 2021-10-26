#!/bin/bash

# install prerequisites
# xcode command line tools
# python pip
# ansible
bash ./scripts/prerequisites.sh

# install with ansible
# applications & packages w/ homebrew
# dock customization
# vscode customization
# zsh customization
ansible-playbook playbook.yml -i inventory --ask-sudo-pass -vvvv

# home folder mgmt
bash ./scripts/symlink_onedrive.sh
bash ./scripts/git_dir.sh

sudo bash ./scripts/osx_settings.sh
