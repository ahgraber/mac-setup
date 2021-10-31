#!/bin/bash

read -p "Clone to home directory (y/n)? [y]" use_home
case use_home in
  n | N) read -p "Please enter destination directory: " dest_dir
  ;;
esac
# default to home dir
dest_dir=${dest_dir:-$HOME}

echo "Cloning into ${dest_dir}"
mkdir -p ${dest_dir}
git clone https://github.com/ahgraber/mac-setup.git

cd ${dest_dir}/mac-setup/

# install prerequisites
# xcode command line tools
# python pip
# ansible
echo "Installing prerequisites..."
. ./scripts/prerequisites.sh

# install with ansible
# applications & packages w/ homebrew
# dock customization
# vscode customization
# zsh customization
echo "Executing Ansible playbook..."
ansible-playbook playbook.yml -i inventory --ask-sudo-pass -vvvv

# home folder mgmt
. ./scripts/symlink_onedrive.sh
. ./scripts/git_dir.sh

sudo . ./scripts/macos_settings.sh
