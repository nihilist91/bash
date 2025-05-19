#!/bin/bash

# Select iptables-legacy as the default
sudo update-alternatives --config iptables <<< '1'

# Start the Docker service
sudo service docker start
