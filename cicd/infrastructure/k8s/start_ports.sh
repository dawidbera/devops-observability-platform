#!/bin/bash
# Script to start all port-forwards in the background

export KUBECONFIG=${HOME}/.config/k3d/kubeconfig-obs-platform.yaml

echo "Stopping existing port-forwards..."
pkill -f "kubectl port-forward" || true

echo "Starting Port-Forwards in background..."

# Jenkins (Local 8888 -> Remote 8080)
kubectl port-forward svc/jenkins -n jenkins 8888:8080 --address 0.0.0.0 > /dev/null 2>&1 &
echo "✔ Jenkins: http://localhost:8888"

# Grafana (Local 3000 -> Remote 80)
kubectl port-forward svc/grafana -n monitoring 3000:80 --address 0.0.0.0 > /dev/null 2>&1 &
echo "✔ Grafana: http://localhost:3000"

# SonarQube (Local 9000 -> Remote 9000)
kubectl port-forward svc/sonarqube-sonarqube -n sonarqube 9000:9000 --address 0.0.0.0 > /dev/null 2>&1 &
echo "✔ SonarQube: http://localhost:9000"

# Nexus (Local 8081 -> Remote 8081 - directly to pod port to avoid proxy issues)
NEXUS_POD=$(kubectl get pods -n nexus -l app=sonatype-nexus -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $NEXUS_POD -n nexus 8081:8081 --address 0.0.0.0 > /dev/null 2>&1 &
echo "✔ Nexus: http://localhost:8081"

echo "-------------------------------------------------------"
echo "All dashboards are now accessible. Do not close this script (or run in background)."
echo "Press Ctrl+C to stop all port-forwards."
wait
