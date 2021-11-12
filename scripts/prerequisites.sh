#!/bin/bash

echo "Updating pip"
python3 -m pip install --upgrade pip

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

# Install fonts
# install fonts
mkdir -p "$HOME/Library/Fonts"

# meslo nf
if ! ls ~/Library/Fonts/Meslo* &> /dev/null; then
  echo "Installing Meslo NF to ~/Library/Fonts..."
  cp ./font/*.ttf "$HOME/Library/Fonts"
fi

# install hack nerd font
if ! ls ~/Library/Fonts/Hack* &> /dev/null; then
  echo "Installing Hack Nerd Font to ~/Library/Fonts..."
  curl -fsSL https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip > hackfont.zip
  unzip hackfont.zip -d hackfont
  cp hackfont/ttf/*.ttf "$HOME/Library/Fonts"
  rm -rf hackfont.zip hackfont
fi

# install awesome-terminal-fonts
if ! ls ~/Library/Fonts/fontawesome* &> /dev/null; then
  echo "Installing awesome-terminal-fonts to ~/Library/Fonts..."
  curl -fsSL https://github.com/gabrielelana/awesome-terminal-fonts/archive/refs/tags/v1.1.0.zip > termfont.zip
  unzip termfont.zip -d termfont/
  cp termfont/awesome-terminal-fonts-1.1.0/build/*.ttf "$HOME/Library/Fonts"
  mkdir -p "$HOME/.fonts"; cp termfont/awesome-terminal-fonts-1.1.0/build/*.sh "$HOME/.fonts"
  rm -rf termfont.zip termfont
fi

echo "Success! Prerequisites installed."
