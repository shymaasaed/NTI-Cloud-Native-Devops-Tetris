# EFK Stack Deployment Documentation

## Overview

This document describes the end-to-end setup of the **EFK stack (Elasticsearch, Fluent Bit/Filebeat, Kibana)** starting from scratch. It covers Helm installation, configuration customization, authentication setup between components, health verification, and finally deploying the stack using **Argo CD** on an **Amazon EKS** cluster.

---

## Architecture

* **Elasticsearch**: Log storage and search engine
* **Kibana**: Visualization and log exploration
* **Filebeat**: Log shipper running as DaemonSet on all nodes
* **Helm**: Package manager for Kubernetes
* **Argo CD**: GitOps-based continuous deployment
* **EKS**: Kubernetes cluster

---

## Prerequisites

* Kubernetes cluster (EKS)
* kubectl configured
* Helm v3 installed
* Argo CD installed on the cluster
* Access to Elastic Helm repository

---

## Step 1: Install Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

## Step 2: Add Elastic Helm Repository

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

---

## Step 3: Create Namespace

```bash
kubectl create namespace efk
```

---

## Step 4: Elasticsearch Deployment

### Configuration (values-no-security.yaml)

Key configurations applied:

* Disabled security (for learning/testing environment)
* Set replicas
* Tuned resources
* Configured single cluster discovery

```yaml
replicas: 3

esJavaOpts: "-Xms1g -Xmx1g"

discovery.type: "zen"

resources:
  requests:
    cpu: "500m"
    memory: "2Gi"
  limits:
    cpu: "1"
    memory: "3Gi"
```

### Install Elasticsearch

```bash
helm install elasticsearch elastic/elasticsearch -n efk -f values-no-security.yaml
```

### Verify Elasticsearch

```bash
kubectl get pods -n efk
kubectl get svc -n efk
```

All pods should be in **Running** state.

---

## Step 5: Kibana Deployment

### Kibana Configuration

* Connected to Elasticsearch service
* Authentication disabled (matching Elasticsearch config)

```yaml
elasticsearchHosts: "http://elasticsearch-master:9200"
```

### Install Kibana

```bash
helm install kibana elastic/kibana -n efk -f values-no-security.yaml
```

### Verify Kibana

```bash
kubectl get pods -n efk -l app=kibana
```

---

## Step 6: Filebeat Deployment

### Filebeat Architecture

* Deployed as **DaemonSet**
* Runs on every node
* Collects container and system logs
* Sends logs to Elasticsearch

### Filebeat Configuration

Key points:

* Autodiscover enabled
* Output set to Elasticsearch service

```yaml
output.elasticsearch:
  hosts: ["http://elasticsearch-master:9200"]

filebeat.autodiscover:
  providers:
    - type: kubernetes
      node: ${NODE_NAME}
      hints.enabled: true
```

### Deploy Filebeat

```bash
kubectl apply -f filebeat.yaml
```

### Verify Filebeat

```bash
kubectl get pods -n efk -l app=filebeat
```

Filebeat pods should be **Running on all nodes**.

---

## Step 7: Health Checks

### Elasticsearch Health

```bash
kubectl exec -it elasticsearch-master-0 -n efk -- curl http://localhost:9200/_cluster/health?pretty
```

Expected status:

```json
"status" : "green"
```

### Kibana Access

```bash
kubectl port-forward svc/kibana-kibana 5601:5601 -n efk
```

Access via browser:

```
http://localhost:5601
```

### Logs Visibility

* Logs visible in Kibana
* Indices created successfully
* Filebeat index patterns detected

---

## Step 8: GitOps Deployment with Argo CD

### Repository Structure

```
argocd/
 └── efk/
     ├── elasticsearch/
     ├── kibana/
     └── filebeat/
```

### Argo CD Application Example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: efk-stack
spec:
  project: default
  source:
    repoURL: https://github.com/your-repo/efk
    targetRevision: main
    path: argocd/efk
  destination:
    server: https://kubernetes.default.svc
    namespace: efk
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### Sync Status

<img width="1920" height="1020" alt="Screenshot 2026-02-05 032752" src="https://github.com/user-attachments/assets/e432ef7d-693f-4011-bc68-69fef15c1089" />

<img width="1920" height="1020" alt="Screenshot 2026-02-05 032824" src="https://github.com/user-attachments/assets/638e334f-ca2f-44e2-92cb-489cc11ad68f" />


* Applications synced successfully
* Pods recreated automatically
* No manual intervention needed

---

## Final Result

* Elasticsearch cluster healthy
* Kibana connected and accessible
* Filebeat running on all nodes
* Logs flowing correctly
* GitOps deployment via Argo CD

---

## Conclusion

This setup demonstrates a full production-style EFK deployment using Helm and Argo CD on EKS, following DevOps and GitOps best practices.
