# README

## Quickstart

The following script will autoinstall the default configuration:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ahgraber/ansible-mac-setup/HEAD/install.sh)"
```

## Prerequisites

1. Run installation script to install xcode CLI, pip, and ansible

```sh
sh ./01-install_ansible.sh
```

## Manual installation & configuration

1. Clone repo:

   ```sh
   git clone https://github.com/ahgraber/ansible-mac-setup.git
   ```

2. Configuration:
   * [dock_vars](./vars/dock_vars.yaml) removes / retains / sets position for Dock applications
   * [homebrew_vars](./vars/homebrew_vars.yaml) installs applications & packages
     * `Casks` are applications and are updated through the application
     * `Packages` are binaries (generally called via command line) and are kept updated with Homebrew
   * [vscode_vars](./vars/vscode_env.yaml) lists plugins to install into VSCode

3. Run:

   ```sh
   bash ./setup.sh
   ```

   or install piecemeal:

   ```sh
   # install prerequisites
   # xcode command line tools
   # python pip
   # ansible
   bash ./scripts/prerequisites.sh

   # install with ansible
   # applications & packages w/ homebrew
   # dock customization
   # vscode customization
   # zsh customization
   ansible-playbook playbook.yml -i inventory --ask-sudo-pass -vvvv

   # home folder mgmt
   bash ./scripts/symlink_onedrive.sh
   bash ./scripts/git_dir.sh

   sudo bash ./scripts/osx_settings.sh
   ```

## Manual followup

* [ ] Update iTerm2 default profile or set Dynamic as default: _Preferences > Profiles_

* [ ] Set git config

  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "youremail@yourdomain.com"
  # git config --global credential.helper osxkeychain
  ```

* [ ] Repair issues with dotfile hard links (if any exist)

  ```sh
  # example -- back up existing .zshrc and hard link
  mv ~/.zshrc ~/.zshrc.bak
  ln ~/ansible-mac-setup/files/dotfiles/zshrc .zshrc
  ```

## Testing

[Use VirtualBox](https://github.com/myspaghetti/macos-virtualbox) to set up a MacOS virtual machine guest OS for testing.

```sh
# run to create VM in shell interactive mode
/bin/zsh -i -c "$(curl -fsSL https://raw.githubusercontent.com/myspaghetti/macos-virtualbox/master/macos-guest-virtualbox.sh)"
```
