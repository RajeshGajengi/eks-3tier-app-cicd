# Scalable CI/CD Pipeline for Dockerized 3-Tier Application on AWS EKS with Terraform and Jenkins


This project demonstrates the deployment of a 3-tier application using Kubernetes EKS, Terraform, Docker, and Jenkins. The infrastructure (EKS cluster) is provisioned automatically using a Jenkins pipeline with Terraform, while the application (backend, frontend, and database) is deployed on Kubernetes. Docker images for the backend and frontend are built and pushed to Docker Hub, and the application is deployed in Kubernetes using Helm charts and Kubernetes YAML configurations.

## Overview

The project involves the following components:

- **Infrastructure**: Kubernetes EKS Cluster created using Terraform.

- **Backend**: Java Spring Boot application built using Maven and containerized with Docker.

- **Frontend**: React-based web application built using Node.js and npm, also containerized with Docker.

- **CI/CD Pipeline**: Jenkins automates the process of building Docker images, deploying them to EKS, and managing infrastructure.

- **Database**: The application is configured to connect to a MariaDB instance hosted on AWS RDS.

The CI/CD pipeline automates the process of:

1. Provisioning the infrastructure (EKS cluster) using Terraform.

2. Building and pushing Docker images for the backend and frontend.

3. Deploying the application to Kubernetes EKS.


## Project Structure


## Tech Stack

- Frontend: React, Vite, Node.js, npm

- Backend: Java, Spring Boot, Maven

- Database: MariaDB (AWS RDS)

- CI/CD: Jenkins, Terraform

- Containerization: Docker

- Cloud: AWS (EKS, RDS, VPC, IAM)

- Infrastructure as Code: Terraform

- Orchestration: Kubernetes (EKS)


## Prerequisites

Before starting the setup, ensure you have the following tools installed:

- **Jenkins**: For continuous integration and continuous deployment (CI/CD).

- **Docker**: To build and run backend and frontend applications as containers.

- **Terraform**: For provisioning and managing infrastructure (EKS cluster).

- **AWS CLI**: For interacting with AWS services.

- **Kubernetes CLI (kubectl)**: For interacting with the Kubernetes cluster.

- **Java (JDK)**: To build the backend service using Maven.

- **Node.js and npm**: For building the frontend service.

- **MariaDB Client**: For connecting to the MariaDB database hosted on AWS RDS.


## Database Setup (MariaDB on AWS RDS)
This project uses a MariaDB database hosted on AWS RDS.

#### Step 1: Create the RDS instance

1. Engine: MariaDB
2. Port: 3306
3. Public access: Yes (or configure a proper VPC + security group if running privately)
4. Database username: admin
5. Password: yourpassword

You can create the RDS instance via the AWS Console or use Terraform to provision it automatically.

#### Step 2: Connect to the RDS instance
Use the MariaDB client to connect to your RDS instance:
```bash
mysql -h <RDS_ENDPOINT> -u admin -p
```

#### Step 3: Create the database

Once connected, create the database:
```sql
CREATE DATABASE student_db;
```
Ensure the name matches the value in SPRING_DATASOURCE_URL.

#### Step 4: Grant access (optional)
If you're using a different database user than admin, grant it the necessary privileges:
```sql 
GRANT ALL PRIVILEGES ON student_db.* TO 'your_user'@'%' IDENTIFIED BY 'your_password';
FLUSH PRIVILEGES;
```
Ensure the RDS security group allows inbound access on port 3306 from the Jenkins/EC2 instance.

## Jenkins Setup and Configuration
### 1. Add Jenkins User to Docker Group
To allow Jenkins to interact with Docker, add the Jenkins user to the Docker group:
```bash
sudo usermod -aG docker jenkins
```
Restart Jenkins:
```bash
sudo systemctl restart jenkins
```
### 2. Configure Jenkins Credentials

In Jenkins, configure the following credentials under Manage Jenkins → Manage Credentials:

- **docker-cred**: Docker Hub username and password.
- **database_url**: `jdbc:mariadb://<RDS_Endpoint>:3306/student_db`
- **database_user**: Database username for the MariaDB instance.
- **database_password**: Database password for the MariaDB instance.
- **backend_api**: Backend API URL, e.g., `http://<backend_IP>:8081/api`.


## Application Pipeline

The application pipeline automates the process of building, pushing, and deploying the backend and frontend services to Kubernetes.

### Pipeline Stages

1. **Clone Repository**:
- Clones the GitHub repository containing the source code for the backend and frontend.

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

## Application Pipeline Script
```groovy
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/RajeshGajengi/EasyCRUD-K8s.git'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                }
            }
        }

        stage('Build Backend Image and Push to Docker Hub') {
            steps {
                sh '''
                    cd backend
                    docker build -t r25gajengi/easy_backend:v2 .
                    docker push r25gajengi/easy_backend:v2
                '''
            }
        }

        stage('Build Frontend Image and Push to Docker Hub') {
            steps {
                sh '''
                    cd frontend
                    docker build -t r25gajengi/easy_frontend:v2 .
                    docker push r25gajengi/easy_frontend:v2
                '''
            }
        }

        stage('Kubernetes Configure') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    sh 'aws eks update-kubeconfig --region ap-south-1 --name mycluster'
                }
            }
        }

        stage('Ingress Controller Download') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml'
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    sh '''
                    kubectl apply -f k8s/secrets.yml
                    kubectl apply -f k8s/backend-deployment.yml
                    kubectl apply -f k8s/backend-service.yml
                    kubectl apply -f k8s/frontend-deployment.yml
                    kubectl apply -f k8s/frontend-service.yml
                    kubectl apply -f k8s/ingress.yml
                    '''
                }
            }
        }

        stage('Verify') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    sh '''
                    kubectl get pods
                    kubectl get svc
                    kubectl get ingress
                    '''
                }
            }
        }
    }
}

```


## Terraform Pipeline

The Terraform pipeline is responsible for provisioning the EKS cluster using infrastructure as code. The pipeline stages are:

### Pipeline Stages

1. Git Clone:

Clones the GitHub repository containing the Terraform configuration files for EKS.

2. Terraform Init

Initializes the Terraform working directory by downloading the required providers and modules.

3. Terraform Plan

Previews the changes Terraform will make to the infrastructure, allowing you to review before applying.

4. Terraform Apply

Applies the changes to create the EKS cluster and necessary IAM roles using the default VPC.