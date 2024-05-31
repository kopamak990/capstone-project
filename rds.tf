# RDS Cluster Configuration
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier   = "aurora-cluster"
  engine               = "aurora-mysql"
  engine_version       = "8.0.mysql_aurora.3.06.0"
  availability_zones   = [var.availability_zone_1, var.availability_zone_2]
  database_name        = "kolade_wordpress_db"
  master_username      = var.wp_db_user
  master_password      = var.wp_db_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  tags = { Name = "aurora-cluster" }
}

resource "aws_rds_cluster_instance" "aurora_cluster_instances" {
  count              = 2
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.t3.medium"
  engine             = "aurora-mysql"
  availability_zone  = count.index == 0 ? var.availability_zone_1 : var.availability_zone_2
  tags = { Name = "aurora-cluster-instance-${count.index}" }
}