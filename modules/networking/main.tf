data "aws_availability_zones" "available" {}

resource "aws_default_vpc" "default" {
}

module "lambda_sg" {
  source        = "terraform-in-action/sg/aws"
  vpc_id        = aws_default_vpc.default.id
  ingress_rules = []
}

module "db_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = aws_default_vpc.default.id
  ingress_rules = [
    {
      protocol        = "tcp"
      port            = 3306
      security_groups = [module.lambda_sg.security_group.id]
    }
  ]
}
