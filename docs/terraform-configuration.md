# 🌍 Terraform Setup for AWS EKS

Terraform is used to provision and manage the Kubernetes infrastructure on AWS, including the EKS cluster, IAM roles, and node groups.

## 📦 Prerequisites

Ensure the following tools are installed and configured:
- Terraform ≥ 1.3
- AWS CLI (configured with aws configure)
- Jenkins with AWS credentials added (aws-cred)


## 📁 Terraform Directory Structure
```
Terraform/
├── main.tf           # Main configuration: EKS cluster, IAM roles, node group
├── variables.tf      # Input variables: region, cluster name, etc.
├── outputs.tf        # Outputs: kubeconfig data, cluster name, etc.
```



## 🧪 Customize Your EKS Configuration

You can change AWS region, EKS cluster name, node group size,node count, etc. via the variables.tf file or by passing values in the CLI:
```bash
terraform apply -var="region=us-east-1" -var="cluster_name=dev-eks-cluster"
```


## 🔐 Jenkins Integration

Ensure you’ve added the following credentials in Jenkins:
- `aws-cred` — AWS Access Key ID & Secret Access Key
- Used in the `infra.Jenkinsfile` to authenticate and run Terraform from Jenkins



<!-- ✅ Recommended Best Practices

While not required for initial setup, following these will help you scale your Terraform usage safely:

✅ Use remote backend (S3 + DynamoDB) to store Terraform state and enable state locking

✅ Split Terraform code into modules (e.g., eks, vpc, rds) for reusability and clarity

✅ Use Terraform workspaces for environments like dev, staging, prod

✅ Enable logging and monitoring on EKS (CloudWatch, Container Insights)

✅ Add version constraints to Terraform providers 


# terraform.tfvars
region        = "us-east-1"
cluster_name  = "dev-eks-cluster"
node_count    = 2

-->


## Cluster Verifcation: 

After provisioning, use the kubeconfig output to connect:

```bash
aws eks update-kubeconfig --region <region> --name <cluster_name>
kubectl get nodes
```

Then proceed to deploy your application using the Kubernetes manifests or Helm charts.