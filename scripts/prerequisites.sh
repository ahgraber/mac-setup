#!/bin/bash

# install x86 compatibility layer
if [[ "$(arch)" = "arm64" ]]; then
  echo "Installing Rosetta2 combatibility layer"
  softwareupdate --install-rosetta --agree-to-license
fi

# # Ensure Homebrew (mac package manager) is installed
# if [[ $(command -v brew) ]]; then
# echo "Homebrew already installed. Updating..."
# brew update-reset
# else
#   echo "Installing Homebrew..."
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#   # add to path for session
#   PATH="/usr/local/bin:/opt/homebrew:/usr/$PATH"
#   # echo 'eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"' >> ${shell_profile}}
# fi
# brew analytics off
# brew cleanup

# Install/update python pip
# echo "Installing pip to base python"
# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# python3 get-pip.py --user
# rm get-pip.py
echo "Updating pip"
python3 -m pip install --user --upgrade pip

# Install Ansible
echo "Installing Ansible"
if [[ $(command -v ansible) ]]; then
  echo "Ansible already installed.  Skipping."
else
  echo "Installing ansible..."
  # brew install ansible
  python3 -m pip install --user --upgrade ansible
fi

echo "Installing/Updating Ansible requirements..."
ansible-galaxy install -c -r requirements.yaml

echo "Success! Prerequisites installed."
