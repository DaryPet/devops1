variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "K8s version"
  type        = string
  default     = "1.28"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "node_group_name" {
  description = "Node group name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for nodes"
  type        = string
  default     = "t3.micro"
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Max number of nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Min number of nodes"
  type        = number
  default     = 1
}