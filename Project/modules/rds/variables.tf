variable "use_aurora" {
  description = "If true - creates Aurora Cluster + writer instance. If false - creates a single aws_db_instance."
  type        = bool
  default     = false
}

variable "identifier" {
  description = "Unique identifier for the RDS instance or Aurora cluster"
  type        = string
  default     = "darya-petrenko-db"
}

variable "engine" {
  description = "Database engine: 'postgres' or 'mysql' for RDS; 'aurora-postgresql' or 'aurora-mysql' for Aurora"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version. Examples: '15.4' for postgres, '8.0' for mysql, '15.4' for aurora-postgresql, '8.0.mysql_aurora.3.04.0' for aurora-mysql"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora instance. Example: 'db.t3.micro', 'db.r6g.large'"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB. Only used for regular RDS (ignored for Aurora)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment. Only applies to regular RDS (not Aurora)"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC where RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the DB Subnet Group (minimum 2 subnets in different AZs)"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block used to allow inbound traffic in Security Group"
  type        = string
  default     = "10.0.0.0/16"
}

variable "family" {
  description = "Parameter group family. Examples: 'postgres15', 'mysql8.0', 'aurora-postgresql15', 'aurora-mysql8.0'"
  type        = string
  default     = "postgres15"
}

variable "skip_final_snapshot" {
  description = "If true - no final snapshot on destroy. Set false for production!"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection. Set true for production!"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "devops1"
    ManagedBy = "terraform"
  }
}
