data "aws_region" "current" {}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier      = "${var.namespace}-aurora-cluster"
  engine                  = "aurora"
  availability_zones      = ["${data.aws_region.current.name}a","${data.aws_region.current.name}b","${data.aws_region.current.name}c"]
  database_name           = "petstore"
  master_username         = var.rds_user
  master_password         = var.rds_password
  backup_retention_period = 1
  skip_final_snapshot     = true
  preferred_backup_window = "04:00-07:00"
  engine_mode             = "serverless"
  scaling_configuration {
    max_capacity             = 1
    min_capacity             = 1
  }
}
