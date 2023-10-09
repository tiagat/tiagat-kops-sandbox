output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for index, subnet in aws_subnet.public_subnets : {
    id    = subnet.id,
    cidr  = subnet.cidr_block,
    zone  = subnet.availability_zone,
    index = index
  }]
}

output "private_subnets" {
  value = [for index, subnet in aws_subnet.private_subnets : {
    id    = subnet.id,
    cidr  = subnet.cidr_block,
    zone  = subnet.availability_zone,
    index = index
  }]
}
