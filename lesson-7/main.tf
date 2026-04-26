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
  source             = "./modules/eks"
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

# ─────────────────────────────────────────────
# RDS Module
# Switching between Aurora and regular RDS
# is controlled by use_aurora variable.
#
# use_aurora = false → single aws_db_instance (PostgreSQL)
# use_aurora = true  → Aurora Cluster + writer instance
# ─────────────────────────────────────────────
module "rds" {
  source = "./modules/rds"

  # --- Main switch ---
  use_aurora = false

  # --- DB identity ---
  identifier = "darya-petrenko-db"
  db_name    = "appdb"

  # --- Engine ---
  # For regular RDS:    engine = "postgres",          engine_version = "15.12",   family = "postgres15"
  # For regular RDS:    engine = "mysql",             engine_version = "8.0",    family = "mysql8.0"
  # For Aurora Postgres: engine = "aurora-postgresql", engine_version = "15.12",   family = "aurora-postgresql15"
  # For Aurora MySQL:    engine = "aurora-mysql",      engine_version = "8.0.mysql_aurora.3.04.0", family = "aurora-mysql8.0"
  engine         = "postgres"
  engine_version = "15"
  family         = "postgres15"

  # --- Instance ---
  instance_class    = "db.t3.micro"
  allocated_storage = 20  # ignored for Aurora

  # --- Credentials (from variables) ---
  db_username = var.db_username
  db_password = var.db_password

  # --- High availability (RDS only) ---
  multi_az = false

  # --- Networking (from VPC module) ---
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  vpc_cidr_block = "10.0.0.0/16"

  # --- Lifecycle ---
  skip_final_snapshot = true   # set false in production!
  deletion_protection = false  # set true in production!

  tags = {
    Project   = "devops1"
    ManagedBy = "terraform"
    Lesson    = "db-module"
  }
}
