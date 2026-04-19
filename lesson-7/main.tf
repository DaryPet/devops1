provider "aws" {
  region = "us-east-1"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "darya-petrenko-terraform-state"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "lesson-5-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source = "./modules/eks"
  cluster_name       = "django-cluster"
  kubernetes_version = "1.30"
  subnet_ids         = module.vpc.private_subnet_ids
  node_group_name    = "django-nodes"
  instance_type      = "t3.micro"
  desired_size       = 3
  max_size           = 3
  min_size           = 1
}

module "jenkins" {
  source = "./modules/jenkins"

  cluster_name       = module.eks.cluster_name
  admin_password     = var.jenkins_admin_password
  ecr_repository_url = module.ecr.ecr_repository_url
  git_repo_url       = var.git_repo_url
}

module "argo_cd" {
  source = "./modules/argo_cd"

  cluster_name    = module.eks.cluster_name
  git_repo_url    = var.git_repo_url
  git_repo_branch = "lesson-8-9"
  git_token       = var.git_token
  app_namespace   = "default"
}

