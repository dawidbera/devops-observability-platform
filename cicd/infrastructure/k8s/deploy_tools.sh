#!/bin/bash
# Script to deploy Jenkins and SonarQube using Helm

set -e

KUBECONFIG_PATH="$HOME/.kube/config"
export KUBECONFIG=$KUBECONFIG_PATH

echo "Adding Helm repositories..."
helm repo add jenkins https://charts.jenkins.io
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo add oteemo https://oteemo.github.io/charts
helm repo update

echo "Creating namespaces..."
kubectl create namespace jenkins --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace sonarqube --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace nexus --dry-run=client -o yaml | kubectl apply -f -

echo "Deploying Jenkins..."
helm upgrade --install jenkins jenkins/jenkins \
  --namespace jenkins \
  -f cicd/infrastructure/helm/jenkins-values.yaml \
  --wait --timeout 10m

echo "Deploying SonarQube..."
helm upgrade --install sonarqube sonarqube/sonarqube \
  --namespace sonarqube \
  -f cicd/infrastructure/helm/sonarqube-values.yaml \
  --wait --timeout 15m

echo "Deploying Nexus..."
helm upgrade --install nexus oteemo/sonatype-nexus \
  --namespace nexus \
  -f cicd/infrastructure/helm/nexus-values.yaml \
  --wait --timeout 15m

echo "Tools deployed successfully."
