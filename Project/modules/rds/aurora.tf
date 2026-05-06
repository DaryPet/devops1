# ─────────────────────────────────────────────
# Aurora Cluster (use_aurora = true)
# ─────────────────────────────────────────────
resource "aws_rds_cluster" "main" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = var.identifier
  engine             = var.engine
  engine_version     = var.engine_version

  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password

  # Networking
  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.rds.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name

  # Backup
  backup_retention_period = 1
  preferred_backup_window = "03:00-04:00"
  preferred_maintenance_window = "mon:04:00-mon:05:00"

  # Storage
  storage_encrypted = true

  # Lifecycle
  skip_final_snapshot       = var.skip_final_snapshot
  deletion_protection       = var.deletion_protection
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-aurora-final-snapshot"

  tags = merge(var.tags, {
    Name = var.identifier
  })
}

# ─────────────────────────────────────────────
# Aurora Writer Instance
# ─────────────────────────────────────────────
resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${var.identifier}-writer"
  cluster_identifier = aws_rds_cluster.main[0].id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.main[0].engine
  engine_version     = aws_rds_cluster.main[0].engine_version

  # Networking
  db_subnet_group_name = aws_db_subnet_group.main.name
  publicly_accessible  = false

  # Monitoring
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = "${var.identifier}-writer"
    Role = "writer"
  })
}
