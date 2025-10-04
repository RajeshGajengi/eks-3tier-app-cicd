# ▶️ Run Application Locally
This guide helps you set up and run the application locally using Terraform, Docker, and Kubernetes on an EKS cluster.

## Prerequisites
Ensure the following tools are installed on your machine:
- Java 17 and Maven (for backend — optional if using Docker))
- Node.js and npm (for frontend — optional if using Docker)
- MariaDB client (to connect to the database)
- Docker 
- kubectl
- AWS CLI
- Terraform

## 🧩 Step-by-Step Setup
### 🔹 Step 1: Clone the Repository 
```bash
git clone https://github.com/RajeshGajengi/crud-3tier-cicd-docker-pipeline.git
cd crud-3tier-cicd-docker-pipeline
```
### 🔹 Step 2: Create the Database
Follow the [database setup guide](./database-setup.md) to create an AWS-managed RDS MariaDB instance.
> Make sure to create a database named `student_db` within your RDS instance.

### 🔹 Step 3: Create EKS Cluster Using Terraform
Navigate to the Terraform directory and run the following commands:
```bash
cd terraform
terraform init
terraform plan
terraform apply --auto-approve
```
> This will create an EKS cluster along with the required node group.
### 🔹 Step 4: Build and Push Docker Images
**Backend**:
```bash
docker build -t <dockerhub-username>/backend:latest -f docker/backend.dockerfile ./app/backend
docker push <dockerhub-username>/backend:latest

```

**Frontend**:
```bash
docker build -t <dockerhub-username>/frontend:latest -f docker/frontend.Dockerfile ./app/frontend
docker push <dockerhub-username>/frontend:latest

```
### 🔹 Step 5: Configure Kubernetes and Deploy
#### Update Secrets:
Before applying, update k8s/secrets.yml with your database credentials, encoded in base64.

#### Update Deployment Manifests:
Make sure to update image names in:
    - `backend-deployment.yml`
    - `frontend-deployment.yml`

#### Apply Kubernetes Resources
```bash
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml
```


### 🔹 Step 6: Install NGINX Ingress Controller
Install the NGINX ingress controller (only once):
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```
Wait for the pods and service to be up in the `ingress-nginx` namespace:
```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```
Then apply your ingress configuration:
```bash
kubectl apply -f k8s/ingress.yml
```
### 🔹 Step 7: Verify Deployment
Run the following commands to verify that all resources are running properly:
```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```
> If using LoadBalancer service or Ingress, note the external IP address to access your frontend.

<!-- 
✅ Summary

Terraform provisions EKS and infrastructure

Docker builds and pushes application images

Kubernetes manifests deploy services, protected by secrets

NGINX Ingress exposes services externally -->