resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "vpc-${var.env_name}"
    Environment = var.env_name
  }
}
