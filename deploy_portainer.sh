#!/bin/bash

# Function to deploy Portainer using Helm
deploy_portainer_with_helm() {
    # Add the Portainer Helm repository
    helm repo add portainer https://portainer.github.io/k8s/
    helm repo update

    # Upgrade or install Portainer Helm chart
    helm upgrade --install --create-namespace -n portainer portainer portainer/portainer \
        --set enterpriseEdition.enabled=true \
        --set service.type=ClusterIP \
        --set tls.force=true \
        --set ingress.enabled=true \
        --set ingress.ingressClassName=nginx \
        --set ingress.annotations."nginx\.ingress\.kubernetes\.io/backend-protocol"=HTTPS \
        --set ingress.hosts[0].host=localhost.portainer \
        --set ingress.hosts[0].paths[0].path="/"
}

# Main script starts here
deploy_portainer_with_helm

echo "Portainer deployment using Helm completed successfully."
