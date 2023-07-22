#!/bin/bash

# Function to check if Terraform is already installed
check_terraform_installed() {
    if command -v terraform &>/dev/null; then
        echo "Terraform is already installed."
        exit 0
    fi
}

# Function to install Terraform
install_terraform() {
    # Import HashiCorp GPG key
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    # Add HashiCorp repository to sources.list.d
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    # Update package list and install Terraform
    sudo apt update
    sudo apt install terraform
}

# Main script starts here
check_terraform_installed
install_terraform

echo "Terraform installation completed successfully."
