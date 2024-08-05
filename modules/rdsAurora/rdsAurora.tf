resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = var.master_username
  master_password         = var.master_password
  database_name           = var.database_name
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = {
    Name = var.cluster_identifier
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count = var.instance_count

  identifier              = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier      = aws_rds_cluster.aurora.id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.aurora.engine
  engine_version          = aws_rds_cluster.aurora.engine_version
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.aurora.name

  tags = {
    Name = "${var.cluster_identifier}-instance-${count.index}"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}
