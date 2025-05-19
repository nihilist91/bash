#!/bin/bash

# Update the system
sudo apt-get update

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker's stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the system again
sudo apt-get update

# Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify the installation
sudo docker version
