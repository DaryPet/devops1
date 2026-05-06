variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
  default     = "5.1.5"
}

variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  type        = string
}

variable "git_repo_url" {
  description = "GitHub repository URL for the Django app"
  type        = string
}

variable "git_credentials_id" {
  description = "Jenkins credentials ID for GitHub access"
  type        = string
  default     = "github-credentials"
}
