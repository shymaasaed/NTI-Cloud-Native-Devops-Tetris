# 📊 Monitoring Stack Deployment using Helm (Prometheus, Grafana, Alertmanager)

## 📌 Overview
This documentation describes the steps followed to deploy a complete **Monitoring Stack** using **Helm**, including:

- Prometheus
- Grafana
- Alertmanager
- Prometheus Operator
- Exporters (kube-state-metrics, node exporters)

The setup was first tested locally, then deployed successfully on an **AWS EKS cluster** with full observability over cluster, nodes, pods, and Jenkins metrics.

---

## 🛠️ Tools & Technologies
- Kubernetes (Minikube → AWS EKS)
- Helm
- Prometheus
- Grafana
- Alertmanager
- Jenkins
- AWS EKS

---

## 📂 Helm Chart Structure
The monitoring stack was deployed using a Helm chart with the following structure:

monitoring-with-helm/
├── charts/
├── templates/
│ ├── alertmanager/
│ ├── exporters/
│ ├── grafana/
│ ├── prometheus/
│ └── prometheus-operator/
├── Chart.yaml
├── Chart.lock
├── values.yaml
├── values-custom.yaml
├── alertmanager.yaml
├── alert.json
├── README.md


---

## 🚀 Step 1: Install Monitoring Stack using Helm
The monitoring stack was installed using Helm which automatically deployed:

- Prometheus Operator
- Prometheus
- Grafana
- Alertmanager
- Exporters

`helm install monitoring-stack ./ -n monitoring --create-namespace`
## ⚙️ Step 2: Customize Configuration (values-custom.yaml)
To optimize for low-resource environments, the following custom configuration was applied.

🔹 Global Configuration
```yaml
global:
  storageClass: "standard"

📊 Grafana Configuration
grafana:
  enabled: true
  adminUser: admin
  adminPassword: admin123

  service:
    type: LoadBalancer
    nodePort: 32000

  persistence:
    enabled: false

  resources:
    requests:
      memory: 128Mi
      cpu: 50m
    limits:
      memory: 256Mi
      cpu: 200m

  smtp:
    enabled: true
    host: smtp.gmail.com:587
    user: mernathawy211@gmail.com
    password: "rzqh dcqp wcpy lvny"
    from_address: mernathawy211@gmail.com
    skip_verify: false
```

### ✔️ Grafana dashboards were tested locally and verified to update dynamically with metrics changes.

📈 Prometheus Configuration
```yaml
prometheus:
  enabled: true

  service:
    type: LoadBalancer
    nodePort: 30090

  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
    storageSpec:
      emptyDir: {}
    retention: 6h

    resources:
      requests:
        memory: 256Mi
        cpu: 100m
      limits:
        memory: 512Mi
        cpu: 300m
```
### 🔗 External Jenkins Metrics Scraping

Prometheus was configured to scrape Jenkins metrics:
```yaml

additionalScrapeConfigs:
  - job_name: "jenkins-external"
    metrics_path: /prometheus
    scrape_interval: 30s
    static_configs:
      - targets:
          - 13.218.126.254:8080

🚨 Prometheus Alert Rules
Jenkins Failure Alert
- alert: JenkinsBuildFailed
  expr: jenkins_runs_failure_total > 0
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Jenkins Build Failed"
    description: "Jenkins build failed."

Test Alert (Always Firing)
- alert: AlwaysFiring
  expr: vector(1)
  for: 10s
  labels:
    severity: warning
  annotations:
    summary: "🔥 Test Alert"
    description: "This alert always fires for testing."
```
### 📣 Alertmanager Configuration

Alertmanager was enabled and linked to a custom secret:
```yaml
alertmanager:
  enabled: true
  alertmanagerSpec:
    configSecret: alertmanager-custom
```

This configuration was used to route alerts and test email notifications.

## 🔍 Step 3: Local Testing

Before deploying to EKS, the setup was tested locally:

1-Verified Prometheus targets were UP
2-Grafana dashboards updated in real-time
3-Jenkins jobs triggered metric changes
4-Alerts fired correctly


<img width="1860" height="767" alt="image" src="https://github.com/user-attachments/assets/e0041920-3304-4f9a-80e3-fe1b5889d536" />


<img width="1920" height="1028" alt="jenkins2" src="https://github.com/user-attachments/assets/b7859cf1-cf68-4361-9a25-7069a8643270" />

#### Multiple Jenkins dashboards were imported and validated

## ☁️ Step 4: Deploy to AWS EKS

After successful local testing, the same Helm chart and values were deployed to the EKS cluster.
``` bash
helm upgrade --install monitoring-stack ./ \
  -n monitoring \
  -f values-custom.yaml
```
## 📊 Step 5: Dashboards & Metrics

1-Grafana dashboards were created to monitor:
2-Kubernetes Cluster Metrics
3-Node Metrics
4-Pod Metrics
5-Jenkins Jobs (Success / Failure / Duration)
6-Resource Utilization (CPU, Memory)


<img width="1920" height="1020" alt="k1" src="https://github.com/user-attachments/assets/03b7fcb0-d926-4e4c-b0b9-268fbe599280" />

<img width="1920" height="1020" alt="k2" src="https://github.com/user-attachments/assets/5af8c6e2-b0fc-497a-832d-020635f962cd" />

<img width="1920" height="1020" alt="k3" src="https://github.com/user-attachments/assets/8e0b9fed-4670-4d00-9020-dcd6fee69314" />

<img width="1920" height="1020" alt="k4" src="https://github.com/user-attachments/assets/8261d7ea-bdf7-41b2-a312-87a83e375205" />

<img width="1920" height="1020" alt="k5" src="https://github.com/user-attachments/assets/8442ab19-00e1-4545-bb96-0544dd7d39e8" />

<img width="1920" height="1020" alt="k6" src="https://github.com/user-attachments/assets/9b0e63c0-81f1-44c7-90d7-3d49571b37d7" />


Cluster overview

Node metrics

Pod metrics



✅ Final Outcome

✔ Prometheus, Grafana, Alertmanager running on EKS
✔ Metrics collected from cluster, nodes, pods, and Jenkins
✔ Alerts firing correctly
✔ Grafana dashboards dynamically updated
✔ Email notifications configured and tested

# Conclusion

This monitoring stack provides full observability over the Kubernetes cluster and CI/CD pipelines, and is production-ready after being tested locally and deployed on AWS EKS.

✨ Author: Merna Mohamed Eltahawy

