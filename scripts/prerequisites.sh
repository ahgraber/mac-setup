#!/bin/bash

# Ensure Apple's command line tools are installed
if ! command -v cc >/dev/null; then
  echo "Installing xcode ..."
  xcode-select --install
  sudo xcodebuild -license
else
  echo "Xcode already installed. Skipping."
fi

# Install Ansible via python
echo "Installing pip to base python"
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user
rm get-pip.py

echo "Installing Ansible"
pip install --user --upgrade ansible
ansible-galaxy install -r requirements.yml

# Ensure Homebrew (mac package manager) is installed
if ! command -v brew >/dev/null; then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
else
  echo "Homebrew already installed. Skipping."
fi

# install fonts
bash ./scripts/install_fonts.sh

echo "Success!"
