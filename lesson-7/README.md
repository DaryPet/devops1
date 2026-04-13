# Lesson 5 - Terraform AWS Infrastructure

## Project description
Terraform-structure on AWS.

## Project structure
lesson-7/
├── main.tf
├── backend.tf
├── outputs.tf
├── README.md
└── modules/
├── s3-backend/
├── vpc/
└── ecr/
└── eks/
└── charts/
└── django-app/
├── templates/
│ ├── deployment.yaml
│ ├── service.yaml
│ ├── configmap.yaml
│ └── hpa.yaml
├── Chart.yaml
└── values.yaml


## Modules

### s3-backend
- Creates S3 bucket for Terraform state with versioning enabled
- Creates DynamoDB table for state locking
- Prevents accidental bucket deletion

### vpc
- Creates VPC with configurable CIDR block
- Creates 3 public and 3 private subnets
- Internet Gateway for public subnets
- NAT Gateway for private subnets (internet access)
- Route tables and associations

### ecr
- Creates ECR repository for Docker images
- Enables scan on push for vulnerability scanning
- Outputs repository URL

## Components

### 1. EKS Cluster
- Kubernetes cluster created via Terraform
- Node group with t3.micro instances
- Autoscaling: 2-6 nodes based on CPU >70%

### 2. ECR Repository
- Stores Django Docker image
- Image built from lesson-4-docker

### 3. Helm Chart
- **Deployment**: Django app with ConfigMap via envFrom
- **Service**: LoadBalancer for external access
- **HPA**: 2-6 replicas, target CPU 70%
- **ConfigMap**: Environment variables from topic 4

## Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.0
- AWS account with permissions for S3, DynamoDB, EC2, ECR
- kubectl
- Helm >= 3.0
- Docker


## Run
```bash
terraform init
terraform plan
terraform apply
terraform destroy
```


# Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name django-cluster

# Deploy Helm chart
helm install django-app ./charts/django-app

# Check resources
kubectl get pods
kubectl get svc
kubectl get hpa
kubectl get configmap
