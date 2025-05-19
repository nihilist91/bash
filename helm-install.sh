#!/bin/bash

# Download and install the latest version of Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Verify the installation
helm version
