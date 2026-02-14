# 🚀 Cloud-Native DevOps Platform on AWS EKS – Tetris Application

##  Project Overview
This project is a full end-to-end cloud-native DevOps platform designed to deploy, manage, and monitor a containerized Tetris application on AWS EKS.  
It implements modern DevOps practices including CI/CD automation, Infrastructure as Code (IaC), GitOps deployment, observability, and centralized logging.

The platform integrates Terraform, Ansible, Jenkins, Kubernetes, ArgoCD, Prometheus, and the EFK stack to simulate a real-world production-grade environment.

---

##  High-Level Architecture
CI/CD Pipeline → Containerization → AWS EKS → GitOps (ArgoCD) → Monitoring & Logging

- Jenkins handles CI/CD automation
- Docker for containerization
- Terraform provisions AWS infrastructure (EKS)
- Ansible for configuration management
- ArgoCD for GitOps-based deployment
- Prometheus & Grafana for monitoring
- EFK Stack for centralized logging

---

##  Repository Structure
This repository is organized as a mono-repo that contains all platform components:


---

##  Detailed Module Documentation
Each folder contains its own detailed README with implementation steps and configurations:

-  Application & Kubernetes Manifests  
  → [`Application_Repo/README.md`](./argocd-k8s/README.md)

-  CI/CD Pipelines (Jenkins, Docker)  
  → [` Frontend pipeline/README.md`](./pipeline/frontend/README.md)
  → [`Backend pipeline/README.md`](./pipeline/backend/README.md)

-  Infrastructure as Code (Terraform + Ansible + AWS EKS)  
  → [`infra/README.md`](./aws-infra/README.md)

-  Monitoring & Observability (Prometheus Stack)  
  → [`monitoring-with-helm/README.md`](./monitoring/README.md)

-  Logging Stack (EFK – Elasticsearch, Filebeat, Kibana)  
  → [`efk-with-helm/README.md`](./efk-with-helm/README.md)

---

##  DevOps & Cloud Stack
- AWS EKS (Kubernetes)
- Terraform (Infrastructure Provisioning)
- Ansible (Configuration Management)
- Jenkins (CI/CD Automation)
- Docker (Containerization)
- ArgoCD (GitOps Deployment)
- Prometheus & Grafana (Monitoring)
- EFK Stack (Centralized Logging)
- Helm (Package Management)

---

##  CI/CD & GitOps Workflow
1. Code is pushed to the repository
2. Jenkins pipeline builds and tests the application
3. Docker images are built and pushed to registry
4. ArgoCD detects manifest changes (GitOps)
5. Application is deployed automatically to AWS EKS
6. Monitoring and logging track system performance and health

---

##  Security Considerations
- Secrets are managed using Ansible Vault
- Sensitive credentials are not exposed in plain text
- Infrastructure variables are isolated from public configs
- code and packages security check throug jenkins pipeline 

---

##  Key Features
- End-to-end CI/CD automation
- GitOps-based deployment with ArgoCD
- Infrastructure as Code using Terraform & Ansible
- Full observability (Monitoring + Logging)
- Production-style cloud-native architecture on AWS EKS

---

## Author
Developed as part of NTI Cloud & DevOps Training Program
Focused on real-world DevOps, Kubernetes, and Cloud-native practices.
Group project :
- shymaa saeed
- Merna Eltahawy
- Lina Mohamed
- Ashgan Adel  
