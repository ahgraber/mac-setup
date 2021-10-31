#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

onedrive_dir="$(/bin/ls $HOME | grep OneDrive)"
if [[ -d "$HOME/$onedrive_dir" ]]; then
  read -p "Symlink OneDrive folders (yes/no)? [y] " user_select
  user_select=${user_select:-"y"}

  if [[ "$user_select" =~ $noexpr ]]; then
    echo "Retaining separate folders for user home ($HOME) and OneDrive"; exit
  elif [[ "$user_select" =~ $yesexpr ]]; then
    echo "Backing up current desktop ($HOME/Desktop) and documents ($HOME/Documents) folders"
    if [[ -d $HOME/Desktop.old ]] || [[ -d $HOME/Documents.old ]]; then
      echo "WARNING: '.old' directories already exist"
      read -p "Continue and overwrite (yes/no)? [y] " overwrite
      overwrite=${overwrite:-"y"}

      if [[ "$overwrite" =~ $noexpr ]]; then
        echo "Exiting"
        exit 0
      elif [[ "$user_select" =~ $yesexpr ]]; then
        echo "Overwriting current '.old' directories"
      fi
    fi
    sudo mv $HOME/Desktop $HOME/.Desktop.old
    sudo mv $HOME/Documents $HOME/.Documents.old
    echo "Symlinking OneDrive folders"
    sudo ln -fs "$onedrive_dir"/Desktop
    sudo ln -fs "$onedrive_dir"/Documents
  fi
fi
