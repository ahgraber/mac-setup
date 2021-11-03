#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

# if dest_dir already contains .git file, assume we've already installed there once
if [[ -d "$HOME/mac-setup/.git" ]]; then
  read -p "Update from source? (y/n)? [y] " git_select
  git_select=${git_select:-"y"}
  if [[ "$git_select" =~ $yesexpr ]]; then
    echo "Updating...  Will attempt to reapply any local changes after..."
    cd $HOME/mac-setup/
    git stash && git checkout main && git pull --rebase origin && git stash pop
  fi
else
  echo "Cloning into $HOME/mac-setup"
  cd $HOME
  git clone https://github.com/ahgraber/mac-setup.git
fi

cd $HOME/mac-setup/

read -p "Run install with default settings? (y/n)? [y] " install_select
install_select=${install_select:-"y"}
if [[ "$install_select" =~ $yesexpr ]]; then
  echo "Installing with default settings..."
else
  echo "Exiting installation."
  exit 0
fi

# install prerequisites (rosetta2, python pip, ansible)
echo "Installing prerequisites..."
bash ./scripts/prerequisites.sh

# install with ansible
echo "Executing Ansible playbook..."
ansible-playbook playbook.yaml -i inventory --ask-become-pass # -v

# cleanup
brew analytics off
brew cleanup

# home folder mgmt
bash ./scripts/symlink_onedrive.sh
bash ./scripts/git_dir.sh

# echo "Fixing macOS default settings..."
# sudo bash ./scripts/macos_settings.sh
