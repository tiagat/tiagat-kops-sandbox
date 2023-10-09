locals {

  public_subnets = [
    { cidr = "10.0.16.0/20", zone = "us-east-1a" },
    # { cidr = "10.0.32.0/20", zone = "us-east-1b" },
    # { cidr = "10.0.48.0/20", zone = "us-east-1c" },
    # { cidr = "10.0.64.0/20", zone = "us-east-1d" }
  ]

  private_subnets = [
    { cidr = "10.0.112.0/20", zone = "us-east-1a" },
    # { cidr = "10.0.128.0/20", zone = "us-east-1b" },
    # { cidr = "10.0.144.0/20", zone = "us-east-1c" },
    # { cidr = "10.0.160.0/20", zone = "us-east-1d" }
  ]

}

module "network" {
  source   = "./network"
  env_name = var.env_name

  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

}


module "services" {
  source = "./services"

  env_name         = var.env_name
  root_dns_zone_id = "Z21QUWM4HPEMRC"
}



module "kubernetes" {
  source = "./kubernetes"

  env_name = var.env_name
  vpc_id   = module.network.vpc_id

  dns_zone_id   = module.services.dns_zone_id
  dns_zone_name = module.services.dns_zone_name

  private_subnets = module.network.private_subnets
  public_subnets  = module.network.public_subnets

  depends_on = [
    module.network,
    module.services
  ]

}
