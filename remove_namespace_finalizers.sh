#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install jq
install_jq() {
    echo "Installing jq..."
    if command_exists "apt"; then
        sudo apt update
        sudo apt install -y jq
    elif command_exists "brew"; then
        brew install jq
    else
        echo "Unsupported package manager. Please install jq manually and rerun the script."
        exit 1
    fi
}

# Function to install kubectl
install_kubectl() {
    echo "Installing kubectl..."
    if command_exists "curl"; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
    else
        echo "curl is not installed. Please install kubectl manually and rerun the script."
        exit 1
    fi
}

# Function to remove finalizers from namespaces in the "Terminating" state
remove_namespace_finalizers() {
    for ns in $(kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}')
    do
        kubectl get ns "$ns" -ojson | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -
    done

    for ns in $(kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}')
    do
        kubectl get ns "$ns" -ojson | jq '.metadata.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -
    done
}

# Main script starts here
if ! command_exists "jq"; then
    install_jq
fi

if ! command_exists "kubectl"; then
    install_kubectl
fi

remove_namespace_finalizers

echo "Namespace finalizers have been removed from namespaces in the 'Terminating' state."
