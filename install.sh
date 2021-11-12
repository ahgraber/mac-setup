#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

# Ensure Apple's command line tools are installed
check_xcode() { xcode-select -p 2>&1; }
err_msg="xcode-select: error:"
if [[ $(check_xcode) == *"$err_msg"* ]]; then
  echo "Installing xcode ..."
  xcode-select --install
  while [[ $(check_xcode) == *"$err_msg"* ]]; do sleep 10; done;
else
  echo "Xcode already installed. Skipping."
fi

# Ensure x86 compatibility layer is installed
if [[ "$(arch)" == "arm64" ]] && [[ ! -f /Library/Apple/usr/share/rosetta/rosetta ]]; then
  echo "Installing Rosetta2 combatibility layer"
  softwareupdate --install-rosetta --agree-to-license
  while [[ ! "$(pkgutil --pkgs | grep Rosetta)" == "com.apple.pkg.RosettaUpdateAuto" ]]; do sleep 10; done;
else
  echo "Rosetta2 already installed. Skipping."
fi

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

# add pythons to path
export PATH="$HOME/Library/Python/3.7/bin:$HOME/Library/Python/3.8/bin:$HOME/Library/Python/3.9/bin:$PATH"

# install prerequisites (rosetta2, python pip, ansible)
echo "Installing prerequisites..."
bash ./scripts/prerequisites.sh

# ansible + homebrew
echo "Running Homebrew tasks via Ansible playbook..."
ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "homebrew" # -v

# add homebrew to path
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# ansible + dock
echo "Running Dock tasks via Ansible playbook..."
ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "dock" # -v

# ansible + conda
echo "Running Conda tasks via Ansible playbook..."
ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "conda" # -v

# ansible + terminals customization
echo "Running Terminal tasks via Ansible playbook..."
ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "terminals" # -v

# ansible + mac customization
echo "Running MacOS tasks via Ansible playbook..."
# ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "macos" # -v
bash ./scripts/macos_user_settings.sh --no-restart
sudo bash ./scripts/macos_system_settings.sh --no-restart

# zsh configuration
echo "Configuring zsh from ahgraber/zshconfig..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ahgraber/zshconfig/HEAD/install.sh)"

# brew cleanup
brew analytics off
brew cleanup

# home folder mgmt
bash ./scripts/symlink_onedrive.sh
bash ./scripts/git_dir.sh

# echo "Fixing macOS default settings..."
# sudo bash ./scripts/macos_settings.sh

echo "Setup complete."
echo "Some settings may not take effect until you log out or restart."
echo "You may delete this project (~/mac-setup) if you wish."
