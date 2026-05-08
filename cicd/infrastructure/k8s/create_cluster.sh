#!/bin/bash
# Script to create a k3d cluster for the DevOps Observability Platform

CLUSTER_NAME=${1:-"obs-platform"}

echo "Checking if cluster ${CLUSTER_NAME} already exists..."
if k3d cluster list | grep -q "${CLUSTER_NAME}"; then
    echo "Cluster ${CLUSTER_NAME} already exists. Skipping creation."
else
    echo "Creating k3d cluster: ${CLUSTER_NAME}..."
    # Map port 80/443 for Ingress controller later
    # Map 8080 for Jenkins/App access
    k3d cluster create "${CLUSTER_NAME}" \
        --api-port 6550 \
        -p "80:80@loadbalancer" \
        -p "443:443@loadbalancer" \
        -p "8080:8080@loadbalancer" \
        --agents 2 \
        --wait
fi

echo "Switching context to k3d-${CLUSTER_NAME}..."
k3d kubeconfig merge "${CLUSTER_NAME}" --kubeconfig-merge-default --kubeconfig-switch-context

echo "Cluster is ready."
