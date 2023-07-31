#!/bin/bash

# Function to deploy the Dashboard UI
deploy_dashboard_ui() {
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
}

# Function to create the Service Account and ClusterRoleBinding
create_service_account_and_binding() {
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
}

# Function to get the Bearer Token
get_bearer_token() {
    BearerToken=$(kubectl -n kubernetes-dashboard describe secret "$(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')" | grep token: | awk '{print $2}')
    echo "Bearer Token: $BearerToken"
}

# Function to create the ingress controller
create_ingress_controller() {
    cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  namespace: kubernetes-dashboard
  name: kubernetes-dashboard-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    # Uncomment next if you use https://cert-manager.io/
    # cert-manager.io/cluster-issuer: "<YOUR CLUSTER ISSUER>"
spec:
  tls:
  - hosts:
    - localhost
    secretName: kubernetes-dashboard-cert
  rules:
  - host: localhost
    http:
      paths:
      - path: /
        backend:
          serviceName: kubernetes-dashboard
          servicePort: 443
EOF
}

# Main script starts here
deploy_dashboard_ui
create_service_account_and_binding
get_bearer_token
create_ingress_controller
