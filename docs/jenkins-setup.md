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
 - **database_url**: `jdbc:mariadb://<RDS_Endpoint>:3306/student_db`
 - **database_user**: Database username for the MariaDB instance.
 - **database_password**: Database password for the MariaDB instance.
 - **backend_api**: Backend API URL, e.g., `http://<backend_IP>:8081/api`.


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
1. **Terraform Init**
    - Initializes the Terraform working directory by downloading the required providers and modules.
2. **Terraform Plan**
    - Previews the changes Terraform will make to the infrastructure, allowing you to review before applying.
3. **Terraform Apply**  
    - Applies the changes to create the EKS cluster and necessary IAM roles using the default VPC.


## Application Pipeline
The application pipeline automates the process of building, pushing, and deploying the backend and frontend services to Kubernetes.
### Pipeline Stages
1. **Clone Repository**:
    -Clones the GitHub repository containing the source code for the backend and frontend.
2. **Docker Login**:
    - Logs into Docker Hub using the credentials stored in Jenkins.
3. **Build Backend Image and Push to Docker Hub**:
    - Builds the backend Docker image from the backend/ directory and pushes it to Docker Hub.
4. **Build Frontend Image and Push to Docker Hub**:
    - Builds the frontend Docker image from the frontend/ directory and pushes it to Docker Hub.
5. **Kubernetes Configuration**:
    - Configures kubectl to interact with the EKS cluster.
6. **Ingress Controller Download**:
    - Installs the NGINX Ingress Controller in the Kubernetes cluster.
7. **Kubernetes Deployment**:
    - Deploys the backend and frontend services to Kubernetes using kubectl apply with the YAML configuration files.
8. **Verify**:
    - Verifies the deployment by checking the status of Pods, Services, and Ingress.
Application Pipeline Script

## SonarQube Integration (Optional)

- Install SonarQube Scanner plugin

- Add stage('SonarQube Analysis') before Docker build stage

- Ensures code quality checks

## Best Practices

- Use Jenkins agents (not master) for builds

- Store credentials in Jenkins, not in code

- Trigger pipelines via GitHub webhooks
> 💡 To trigger pipelines automatically on code push, set up GitHub Webhooks under your repo's **Settings → Webhooks**, and point to your Jenkins URL `/github-webhook/`.


