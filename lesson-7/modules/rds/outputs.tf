# ─────────────────────────────────────────────
# Endpoint (works for both RDS and Aurora)
# ─────────────────────────────────────────────
output "db_endpoint" {
  description = "Connection endpoint for the database. For Aurora - writer endpoint."
  value = var.use_aurora ? aws_rds_cluster.main[0].endpoint : aws_db_instance.main[0].address
}

output "db_port" {
  description = "Port the database is listening on"
  value = var.use_aurora ? aws_rds_cluster.main[0].port : aws_db_instance.main[0].port
}

output "db_arn" {
  description = "ARN of the database resource"
  value = var.use_aurora ? aws_rds_cluster.main[0].arn : aws_db_instance.main[0].arn
}

# ─────────────────────────────────────────────
# Aurora-specific outputs (null when use_aurora = false)
# ─────────────────────────────────────────────
output "aurora_reader_endpoint" {
  description = "Aurora cluster reader endpoint (load-balanced across read replicas). Null for regular RDS."
  value       = var.use_aurora ? aws_rds_cluster.main[0].reader_endpoint : null
}

output "aurora_cluster_id" {
  description = "Aurora cluster identifier. Null for regular RDS."
  value       = var.use_aurora ? aws_rds_cluster.main[0].cluster_identifier : null
}

# ─────────────────────────────────────────────
# Networking outputs
# ─────────────────────────────────────────────
output "security_group_id" {
  description = "ID of the Security Group attached to the database"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "Name of the DB Subnet Group"
  value       = aws_db_subnet_group.main.name
}

# ─────────────────────────────────────────────
# DB name and username (for app config)
# ─────────────────────────────────────────────
output "db_name" {
  description = "Name of the initial database"
  value       = var.db_name
}

output "db_username" {
  description = "Master username for the database"
  value       = var.db_username
  sensitive   = true
}
