# 🎮 Application_Repo
   Tetris Kubernetes Deployment with ArgoCD

 🚀 Welcome to the Tetris Kubernetes Deployment repository!
    This project demonstrates how to deploy a full-stack Tetris application on Kubernetes using best practices such as Deployments, Services, ConfigMaps, Redis, and ArgoCD for GitOps-based continuous deployment.
    Any change pushed to this repository is automatically synchronized to the Kubernetes cluster using ArgoCD.

# 📌 Table of Contents

1. 🧠 Project Overview

2. 🧱 Architecture Components

3. 🗂️ Repository Structure

4. ☸️ Kubernetes Resources

   - Backend
   - Frontend
   - Redis

6- 🚀 Deployment Steps

7- 🔐 Important Notes


# 🧠 Project Overview

 This repository contains Kubernetes manifests for deploying:

- 🎨 **Frontend**: React-based Tetris UI

- 🧠 **Backend**: Node.js API for game logic

- 🗄️ **Redis**: In-memory datastore for game state


# 🧱 Architecture Components
```text
        User
         │
         ▼
        Frontend Service (NodePort / ClusterIP)
         │
         ▼
        Backend Service
         │
         ▼
        Redis
```

- Frontend communicates with Backend via internal Kubernetes Service

- Backend stores game state in Redis

- ArgoCD watches GitHub and syncs changes automatically

# 🗂️ Repository Structure

```text
            ├── k8s_files/
      │   ├── backend-deployment.yaml
      │   ├── backend-service.yaml
      │   ├── frontend-deployment.yaml
      │   ├── frontend-service.yaml
      │   ├── redis-deployment.yaml
      │   └── redis-service.yaml

```
# ☸️ Kubernetes Resources

1- **🧠 Backend Deployment**

    🐳 Image:
    101561167685.dkr.ecr.us-east-1.amazonaws.com/tetris-backend:13
    
    📦 Replicas: 3
    
    🔌 Container Port: 4000
    
    ⚙️ Configuration:
    Loaded from backend-config ConfigMap
    
    ❤️ Readiness Probe:
    TCP check on port 4000


2- **🎨 Frontend Deployment**

    🐳 Image:
    101561167685.dkr.ecr.us-east-1.amazonaws.com/tetris-frontend:7
    
    📦 Replicas: 3
    
    🌐 Container Port: 80
    
    ⚙️ Configuration:
    Loaded from frontend-config ConfigMap
    
    ❤️ Readiness Probe:
    HTTP GET / on port 80

3- **🗄️ Redis Deployment**

    🐳 Image: redis:7.0
    
    📦 Replicas: 1
    
    🔌 Port: 6379
    
    ❤️ Readiness Probe:
    TCP check on port 6379

# 🚀 Deployment Steps

**1️⃣ Clone the repository**
```sh
git clone https://github.com/tetris-app1/Application_Repo.git
cd Application_Repo
```

**2️⃣ (Optional) Manual Kubernetes Deployment**
```sh
kubectl apply -f k8s_files/
```

**3️⃣ Deploy using ArgoCD (Recommended)**
```sh
kubectl apply -f argocd/tetris-app.yaml
```

**4️⃣ Verify Deployment**
```sh
kubectl get pods
kubectl get svc
```

# 🔐 Important Notes

1- ⚠️ ECR Access
    Ensure your Kubernetes cluster can pull images from Amazon ECR:
      
   - Configure imagePullSecrets
   
   - Or use IAM Roles for Service Accounts (IRSA) on EKS


2- ⚠️ ConfigMaps
    Make sure these ConfigMaps exist before deployment:
    
   - backend-config

   - frontend-config

3- ⚠️ Repository URL
    If you fork or rename the repo, update:
```sh
        repoURL: <your-new-repo>
```
