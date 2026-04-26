# ─────────────────────────────────────────────
# DB Subnet Group (used by both RDS and Aurora)
# ─────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name        = "${var.identifier}-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ${var.identifier}"

  tags = merge(var.tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

# ─────────────────────────────────────────────
# Security Group (used by both RDS and Aurora)
# ─────────────────────────────────────────────
locals {
  # Automatically pick the right port based on engine
  db_port = (
    var.engine == "postgres" || var.engine == "aurora-postgresql"
  ) ? 5432 : 3306
}

resource "aws_security_group" "rds" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier} database"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow DB traffic from within VPC"
    from_port   = local.db_port
    to_port     = local.db_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-sg"
  })
}

# ─────────────────────────────────────────────
# Parameter Group for regular RDS (use_aurora = false)
# ─────────────────────────────────────────────
resource "aws_db_parameter_group" "rds" {
  count = var.use_aurora ? 0 : 1

  name        = "${var.identifier}-pg"
  family      = var.family
  description = "Parameter group for ${var.identifier} (RDS)"

  # Max connections limit
  parameter {
    name  = "max_connections"
    value = "100"
    apply_method = "pending-reboot"
  }

  # Log all SQL statements (PostgreSQL only — ignored by MySQL)
  dynamic "parameter" {
    for_each = (
      var.engine == "postgres"
    ) ? [1] : []
    content {
      name  = "log_statement"
      value = "all"
      apply_method = "pending-reboot"
    }
  }

  # Work memory per query operation (PostgreSQL only)
  dynamic "parameter" {
    for_each = (
      var.engine == "postgres"
    ) ? [1] : []
    content {
      name  = "work_mem"
      value = "4096" # 4 MB in KB
      apply_method = "pending-reboot"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-pg"
  })
}

# ─────────────────────────────────────────────
# Parameter Group for Aurora cluster (use_aurora = true)
# ─────────────────────────────────────────────
resource "aws_rds_cluster_parameter_group" "aurora" {
  count = var.use_aurora ? 1 : 0

  name        = "${var.identifier}-aurora-cpg"
  family      = var.family
  description = "Cluster parameter group for ${var.identifier} (Aurora)"

  # Max connections limit
  parameter {
    name  = "max_connections"
    value = "100"
    apply_method = "pending-reboot"
  }

  # Log all SQL statements (Aurora PostgreSQL only)
  dynamic "parameter" {
    for_each = (
      var.engine == "aurora-postgresql"
    ) ? [1] : []
    content {
      name  = "log_statement"
      value = "all"
      apply_method = "pending-reboot"
    }
  }

  # Work memory per query operation (Aurora PostgreSQL only)
  dynamic "parameter" {
    for_each = (
      var.engine == "aurora-postgresql"
    ) ? [1] : []
    content {
      name  = "work_mem"
      value = "4096"
      apply_method = "pending-reboot"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-aurora-cpg"
  })
}
