# DevOps Infrastructure & GitOps Setup Guide

This repository contains the Terraform infrastructure, Ansible automation, and Helm charts for deploying the application and observability stack via Argo CD.

---

## Architecture Overview

- **Application Repo:** `https://github.com/AazadD/devops-app` (Node.js microservice + GitHub Actions CI/CD)
- **Infrastructure Repo:** `https://github.com/AazadD/devops-infra` (Terraform, Ansible, Helm chart)
- **GitOps Repo:** `https://github.com/AazadD/gitops` (Argo CD App-of-Apps, workloads, monitoring stack)

---

## Prerequisites

- **Terraform** 
- **Ansible** 
- **kubectl** & **Helm 
- Access to an Ubuntu 22.04 LTS server (or AWS EC2 instance)

---

## Setup & Execution Steps

### 1. Provision Cloud Infrastructure (Terraform)
Provisions the VPC, subnets, security groups, and compute instance:
```bash
cd terraform
terraform init
terraform apply -auto-approve
Note the public IP output from Terraform.

2. Configure Node & Install Kubernetes (Ansible)
Installs K3s, configures kubeconfig permissions, and deploys Argo CD:

Bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yaml
Verify cluster status:

Bash
kubectl get nodes
3. Bootstrap GitOps (Argo CD App-of-Apps)
Deploy the root application to automatically synchronize all staging, production, and monitoring workloads:

Bash
kubectl apply -f [https://raw.githubusercontent.com/AazadD/gitops/main/root-app-of-apps.yaml](https://raw.githubusercontent.com/AazadD/gitops/main/root-app-of-apps.yaml)
Verify all applications are healthy:

Bash
kubectl get applications -n argocd
Verifying the Deployment
1. Application Ingress Endpoints
Bash
# Test Production Environment
curl -H "Host: production.app.local" http://<NODE_IP>/

# Test Staging Environment
curl -H "Host: staging.app.local" http://<NODE_IP>/
2. Argo CD Web UI
Bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
URL: https://localhost:8080

Username: admin

Password:

Bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
3. Observability Dashboard (Grafana, Prometheus & Loki)
Bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
URL: http://localhost:3000

Username: admin

Password: admin

Pod Logs (Loki): In Grafana Explore, select Loki and query {namespace="production"}.

Metrics (Prometheus): Open the Kubernetes / Compute Resources / Workload dashboard.
