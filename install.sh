#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

read -p "Clone to home directory? (y/n)? [y] " use_home
use_home=${use_home:-"y"}
if [[ "$use_home" =~ $noexpr ]]; then
  read -p "Please enter destination directory: " dest_dir
fi
# default to home dir
dest_dir=${dest_dir:-$HOME}

# if dest_dir already contains .git file, assume we've already installed there once
if [[ -d "$dest_dir/mac-setup/.git" ]]; then
  echo "Updating..."
  git stash && git checkout main && git pull --rebase origin && git stash pop
else
  echo "Cloning into ${dest_dir}"
  mkdir -p ${dest_dir}
  git clone https://github.com/ahgraber/mac-setup.git
fi
cd ${dest_dir}/mac-setup/

# install prerequisites
# xcode command line tools
# python pip
# ansible
echo "Installing prerequisites..."
bash ./scripts/prerequisites.sh

# install with ansible
# applications & packages w/ homebrew
# dock customization
# vscode customization
# zsh customization
echo "Executing Ansible playbook..."
ansible-playbook playbook.yaml -i inventory -v # --become --ask-become-pass

# home folder mgmt
bash ./scripts/symlink_onedrive.sh
bash ./scripts/git_dir.sh

sudo bash ./scripts/macos_settings.sh
