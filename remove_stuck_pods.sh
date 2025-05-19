#!/bin/bash

# Function to remove stuck pods in the "Terminating" state in all namespaces
remove_stuck_pods() {
    local terminated_pods

    # Get the names of pods stuck in the "Terminating" state in all namespaces
    terminated_pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Terminating -o jsonpath='{range .items[?(@.status.phase=="Terminating")]}{.metadata.namespace}/{.metadata.name}{"\n"}{end}')

    # Delete the stuck pods forcefully
    for pod in $terminated_pods; do
        namespace=$(echo "$pod" | cut -d '/' -f 1)
        pod_name=$(echo "$pod" | cut -d '/' -f 2)

        echo "Deleting pod: $pod_name in namespace: $namespace"
        kubectl delete pod "$pod_name" -n "$namespace" --grace-period=0 --force
    done
}

# Main script starts here
remove_stuck_pods

echo "Stuck pods in the 'Terminating' state have been forcefully removed."
