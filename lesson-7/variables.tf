variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
  default     = "admin123"
}

variable "git_repo_url" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/DaryPet/devops1.git"
}

variable "git_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
  default     = ""
}
