variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "6.7.3"
}

variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "git_repo_url" {
  description = "GitHub repository URL that Argo CD will watch"
  type        = string
}

variable "git_repo_branch" {
  description = "Git branch to track"
  type        = string
  default     = "lesson-8-9"
}

variable "git_token" {
  description = "GitHub personal access token for private repo access"
  type        = string
  sensitive   = true
}

variable "app_namespace" {
  description = "Kubernetes namespace where django-app will be deployed"
  type        = string
  default     = "default"
}
