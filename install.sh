#!/bin/bash

read -p "Clone to home directory (y/n)? [y]" USE_HOME
case USE_HOME in
  n | N) read -p "Please enter destination directory: " DEST_DIR
  ;;
esac
# default to home dir
DEST_DIR=${DEST_DIR:-$HOME}

echo "Cloning into ${DEST_DIR}"
mkdir -p ${DEST_DIR}
git clone https://github.com/ahgraber/ansible-mac-setup.git

cd ${DEST_DIR}/ansible-mac-setup/

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
