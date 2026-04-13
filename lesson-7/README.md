# Lesson 5 - Terraform AWS Infrastructure

## Project description
Terraform-structure on AWS.

## Project structure
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── README.md
└── modules/
├── s3-backend/
├── vpc/
└── ecr/

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

## Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.0
- AWS account with permissions for S3, DynamoDB, EC2, ECR


## Run
```bash
terraform init
terraform plan
terraform apply
terraform destroy
```