#!/bin/bash

# Exit script on any error
set -e

# Define variables
REPO="deb http://archive.ubuntu.com/ubuntu focal main universe"
PACKAGE="libssl1.1"
SOURCES_LIST="/etc/apt/sources.list"

echo "Checking if the repository is already in sources.list..."
if ! grep -qF "$REPO" "$SOURCES_LIST"; then
    echo "The repository was not found. Adding it to sources.list..."
    echo "$REPO" | sudo tee -a "$SOURCES_LIST" > /dev/null
    REPO_ADDED=true
else
    echo "The repository is already present in sources.list."
    REPO_ADDED=false
fi

echo "Updating package lists..."
sudo apt-get update

echo "Installing $PACKAGE..."
sudo apt-get install -y "$PACKAGE" build-essential libpam0g-dev autoconf automake libtool

if [ "$REPO_ADDED" = true ]; then
    echo "Removing the repository from sources.list..."
    sudo sed -i "\|$REPO|d" "$SOURCES_LIST"
    echo "Repository removed from sources.list."
else
    echo "Repository was already present, so it won't be removed."
fi

echo "Updating package lists to clean up..."
sudo apt-get update

echo "$PACKAGE installation completed!"

echo "Running autogen"
sudo ./autogen.sh

echo "Running configure"
sudo ./configure

echo "Running make"
sudo make

echo "Running make install"
sudo make install

echo "Evo PAM Module successfully installed"
