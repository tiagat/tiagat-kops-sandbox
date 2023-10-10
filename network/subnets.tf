resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnets.*.cidr, count.index)
  availability_zone = element(var.public_subnets.*.zone, count.index)

  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true

  tags = {
    Name = "kops-public-subnet-${count.index + 1}"
  }
}
