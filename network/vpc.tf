resource "aws_vpc" "main" {
  cidr_block = var.vpc_subnet

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-${var.env_name}"
    Environment = var.env_name
  }
}
