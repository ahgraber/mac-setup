#!/bin/bash
set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

echo "If your ~/Documents are cloud-synced, recommend keeping version-control directories separate."
read -p "Separate git repositories from Documents? (y/n)? [y]" git_select
git_select=${git_select:-"y"}

if [[ "$git_select" =~ $noexpr ]]; then
  echo "Skipping git folder setup."
  echo "WARNING: if Desktop and Documents are cloud synced (iCloud, OneDrive), "
  echo "saving git repositories in ~/Desktop or ~/Documents may risk sync conflicts!"
elif [[ "$git_select" =~ $yesexpr ]]; then
  read -p "Please enter directory name for git repositories folder (to be located in $HOME): " git_dir
  git_dir=${git_dir:-"_GitProjects"}
  echo "Creating '$HOME/$git_dir' directory"
  mkdir -p $HOME/$git_dir
fi
