# README

- [README](#readme)
  - [Highlights](#highlights)
  - [Quickstart](#quickstart)
  - [Prerequisites](#prerequisites)
  - [Manual installation & configuration](#manual-installation--configuration)
  - [Secondary (manual) Configuration](#secondary-manual-configuration)
  - [Testing](#testing)
    - [macOS via VirtualBox](#macos-via-virtualbox)
  - [References](#references)

## Highlights

- Installs a variety of [command line tools](vars/homebrew_vars.yaml), notably:
  - [`bat`](https://github.com/sharkdp/bat) - Clone of cat(1) with syntax highlighting and Git integration
  - [`exa`](https://the.exa.website/) - Modern replacement for 'ls'
  - [`direnv`](https://direnv.net/) - Load/unload environment variables based on $PWD
  - developer tools like `gcc`, `git`, `jq`, etc
- Installs applications via [brew](vars/homebrew_vars.yaml) and [App Store](vars/appstore_vars.yaml), notably:
  - Window position manager [BetterSnapTool](https://www.folivora.ai/bettersnaptool/)
  - Menu bar managers [Bartender](https://www.macbartender.com/) or [Hidden Bar](https://apps.apple.com/us/app/hidden-bar/id1452453066?mt=12)
  - Menu bar calendar [Dato](https://apps.apple.com/us/app/dato/id1470584107?mt=12)
  - Webcam/mic security [OverSight](https://objective-see.com/products/oversight.html)
  - Easier drag-and-drop with [DropOver](https://dropoverapp.com/)
  - Application uninstaller [AppCleaner](https://freemacsoft.net/appcleaner/)
  - Terminal alternative [iTerm2](https://iterm2.com/)
  - Markdown notes/wiki manager [Obsidian](https://obsidian.md/)
  - Visual Studio Code
- Installs [mambaforge](https://mamba.readthedocs.io/en/latest/installation.html) `conda`
- Applies (opinionated!) configuration to terminal applications and zsh defaults
  - customized Terminal and iTerm2 profiles
  - customized zsh env via [zshconfig](https://www.github.com/ahgraber/zshconfig)

## Quickstart

### Prerequisites

1. Give `Terminal.app` Full Disk Access privileges in System Preferences
2. If `conda` is installed, ensure it is deactivated (or uninstalled!) before running: `conda deactivate`
3. [optional, but preferable] [Uninstall prior versions of homebrew](https://github.com/homebrew/install#uninstall-homebrew)
4. [optional] Log in to OneDrive

### Install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ahgraber/mac-setup/HEAD/install.sh)"
```

## Manual installation & configuration

1. Follow prerequisite steps (above)
2. Clone repo:

   ```sh
   git clone https://github.com/ahgraber/mac-setup.git
   ```

3. Customize configuration:

   - [homebrew_vars](./vars/homebrew_vars.yaml) installs applications & packages
     - `Casks` are applications and are updated through the application
     - `Packages` are binaries (generally called via command line) and are kept updated with Homebrew
   - [dock_vars](./vars/dock_vars.yaml) removes / retains / sets position for Dock applications
   - [vscode_vars](./vars/vscode_env.yaml) lists plugins to install into VSCode
   - [appstore_vars](./vars/appstore_vars.yaml) lists applications to install via Mac App Store

4. Tasks can be run individually:

   > Note: Ansible is installed to system python and will likely not be found unless you add system pythons to PATH

   ```sh
   ### assumes xcode command line tools & rosetta are intalled

   # add system pythons to path
   export PATH="$HOME/Library/Python/3.7/bin:$HOME/Library/Python/3.8/bin:$HOME/Library/Python/3.9/bin:$PATH"

   # install prerequisites
   bash ./scripts/prerequisites.sh

   # ansible + homebrew
   ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "homebrew"

   # add homebrew to path
   export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

   # ansible + dock
   ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "dock"

   # ansible + conda
   ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "conda"

   # ansible + terminal customization
   ansible-playbook playbook.yaml -i inventory --ask-become-pass --tags "terminals"

   # ansible + macos customization
   bash ./scripts/macos_user_settings.sh --no-restart
   sudo bash ./scripts/macos_system_settings.sh --no-restart

   # zsh configuration
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/ahgraber/zshconfig/HEAD/install.sh)"

   # home folder mgmt
   bash ./scripts/symlink_onedrive.sh
   bash ./scripts/git_dir.sh
   ```

## Secondary (manual) Configuration

- [ ] Sign into App Store and install App Store apps:

  ```sh
  # add system pythons to path (required for Ansible)
  export PATH="$HOME/Library/Python/3.7/bin:$HOME/Library/Python/3.8/bin:$HOME/Library/Python/3.9/bin:$PATH"
  ansible-playbook playbook-appstore.yaml -i inventory --ask-become-pass # -v
  ```

- [ ] Set git config (~/.gitconfig) by running the following in terminal:

  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "youremail@yourdomain.com"
  # https://leosiddle.com/posts/2020/07/git-config-pull-rebase-autostash/
  git config --global pull.rebase true
  git config --global rebase.autoStash true
  # git config --global credential.helper osxkeychain
  ```

- [ ] Modify keyboard shortcuts for Mission Control to not interfere with zsh keybinds (examples):

  |  icon  |          keybind           | description         |
  | :----: | :------------------------: | :------------------ |
  | `⌃⌥⌘↑` |  `ctrl + opt + cmd + up`   | Mission Control     |
  | `⌃⌥⌘↓` | `ctrl + opt + cmd + down`  | Application windows |
  | `⌃⌥⌘←` | `ctrl + opt + cmd + left`  | Move to Left Space  |
  | `⌃⌥⌘→` | `ctrl + opt + cmd + right` | Move to Right space |

- [ ] Install VSCode in path: in VSCode, `cmd` + `shift` + `P` --> `Install 'code' command in PATH`

- [ ] Check `conda` install. If `conda` not found, run

  ```sh
  "$HOME"/mambaforge/bin/conda init zsh
  ```

- [ ] Repair issues with dotfile hard links (if any exist)

  ```sh
  # example -- back up existing .zshrc and hard link
  mv ~/.zshrc ~/.zshrc.$(date +%Y%m%d)
  ln -s ~/.zshconfig/z4hrc .zshrc
  ```

- [ ] Manually install `homebrew` packages that require manual intervention (like EULA acceptance)

  ```sh
  brew install \
    azdata-cli \
    azure-cli \
    azure-functions-core-tools@4 \
    msodbcsql17 \
    mssql-tools \
  && az extension add -n ml -y
  ```

- [ ] Install brew using `Rosetta` terminal and install packages for use on the `Rosetta` side

  ```sh
  /usr/bin/arch -x86_64 /bin/zsh
  /usr/bin/arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  /usr/bin/arch -x86_64 /usr/local/bin/brew install \
    ...
  ```

- [ ] Install [`chrome web store`](https://github.com/NeverDecaf/chromium-web-store) extension for UnGoogled Chromium

- [ ] Permit quick look plugins (~/Library/QuickLook ([ref](https://github.com/whomwah/qlstephen#permissions-quarantine)))
      and/or in System Preferences

  ```sh
  for ql_gen in "$HOME/Library/QuickLook/*"; do
    xattr -cr "$ql_gen"
  done
  qlmanage -r
  qlmanage -r cache
  # relaunch finder (opt + leftclick)
  ```

- [ ] Sign in to git identity

  - [add new ssh key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

  - use a Personal Access Token

    ```sh
    git remote remove origin
    git remote add origin https://<GITHUB_USERNAME>:<GITHUB_TOKEN>@github.com/<user>/<repo>.git
    git pull origin main --rebase         # or whatever appropriate branch
    git push --set-upstream origin main   # or whatever appropriate branch
    ```

- [ ] Clean up bootstrap python (note this will remove the python where Ansible is installed)

  ```sh
  rm -rf $HOME/Library/Python
  ```

## Testing

### macOS via VirtualBox

Use `Vagrant` to manage images that are run in `VirtualBox`

<!-- * [vagrant image](https://github.com/ramsey/macos-vagrant-box) -->

- [vagrant image](https://app.vagrantup.com/nick-invision/boxes/macos-bigsur-base)
- [macinbox](https://github.com/bacongravy/macinbox)

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
