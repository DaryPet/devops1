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
Create S3 bucket for Terraform state and DynamoDB.

### vpc
Create VPC, Internet Gateway and Route Tables.

### ecr
Create ECR for Docker.

## Run
```bash
terraform init
terraform plan
terraform apply
terraform destroy
```