# README

## Quickstart

The following script will autoinstall the default configuration:

* Rosetta2 (if Apple Silicon detected)
* [Ansible](https://docs.ansible.com) via `pip`
* [Homebrew](https://brew.sh)
  * [packages and applications](./vars/homebrew_vars.yaml)
* `conda` via [mambaforge](https://github.com/conda-forge/miniforge)
* customized Terminal and iTerm2 profiels
* customized zsh env via [zshconfig](https://www.github.com/ahgraber/zshconfig)

## Prerequisites

```zsh
# Ensure Apple's command line tools are installed
if [[ $(command -v cc) ]]; then
  echo "Xcode already installed. Skipping."
else
  echo "Installing xcode ..."
  xcode-select --install
  sudo xcodebuild -license
fi

# update path
typeset -U path
pythons=($HOME/Library/Python/3.7/bin $HOME/Library/Python/3.8/bin $HOME/Library/Python/3.9/bin)
export path=($pythons /usr/local/bin /usr/bin /bin /usr/sbin /sbin $path)

# run install script
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ahgraber/mac-setup/HEAD/install.sh)"
```

## Manual installation & configuration

1. Clone repo:

   ```sh
   git clone https://github.com/ahgraber/mac-setup.git
   ```

2. Customize configuration:
   * [dock_vars](./vars/dock_vars.yaml) removes / retains / sets position for Dock applications
   * [homebrew_vars](./vars/homebrew_vars.yaml) installs applications & packages
     * `Casks` are applications and are updated through the application
     * `Packages` are binaries (generally called via command line) and are kept updated with Homebrew
   * [vscode_vars](./vars/vscode_env.yaml) lists plugins to install into VSCode

3. Run:

   ```sh
   # install prerequisites
   bash ./scripts/prerequisites.sh

   # install with ansible
   # homebrew applications & packages
   # dock customization
   # vscode customization
   # zsh customization
   ansible-playbook playbook.yaml -i inventory --ask-become-pass # -v

   # home folder mgmt
   bash ./scripts/symlink_onedrive.sh
   bash ./scripts/git_dir.sh
   ```

## Manual followup

* [ ] Modify keyboard shortcuts for Mission Control to not interfere with zsh keybinds:

  | icon | keybind | description |
  |:---:|:---:|:---|
  | `⌃⌥⌘↑` | `ctrl + opt + cmd + up` | Mission Control |
  | `⌃⌥⌘↓` | `ctrl + opt + cmd + down` | Application windows |
  | `⌃⌥⌘←` | `ctrl + opt + cmd + left` | Move to Left Space |
  | `⌃⌥⌘→` | `ctrl + opt + cmd + right` | Move to Right space|

* [ ] Set git config

  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "youremail@yourdomain.com"
  # https://leosiddle.com/posts/2020/07/git-config-pull-rebase-autostash/
  git config --global pull.rebase true
  git config --global rebase.autoStash true
  # git config --global credential.helper osxkeychain
  ```

* [ ] Check `conda` install. If `conda` not found, run

  ```sh
  $HOME/mambaforge/bin/conda init zsh
  ```

* [ ] Repair issues with dotfile hard links (if any exist)

  ```sh
  # example -- back up existing .zshrc and hard link
  mv ~/.zshrc ~/.zshrc.$(date +%Y.%m.%d)
  ln -s ~/.zshconfig/zshrc .zshrc
  ```

* [ ] Install any `homebrew` packages that require external taps

  ```sh
  HOMEBREW_NO_ENV_FILTERING=1 ACCEPT_EULA=Y brew install \
    azdata-cli \
    msodbcsql17 \
    mssql-tools
  ```

* [ ] Install VSCode in path: cmd+shift+P --> `Install 'code' command in PATH`

* [ ] Update Terminal default profile
* [ ] Update iTerm2 default profile
* [ ] Install [`chrome web store`](https://github.com/NeverDecaf/chromium-web-store) extension for UnGoogled Chromium
* [ ] Consider `dropzone` [plugins](https://aptonic.com/actions)
* [ ] Permit quick look plugins (~/Library/QuickLook ([ref](https://github.com/whomwah/qlstephen#permissions-quarantine))

  ```sh
  for ql_gen in *; do
    xattr -cr "$HOME/Library/QuickLook/$ql_gen"
  done
  qlmanage -r
  qlmanage -r cache
  # relaunch finder (opt + leftclick)
  ```

## Testing

### macOS via VirtualBox

Use `Vagrant` to manage images that are run in `VirtualBox`

<!-- * [vagrant image](https://github.com/ramsey/macos-vagrant-box) -->
* [vagrant image](https://app.vagrantup.com/nick-invision/boxes/macos-bigsur-base)
* [macinbox](https://github.com/bacongravy/macinbox)

1. Install prerequisites

   ```sh
   set -- $(locale LC_MESSAGES)
   yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

   # install prerequisites?
   prerequisites='y'
   if [[ "$prerequisites" =~ $yesexpr ]]; then
     brew install \
       vagrant \
       virtualbox \
       virtualbox-extension-pack
   fi
   ```

2. Get vagrant box image

   ```sh
   # download image
   # vagrant box add ramsey/macos-catalina
   vagrant box add amarcireau/macos
   # vagrant box add nick-invision/macos-bigsur-base

   # initialize Vagrantfile
   # vagrant init ramsey/macos-catalina
   vagrant init amarcireau/macos
   # vagrant init nick-invision/macos-bigsur-base
   ```

3. Configure Vagrantfile

   ```sh
   cat > Vagrantfile <<EOF
   ENV["VAGRANT_EXPERIMENTAL"] = "typed_triggers"

   Vagrant.configure("2") do |config|
     config.vm.box = "amarcireau/macos"
     config.vm.box_version = "11.3.1"
     config.vm.synced_folder ".", "/vagrant", disabled: true
     config.vm.provider "virtualbox" do |vb|
       vb.check_guest_additions = false
       # Display the VirtualBox GUI when booting the machine
       vb.gui = true
       # Configure cpu and memory resources
       vb.cpus = "2"
       vb.memory = "6144"
     end
     config.trigger.after :"VagrantPlugins::ProviderVirtualBox::Action::Import", type: :action do |t|
       t.ruby do |env, machine|
         FileUtils.cp(
           machine.box.directory.join("include").join("macOS.nvram").to_s,
           machine.provider.driver.execute_command(["showvminfo", machine.id, "--machinereadable"]).
             split(/\n/).
             map {|line| line.partition(/=/)}.
             select {|partition| partition.first == "BIOS NVRAM File"}.
             last.
             last[1..-2]
         )
       end
     end
   end
   EOF
   ```

4. Launch in virtualbox

   ```sh
   vagrant up --provider=virtualbox
   # user/pass: vagrant
   ```

## References
