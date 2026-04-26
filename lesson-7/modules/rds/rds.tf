# ─────────────────────────────────────────────
# Regular RDS Instance (use_aurora = false)
# ─────────────────────────────────────────────
resource "aws_db_instance" "main" {
  count = var.use_aurora ? 0 : 1

  identifier        = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Networking
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Parameter group created in shared.tf
  parameter_group_name = aws_db_parameter_group.rds[0].name

  # High availability
  multi_az = var.multi_az

  # Backup
  backup_retention_period = 1
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  # Storage
  storage_type      = "gp2"
  storage_encrypted = true

  # Lifecycle
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot"

  tags = merge(var.tags, {
    Name = var.identifier
  })
}
