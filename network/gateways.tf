#Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.env_name}-igw"
    "Environment" = var.env_name
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  count      = length(aws_subnet.private_subnets)
  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name        = "nat-gateway-ip-${var.env_name}-${count.index + 1}"
    Environment = "${var.env_name}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  count         = length(aws_subnet.private_subnets)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.private_subnets.*.id, count.index)
  tags = {
    Name        = "nat-gateway-${var.env_name}-${count.index + 1}"
    Environment = "${var.env_name}"
  }
}
