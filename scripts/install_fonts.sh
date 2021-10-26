#!/bin/bash
# install fonts
mkdir -p ~/Library/Fonts

# meslo nf
cp ./font/*.ttf ~/Library/Fonts

# install hack nerd font
curl -fsSL https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip > hackfont.zip
unzip hackfont.zip -d hackfont
cp hackfont/ttf/*.ttf ~/Library/Fonts
rm -rf hackfont.zip hackfont

# install awesome-terminal-fonts
curl -fsSL https://github.com/gabrielelana/awesome-terminal-fonts/archive/refs/tags/v1.1.0.zip > termfont.zip
unzip termfont.zip -d termfont/
cp termfont/awesome-terminal-fonts-1.1.0/build/*.ttf ~/Library/Fonts
mkdir -p ~/.fonts; cp termfont/awesome-terminal-fonts-1.1.0/build/*.sh ~/.fonts
rm -rf termfont.zip termfont
