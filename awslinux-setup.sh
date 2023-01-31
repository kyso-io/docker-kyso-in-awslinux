#!/bin/sh
# ----
# File:        awslinux-setup.sh
# Description: Script to setup a minimal awslinux 2 ec machine
# Author:      Sergio Talens-Oliag <sto@kyso.io>
# Copyright:   (c) 2023 Sergio Talens-Oliag <sto@kyso.io>
# ----

set -e

# ---------
# VARIABLES
# ---------

# PATH VARIABLES
SCRIPT="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT")"
BIN_DIR="$(readlink -f "$SCRIPT_DIR/bin")"

# ---------
# FUNCTIONS
# ---------

update_and_install() {
  # Update installation
  sudo yum update -y
  # Install git & configure local store (we use a readonly token)
  sudo yum install -y git
  git config --global credential.helper store
  # Install docker
  sudo yum install -y docker
  # Add the current user to the docker group
  sudo usermod -a -G docker "$(id -un)"
  # Enable docker service
  sudo systemctl enable docker
  # Start docker service
  sudo systemctl start docker
  # Check the Docker service.
  sudo systemctl status docker
  # Clean yum cache
  sudo yum clean all
}

# ----
# MAIN
# ----

echo "Updating & installing packages"
echo ""
update_and_install
if [ ! -d "$HOME/bin" ]; then
  mkdir "$HOME/bin"
fi

echo "Installing container management scripts"
echo ""
install "$BIN_DIR/app-docker-exec" "$HOME/bin/"
install "$BIN_DIR/docker-kyso" "$HOME/bin/"
ln -s "app-docker-exec" "$HOME/bin/kyso"

echo "The system must be ready to use the kyso application using containers"
echo ""

# ----
# vim: ts=2:sw=2:et:ai:sts=2
