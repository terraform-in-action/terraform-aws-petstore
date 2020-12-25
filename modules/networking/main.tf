data "aws_availability_zones" "available" {}

resource "aws_default_vpc" "default" {
}

module "lambda_sg" {
  source = "scottwinkler/sg/aws"
  vpc_id = aws_default_vpc.default.id
  ingress_rules = []
}
