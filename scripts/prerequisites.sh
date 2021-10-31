#!/bin/bash

# Ensure Apple's command line tools are installed
if [[ $(command -v cc) ]]; then
  echo "Xcode already installed. Skipping."
else
  echo "Installing xcode ..."
  xcode-select --install
  sudo xcodebuild -license

fi

# install x86 compatibility layer
if [[ "$(arch)" = "arm64" ]]; then
  echo "Installing Rosetta2 combatibility layer"
  softwareupdate --install-rosetta --agree-to-license
fi

# Install Ansible via python
echo "Installing pip to base python"
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user
rm get-pip.py

echo "Installing Ansible"
if [[ $(command -v ansible ]]; then
  echo "Ansible already installed.  Skipping."
else
  # echo "Installing ansible via pip..."
  # pip install --user --upgrade ansible
  echo "Installing ansible via Homebrew..."
  brew install ansible
fi
echo "Installing/Updating Ansible requirements..."
ansible-galaxy install -r requirements.yml

# Ensure Homebrew (mac package manager) is installed
if [[ $(command -v brew) ]]; then
echo "Homebrew already installed. Skipping."
else
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

echo "Success! Prerequisites installed."
