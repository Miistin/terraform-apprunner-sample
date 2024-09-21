data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_subnets" "current" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_security_group" "current" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
