# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.env_name}-public-route-table"
    Environment = "${var.env_name}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route table associations for both Public subnet
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.env_name}-private-route-table-${count.index + 1}"
    Environment = "${var.env_name}"
  }
}

# Route for NAT Gateway
resource "aws_route" "private_internet_gateway" {
  count                  = length(aws_subnet.private_subnets)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  gateway_id             = element(aws_nat_gateway.nat.*.id, count.index)
}

# Route table associations for both Private subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
