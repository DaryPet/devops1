# Lesson 10 -DB Module

## Project description
Terraform-structure on AWS.

## Project structure
lesson-7/
├── main.tf
├── backend.tf
├── outputs.tf
├── variables.tf
├── README.md
└── modules/
    ├── s3-backend/
    ├── vpc/
    ├── ecr/
    ├── eks/
    ├── jenkins/
    └── argo_cd/
    └── monitoring/
└── charts/
    └── django-app/
        ├── templates/
        │   ├── deployment.yaml
        │   ├── service.yaml
        │   ├── configmap.yaml
        │   └── hpa.yaml
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

### eks
- Creates EKS cluster
- Node group with t3.micro instances
- EBS CSI driver for persistent volumes

### jenkins
- Installs Jenkins via Helm
- Kubernetes agent with Kaniko + Git
- Pipeline: build → push to ECR → update values.yaml → push to Git

### argo_cd
- Installs Argo CD via Helm
- Application tracks Helm chart from Git
- Auto-sync enabled

### rds
- Creates RDS instance (PostgreSQL / MySQL) or Aurora Cluster depending on `use_aurora`
- Creates DB Subnet Group in private subnets
- Creates Security Group with access only from within VPC
- Creates Parameter Group with `max_connections`, `log_statement`, `work_mem`

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

### 4. Jenkins CI
- Installed via Helm module
- Pipeline: builds image with Kaniko, pushes to ECR, updates tag in values.yaml, commits to Git

### 5. Argo CD
- Installed via Helm module
- Watches Helm chart repository
- Auto-syncs changes to Kubernetes cluster

### 6. RDS Database
- **use_aurora = false** → single `aws_db_instance` (PostgreSQL or MySQL)
- **use_aurora = true** → Aurora Cluster + writer instance
- Deployed in private subnets, not publicly accessible
- Storage encrypted, 7-day backup retention

### monitoring
- Installs Prometheus + Grafana via kube-prometheus-stack Helm chart
- Scrapes metrics from all namespaces
- Grafana dashboards enabled by default
- Alertmanager included

## Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.0
- AWS account with permissions for S3, DynamoDB, EC2, ECR
- kubectl
- Helm >= 3.0
- Docker
- GitHub token (for Argo CD)
- RDS credentials set in `terraform.tfvars` (`db_username`, `db_password`)


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

# Jenkins
`kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword`

`kubectl port-forward svc/jenkins -n jenkins 8080:8080`

# Grafana
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
# Open http://localhost:3000 (login: admin / admin123)

# Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
# Open http://localhost:9090

Open http://localhost:8080

# Argo CD

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
`kubectl port-forward svc/argocd-server -n argocd 8080:443`

Open https://localhost:8080 (login: admin, password from previous step)

## RDS Module

### Приклад використання

```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora = false

  identifier = "darya-petrenko-db"
  db_name    = "appdb"

  engine         = "postgres"
  engine_version = "15"
  family         = "postgres15"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_username = var.db_username
  db_password = var.db_password

  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  vpc_cidr_block = "10.0.0.0/16"

  skip_final_snapshot = true
  deletion_protection = false
}
```

### Опис змінних

| Змінна | Тип | Default | Опис |
|--------|-----|---------|------|
| `use_aurora` | `bool` | `false` | `true` = Aurora Cluster, `false` = звичайна RDS |
| `identifier` | `string` | `"darya-petrenko-db"` | Унікальне ім'я ресурсу в AWS |
| `engine` | `string` | `"postgres"` | Движок БД |
| `engine_version` | `string` | `"15.4"` | Версія движка |
| `family` | `string` | `"postgres15"` | Сімейство parameter group |
| `instance_class` | `string` | `"db.t3.micro"` | Клас інстансу |
| `allocated_storage` | `number` | `20` | Розмір диску в GB (тільки для RDS) |
| `db_name` | `string` | `"appdb"` | Назва бази даних |
| `db_username` | `string` | — | Логін (sensitive) |
| `db_password` | `string` | — | Пароль (sensitive) |
| `multi_az` | `bool` | `false` | Multi-AZ для RDS |
| `vpc_id` | `string` | — | ID VPC |
| `subnet_ids` | `list(string)` | — | Приватні підмережі |
| `vpc_cidr_block` | `string` | `"10.0.0.0/16"` | CIDR VPC |
| `skip_final_snapshot` | `bool` | `true` | Snapshot при destroy |
| `deletion_protection` | `bool` | `false` | Захист від видалення |

### Як змінити тип БД

**Перейти на Aurora:**
```hcl
use_aurora     = true
engine         = "aurora-postgresql"
engine_version = "15.4"
family         = "aurora-postgresql15"
```

**Перейти на MySQL:**
```hcl
engine         = "mysql"
engine_version = "8.0"
family         = "mysql8.0"
```

**Змінити клас інстансу:**
```hcl
instance_class = "db.r6g.large"  # production
instance_class = "db.t3.micro"   # development
```
