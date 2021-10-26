#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

ONEDRIVE_DIR="$(/bin/ls ~ | grep OneDrive)"
if [[ -d "$HOME/$ONEDRIVE_DIR" ]]; then
  read -p "Symlink OneDrive folders (yes/no)? [y] " USER_SELECT
  USER_SELECT=${USER_SELECT:-"y"}
  # echo "USER_SELECT: $USER_SELECT"

  if [[ "$USER_SELECT" =~ $noexpr ]]; then
    echo "Retaining separate folders for user home ($HOME) and OneDrive"; exit
  elif [[ "$USER_SELECT" =~ $yesexpr ]]; then
    echo "Backing up current desktop ($HOME/Desktop) and documents ($HOME/Documents) folders"
    if [[ -d $HOME/Desktop.old ]] || [[ -d $HOME/Documents.old ]]; then
      echo "WARNING: '.old' directories already exist"
      read -p "Continue and overwrite (yes/no)? [y] " OVERWRITE
      OVERWRITE=${OVERWRITE:-"y"}
      # echo "OVERWRITE: $OVERWRITE"

      if [[ "$OVERWRITE" =~ $noexpr ]]; then
        echo "Exiting"
        exit 0
      elif [[ "$USER_SELECT" =~ $yesexpr ]]; then
        echo "Overwriting current '.old' directories"
      fi
    fi
    sudo mv $HOME/Desktop $HOME/Desktop.old
    sudo mv $HOME/Documents $HOME/Documents.old
    echo "Symlinking OneDrive folders"
    sudo ln -fs "$ONEDRIVE_DIR"/Desktop
    sudo ln -fs "$ONEDRIVE_DIR"/Documents
  fi
fi
