# Fonts

`Powerlevel10k` doesn't require custom fonts but can take advantage of them if they are available.
It works well with Nerd Fonts, Source Code Pro, Font Awesome, Powerline, and even the default system fonts.
The full choice of style options is available only when using Nerd Fonts.

> Recommended font: [Meslo Nerd Font patched for Powerlevel10k](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)

## Automatic font installation

If you follow the default setup script, `ansible-mac-setup` will install the font.

If you are using iTerm2 or Termux, `p10k configure` can install the recommended font for you.
Simply answer `Yes` when asked whether to install Meslo Nerd Font.

If you are using a different terminal, proceed with manual font installation.

## Manual font installation

1. Download these four ttf files:

   - [MesloLGS NF Regular.ttf](../font/MesloLGS%20NF%20Regular.ttf)
   - [MesloLGS NF Bold.ttf](../font/MesloLGS%20NF%20Bold.ttf)
   - [MesloLGS NF Italic.ttf](../font/MesloLGS%20NF%20Italic.ttf)
   - [MesloLGS NF Bold Italic.ttf](../font/MesloLGS%20NF%20Bold%20Italic.ttf)

2. Double-click on each file and click "Install". This will make `MesloLGS NF`
   font available to all applications on your system.

   - **Apple Terminal**: Open _Terminal → Preferences → Profiles → Text_, click _Change_ under _Font_
     and select `MesloLGS NF` family.
   - **iTerm2**: Open _iTerm2 → Preferences → Profiles → Text_ and set _Font_ to
     `MesloLGS NF`.
   - **Visual Studio Code**: Open _Code → Preferences → Settings_ (Mac), enter `terminal.integrated.fontFamily`
     in the search box at the top of _Settings_ tab and set the value below to `MesloLGS NF`.
