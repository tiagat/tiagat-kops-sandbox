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
  source = "./services"

  env_name         = var.env_name
  root_dns_zone_id = "Z21QUWM4HPEMRC"
}



module "kubernetes" {
  source = "./kubernetes"


  env_name             = var.env_name
  vpc_id               = module.network.vpc_id
  dns_zone_id          = module.services.dns_zone_id
  dns_zone_name        = module.services.dns_zone_name
  admin_ssh_key        = module.services.admin_ssh_key
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  availability_zones   = local.availability_zones

}
