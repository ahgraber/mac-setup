#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

# if dest_dir already contains .git file, assume we've already installed there once
if [[ -d "$HOME/mac-setup/.git" ]]; then
  read -p "Update from source? (y/n)? [y] " git_select
  git_select=${git_select:-"y"}

  if [[ "$git_select" =~ $yesexpr ]]; then
    echo -e "\nUpdating (Will attempt to reapply any local changes)..."
    cd "$HOME/mac-setup/" || exit
    echo -e "\nStashing local changes (stash)..."
    git stash
    echo -e "\nUpdating (pull --rebase)..."
    git checkout main && git pull --rebase origin
    echo -e "\nReverting local changes (stash pop)..."
    git stash pop
  fi
  unset git_select

else
  echo "Cloning into $HOME/mac-setup"
  cd "$HOME" || exit
  git clone https://github.com/ahgraber/mac-setup.git
fi

cd "$HOME/mac-setup/" || exit

echo ""
read -p "Do you want to customize the install before continuing? (y/n)? [n] " install_select
install_select=${install_select:-"n"}

if [[ "$install_select" =~ $noexpr ]]; then
  echo "Installing..."
else
  echo 'Exiting installer. Once customization is complete,'
  echo 'you can follow the instructions in the README for manual installation,'
  echo 'or run the install script (`bash $HOME/mac-setup/install.sh`)'
  exit 0
fi
unset install_select

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
