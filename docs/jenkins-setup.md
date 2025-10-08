# ⚙️ Jenkins Setup and Configuration

Jenkins orchestrates both **infrastructure provisioning** and **application deployment**.


## Required Jenkins Plugins

Make sure the following plugins are installed:

- AWS Credentials Plugin
- Pipeline: AWS steps
- GitHub Integration Plugin
- SonarQube Scanner (if using SonarQube)
<!-- - Blue Ocean (optional for nicer UI)
- Docker Pipeline
- Kubernetes CLI Plugin (for `kubectl`) -->

## Add Jenkins User to Docker Group

To allow Jenkins to interact with Docker, add the Jenkins user to the Docker group:

```bash
sudo usermod -aG docker jenkins

```
Then restart Jenkins:

```bash
sudo systemctl restart jenkins

```

## Configure Jenkins Credentials
In Jenkins, add the following credentials under Manage Jenkins → Manage Credentials:

 - **docker-cred**: Docker Hub username and password.
 - **aws-cred**: AWS access key + secret key
 


## CI/CD Pipelines

- **Terraform Pipeline** → provisions EKS cluster

- **Application Pipeline** → builds, pushes Docker images & deploys to EKS

Both pipelines are defined in the `jenkins/` folder:
- [`app.Jenkinsfile`](../jenkins/app.Jenkinsfile) for application deployment 
- [`infra.Jenkinsfile`](../jenkins/infra.Jenkinsfile) for infrastructure provisioning



## Terraform Pipeline 
The Terraform pipeline is responsible for provisioning the EKS cluster using infrastructure as code. The pipeline stages are:
### Pipeline Stages 
1. **Clone repository** 
    - Terraform files from GitHub
1. **Terraform-Init**
    - Initializes the Terraform working directory by downloading the required providers and modules.
2. **Terraform-Plan**
    - Previews the changes Terraform will make to the infrastructure, allowing you to review before applying.
3. **Terraform-Apply**  
    - Applies the Terraform plan to provision infrastructure resources on AWS, including the EKS cluster and necessary IAM roles using the default VPC.


## Application Pipeline
The application pipeline automates the process of building, pushing, and deploying the backend and frontend services to Kubernetes.
### Pipeline Stages
1. **clone-repository**:
    - Clones the GitHub repository containing the source code for the backend and frontend.
2. **Docker Login**:
    - Logs into Docker Hub using the credentials stored in Jenkins.
3. **build-backend-image**:
    - Builds the backend Docker image from the `backend/` directory and pushes it to Docker Hub.
4. **build-frontend-image**:
    - Builds the frontend Docker image from the `frontend/` directory and pushes it to Docker Hub.
5. **configure-kubectl**:
    - Configures `kubectl` to interact with the AWS EKS cluster using `aws eks update-kubeconfig`.
6. **install-nginx-ingress**:
    - Installs the NGINX Ingress Controller in the Kubernetes cluster to enable external access to services.
7. **deploy-to-kubernetes**:
    - Applies Kubernetes manifests for secrets, backend, frontend, and ingress using `kubectl apply`.
8. **verify-deployment**:
    - Verifies that the application is running by checking the status of Pods, Services, and the Ingress resource.

## SonarQube Integration (Optional)

- Install SonarQube Scanner plugin

- Add stage('SonarQube Analysis') before Docker build stage

- Ensures code quality checks

## Best Practices

- Use Jenkins agents (not master) for builds

- Store credentials in Jenkins, not in code

- Trigger pipelines via GitHub webhooks
> 💡 To trigger pipelines automatically on code push, set up GitHub Webhooks under your repo's **Settings → Webhooks**, and point to your Jenkins URL `/github-webhook/`.


