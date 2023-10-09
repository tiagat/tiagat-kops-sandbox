locals {
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.16.0/20", "10.0.32.0/20"]
  private_subnet_cidrs = ["10.0.112.0/20", "10.0.128.0/20"]
}

module "network" {
  source   = "./network"
  env_name = var.env_name

  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}


module "services" {
  source   = "./services"
  env_name = var.env_name
}
