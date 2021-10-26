#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

read -p "Separate git repositories from Documents (y/n)? [y]" GIT_SELECT
GIT_SELECT=${GIT_SELECT:-"y"}

if [[ "$GIT_SELECT" =~ $noexpr ]]; then
  echo "Skipping git folder setup."
  echo "WARNING: if Desktop and Documents are cloud synced (iCloud, OneDrive), "
  echo "saving git repositories in ~/Desktop or ~/Documents may risk sync conflicts!"
elif [[ "$GIT_SELECT" =~ $yesexpr ]]; then
  read -p "Please enter directory name for git repositories folder (to be located in $HOME): " GIT_DIR
  GIT_DIR=${GIT_DIR:-"_GitProjects"}
  echo "Creating '$HOME/$GIT_DIR' directory"
  mkdir -p $HOME/$GIT_DIR
fi
