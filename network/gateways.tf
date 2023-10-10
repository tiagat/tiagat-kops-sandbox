#Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.env_name}-igw"
    "Environment" = var.env_name
  }
}
