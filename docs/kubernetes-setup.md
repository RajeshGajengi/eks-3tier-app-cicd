# ☸️ Kubernetes Setup (EKS Deployment)

Kubernetes manages deployment of **frontend**, **backend**, and **Ingress**.


## Prerequisites
Ensure the following are set up:
- `kubectl` is installed and configured
- **AWS CLI** is installed with valid credentials
- An **EKS cluster** is already created
- **NGINX Ingress Controller** is installed (see below)


## 📁 Kubernetes Directory Structure
Your k8s/ folder should look like this:
```
k8s/
├── backend-deployment.yml          
├── backend-service.yml     
├── frontend-deployment.yml  
├── frontend-service.yml  
├── secrets.yml 
├── ingress.yml      
```

📦 Deployment Files Overview

- **backend-deployment.yml** – Deployment spec for the backend app
- **backend-service.yml** – Service to expose backend pods
- **frontend-deployment.yml** – Deployment spec for the frontend app
- **frontend-service.yml** – Service to expose frontend pods
- **secrets.yml** – Kubernetes Secrets for environment/config
- **ingress.yml** – Ingress rules for external access


## 🚀 Install NGINX Ingress Controller
Before applying the ingress configuration, ensure the NGINX ingress controller is installed:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

```
> ⚠️ Wait a few moments for the ingress controller pods and service to become active before applying your own ingress rules.

You can verify it using:
```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

## ⚙️ Manual Deployment Steps (Also included in CI/CD pipeline)
Although these are automated in the pipeline, here are the manual steps for reference or local testing.

1. **Configure `kubectl` for EKS**
```bash
aws eks update-kubeconfig --region us-east-1 --name mycluster
```

2. **Apply Secrets**
Add database credentials in secret form, like username, password and database url. (here i only used secrets for username and password, for database URL directly pasted in backend deployment file.)
```bash
kubectl apply -f k8s/secrets.yml
```

3. **Deploy Backend & Frontend**
```bash
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/frontend-deployment.yml

kubectl apply -f k8s/frontend-deployment.yml
kubectl apply -f k8s/frontend-service.yml
```

4. **Setup Ingress**
Make sure the ingress controller is running, then apply your ingress config:
```bash
kubectl apply -f k8s/ingress.yml
```

## Verification
Use the following commands to verify the deployment status:
```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```



<!-- ## Best Practices

- Use Helm charts for templated and repeatable deployments

- Store sensitive data securely using Kubernetes Secrets or AWS Secrets Manager.

- Implement Horizontal Pod Autoscaler (HPA) to handle traffic spikes.

- Set up PodDisruptionBudgets to ensure high availability during maintenance or updates. -->