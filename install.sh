#!/bin/bash

read -p "Clone to home directory (y/n)? [y]" USE_HOME
case USE_HOME in
  n | N) read -p "Please enter destination directory: " DEST_DIR
  ;;
esac
# default to home dir
DEST_DIR=${DEST_DIR:-$HOME}

echo "Cloning into ${DEST_DIR}"
mkdir -p ${DEST_DIR}
git clone https://github.com/ahgraber/ansible-mac-setup.git

cd ${DEST_DIR}/ansible-mac-setup/

bash ./setup.sh
