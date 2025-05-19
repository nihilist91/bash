#!/bin/bash

# Update the package list
sudo apt-get update

# Install Python and pip
sudo apt-get install -y python3 python3-pip

# Upgrade pip to the latest version
sudo -H pip3 install --upgrade pip
