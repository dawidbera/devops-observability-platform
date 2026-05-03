# Makefile for DevOps Observability Platform

CLUSTER_NAME=obs-platform

.PHONY: help install-deps cluster-up cluster-down cluster-status tools-up tools-down

help:
	@echo "Usage:"
	@echo "  make install-deps   - Install k3d and kubectl (if missing)"
	@echo "  make cluster-up     - Create k3d cluster"
	@echo "  make cluster-down   - Delete k3d cluster"
	@echo "  make cluster-status - Check cluster status"
	@echo "  make tools-up       - Deploy Jenkins and SonarQube"
	@echo "  make tools-down     - Remove Jenkins and SonarQube"

install-deps:
	@echo "Installing k3d..."
	@curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
	@echo "k3d installed successfully."

cluster-up:
	@chmod +x cicd/infrastructure/k8s/create_cluster.sh
	@./cicd/infrastructure/k8s/create_cluster.sh $(CLUSTER_NAME)

cluster-down:
	@echo "Deleting cluster $(CLUSTER_NAME)..."
	@k3d cluster delete $(CLUSTER_NAME)

cluster-status:
	@KUBECONFIG=$(HOME)/.kube/config kubectl get nodes
	@k3d cluster list

tools-up:
	@chmod +x cicd/infrastructure/k8s/deploy_tools.sh
	@./cicd/infrastructure/k8s/deploy_tools.sh

tools-down:
	@KUBECONFIG=$(HOME)/.kube/config helm uninstall jenkins -n jenkins || true
	@KUBECONFIG=$(HOME)/.kube/config helm uninstall sonarqube -n sonarqube || true
	@KUBECONFIG=$(HOME)/.kube/config helm uninstall nexus -n nexus || true
	@KUBECONFIG=$(HOME)/.kube/config helm uninstall prometheus -n monitoring || true
	@KUBECONFIG=$(HOME)/.kube/config helm uninstall grafana -n monitoring || true
