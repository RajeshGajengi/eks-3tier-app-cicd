# Scalable CI/CD Pipeline for Dockerized 3-Tier Application on AWS EKS

This project demonstrates the deployment of a 3-tier application using Kubernetes EKS, Terraform, Docker, and Jenkins. The infrastructure (EKS cluster) is provisioned automatically using a Jenkins pipeline with Terraform, while the application (backend, frontend, and database) is deployed on Kubernetes. Docker images for the backend and frontend are built and pushed to Docker Hub, and the application is deployed in Kubernetes using Helm charts and Kubernetes YAML configurations.

## Overview
The project involves the following components:
   • Infrastructure: Kubernetes EKS Cluster created using Terraform.
   • Backend: Java Spring Boot application built using Maven and containerized with Docker.
   • Frontend: React-based web application built using Node.js and npm, also containerized with Docker.
   • CI/CD Pipeline: Jenkins automates the process of building Docker images, deploying them to EKS, and managing infrastructure.
   • Database: The application is configured to connect to a MariaDB instance hosted on AWS RDS.
The CI/CD pipeline automates the process of:
   1. Provisioning the infrastructure (EKS cluster) using Terraform.
   2. Building and pushing Docker images for the backend and frontend.
   3. Deploying the application to Kubernetes EKS.


   ## Project Structure
   eks-3tier-app-cicd P/
│── app/                          # Contains the source code for the frontend and backend.
│   ├── frontend/                 # React application (Node.js with npm).
│   │   └── Dockerfile            # Configuration for building the frontend Docker image.
│   ├── backend/                  # Spring Boot application (Java with Maven).
│   │   └── Dockerfile            # Configuration for building the backend Docker image.
│
│── k8s/                          # Kubernetes manifests
│   ├── frontend-deployment.yaml  # Deployment configuration for the frontend.
│   ├── frontend-service.yaml     # Service configuration for the frontend.
│   ├── backend-deployment.yaml   # Deployment configuration for the backend.
│   ├── backend-service.yaml      # Service configuration for the backend.
│   ├── db-deployment.yaml        # Optional configuration for the MariaDB database.
│   ├── db-service.yaml           # Optional service configuration for the MariaDB database.
│   ├── ingress.yaml              # Ingress controller configuration for routing traffic to the frontend and backend.
│   └── secret.yaml               Kubernetes Secrets to securely store database credentials.
|
├── jenkins/
│   ├── app.Jenkinsfile
│   └── infra.Jenkinsfile
|── Terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
│── docs/
│   ├── architecture.png
│   └── flow.
│   ├── frontend.png
│   └── backend.png
│   ├── database-result.png
│   └── k8s-results.png
├── installation _script.sh
│
│── README.md


## Architecture

## Tech Stack
- **Frontend**: React, Vite, Node.js, and npm — Chosen for building a fast and scalable UI.
- **Backend**: Java, Spring Boot, and Maven — Ideal for developing REST APIs with solid performance.
- **Database**: MariaDB on AWS RDS — A reliable relational database service with automatic scaling and backups.
- **CI/CD**: Jenkins, Terraform — For automating the build and deployment pipelines, and provisioning infrastructure.
- **Containerization**: Docker — Ensures consistency and portability across environments.
- **Cloud**: AWS (EKS, RDS, VPC, IAM) — Provides scalable cloud infrastructure and services.
- **Orchestration**: Kubernetes (EKS) — Manages containerized applications and ensures high availability.




## Environment Variables

| Variable                    | Used In   | Description                              |
|----------------------------|-----------|------------------------------------------|
| SPRING_DATASOURCE_URL      | Backend   | JDBC URL for MariaDB                     |
| SPRING_DATASOURCE_USERNAME | Backend   | DB username                              |
| SPRING_DATASOURCE_PASSWORD | Backend   | DB password                              |
| VITE_API_URL               | Frontend  | URL to access backend API                |


## WOrkflow: 
Workflow:

- **Clone the repository**: Start by cloning the project to your local machine.

- **Set up the database**: Follow the database setup guide
 to create and configure the MariaDB database.

- **Install necessary tools**: Refer to the installation guide
 for the tools required (e.g., Docker, Terraform, Jenkins, etc.).

- **Configure Jenkins**: Follow the Jenkins setup guide
 to set up Jenkins credentials and build pipelines for both Terraform and the application.

- **Set up EKS using Terraform**: Check out the Terraform configuration guide
 to modify AWS region, cluster, and node settings.

- **Configure Kubernetes Manifests**: Review the Kubernetes setup guide
 to modify Docker image names and configure database credentials via Kubernetes Secrets.


**To verify that the deployment is successful, ensure that**:

- The application is accessible via the configured Ingress.

- All pods in EKS are running successfully (kubectl get pods).

- Database connections are functioning as expected.

## Conclusion
This project demonstrates an automated CI/CD pipeline for deploying a 3-tier application on AWS EKS. By using Jenkins, Terraform, Docker, and Kubernetes, we achieve:

- Fully automated CI/CD pipeline
- Infrastructure as Code using Terraform
- Containerized deployments with Docker
- Scalable and resilient architecture using Kubernetes
- Secure database integration with AWS RDS