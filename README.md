# DevOps Infrastructure & GitOps Setup Guide

This repository contains the Terraform infrastructure, Ansible automation, Helm charts, and CI/CD workflow specifications for deploying the microservice application and observability stack via Argo CD.

---

## 1. Architecture & Repositories

- **Application Repo:** `https://github.com/AazadD/devops-app` (Node.js microservice + GitHub Actions CI/CD)
- **Infrastructure Repo:** `https://github.com/AazadD/devops-infra` (Terraform, Ansible, Helm chart)
- **GitOps Repo:** `https://github.com/AazadD/gitops` (Argo CD App-of-Apps, workloads, monitoring stack)

---

## 2. Prerequisites & Tool Installation

Ensure you have an Ubuntu 22.04 LTS system (WSL2, local VM, or cloud EC2 instance). 

Install the required control tools:
```bash
sudo apt update && sudo apt install -y git curl ansible
(Optional for Cloud IaaS provisioning: Terraform >= 1.5.0)

3. Application CI/CD Pipeline (GitHub Actions)
Located at .github/workflows/ci-cd.yaml in the Application Repository, the automated pipeline handles:

Branch & Environment Matrix
Git Branch	Target Environment	Image Tag Format	Target GitOps Manifest
staging or develop	Staging	staging-<commit-sha>	apps/workloads/app-staging.yaml
main or prod	Production	production-<commit-sha>	apps/workloads/app-production.yaml
Pipeline Flow
Branch Detection: Selects the corresponding GitHub Environment (staging vs production) using unified secret names (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, GITOPS_PAT).

Build & Push: Builds the Docker container image and pushes it to Docker Hub (faazad/devops-app:<tag>).

Automated GitOps Sync: Clones https://github.com/AazadD/gitops, updates the target environment manifest with the new image tag, commits, and pushes to trigger Argo CD reconciliation.

4. Setup & Execution Steps
Step 1: Provision Infrastructure (Terraform - Optional if using existing host)
Bash
cd terraform
terraform init
terraform apply -auto-approve
Note the public IP address from the Terraform output.

Step 2: Configure Node & Install Kubernetes (Ansible)
Installs K3s, configures kubeconfig permissions, and deploys Argo CD:

Bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yaml
Verify cluster status:

Bash
kubectl get nodes
Step 3: Bootstrap GitOps (Argo CD App-of-Apps)
Deploy the root application to synchronize all environments and the observability stack:

Bash
kubectl apply -f [https://raw.githubusercontent.com/AazadD/gitops/main/root-app-of-apps.yaml](https://raw.githubusercontent.com/AazadD/gitops/main/root-app-of-apps.yaml)
Verify application status:

Bash
kubectl get applications -n argocd
5. Verifying the Deployment
1. Application Ingress Endpoints
Bash
# Test Production Environment (use 127.0.0.1 for local/WSL, or <NODE_IP> for cloud EC2)
curl -H "Host: production.app.local" [http://127.0.0.1/](http://127.0.0.1/)

# Test Staging Environment
curl -H "Host: staging.app.local" [http://127.0.0.1/](http://127.0.0.1/)
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

Pod Logs (Loki): In Grafana Explore, select Loki and run {namespace="production"}.

Metrics (Prometheus): Navigate to Dashboards → Kubernetes / Compute Resources / Workload.
