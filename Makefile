# Makefile for DevOps Observability Platform

CLUSTER_NAME=obs-platform

.PHONY: help install-deps cluster-up cluster-down cluster-status tools-init tools-plan tools-up tools-down dashboard

help:
	@echo "Usage:"
	@echo "  make install-deps   - Install k3d and kubectl (if missing)"
	@echo "  make cluster-up     - Create k3d cluster"
	@echo "  make cluster-down   - Delete k3d cluster"
	@echo "  make cluster-status - Check cluster status"
	@echo "  make tools-init     - Initialize Terraform"
	@echo "  make tools-plan     - Plan Terraform changes"
	@echo "  make tools-up       - Deploy all tools via Terraform (Jenkins, Sonar, Nexus, Monitoring)"
	@echo "  make tools-down     - Remove all tools via Terraform"
	@echo "  make dashboard      - Open all tool dashboards (port-forward)"

dashboard:
	@./cicd/infrastructure/k8s/start_ports.sh

install-deps:
	@echo "Installing k3d..."
	@curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
	@echo "k3d installed successfully."
	@echo "Installing terraform..."
	@curl -LO https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
	@unzip -o terraform_1.9.0_linux_amd64.zip
	@sudo mv terraform /usr/local/bin/
	@rm terraform_1.9.0_linux_amd64.zip LICENSE.txt
	@echo "terraform installed successfully."

cluster-up:
	@chmod +x cicd/infrastructure/k8s/create_cluster.sh
	@./cicd/infrastructure/k8s/create_cluster.sh $(CLUSTER_NAME)

cluster-down:
	@echo "Deleting cluster $(CLUSTER_NAME)..."
	@k3d cluster delete $(CLUSTER_NAME)

cluster-status:
	@KUBECONFIG=$(HOME)/.kube/config kubectl get nodes
	@k3d cluster list

tools-init:
	@cd cicd/infrastructure/terraform && terraform init

tools-plan:
	@cd cicd/infrastructure/terraform && terraform plan

tools-up:
	@cd cicd/infrastructure/terraform && terraform apply -auto-approve

tools-down:
	@cd cicd/infrastructure/terraform && terraform destroy -auto-approve
