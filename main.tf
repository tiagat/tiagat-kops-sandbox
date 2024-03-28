locals {

  dns_zone_id   = "Z098148527GR4NB025A55"
  dns_zone_name = "sandbox.tiagat.dev"

  vpc_subnet = "172.83.0.0/16"
  public_subnets = [
    { cidr = "172.83.16.0/20", zone = "us-east-1a" },
    { cidr = "172.83.32.0/20", zone = "us-east-1b" },
    { cidr = "172.83.48.0/20", zone = "us-east-1c" },
  ]
}

module "network" {
  source   = "./network"
  env_name = var.env_name

  vpc_subnet     = local.vpc_subnet
  public_subnets = local.public_subnets

}


module "services" {
  source = "./services"

  env_name      = var.env_name
  dns_zone_name = local.dns_zone_name
}


module "kops" {
  source = "./kops"

  env_name      = var.env_name
  dns_zone_id   = local.dns_zone_id
  dns_zone_name = local.dns_zone_name

  vpc_id  = module.network.vpc_id
  subnets = module.network.public_subnets

  admin_ssh_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNzuKa1c18dM9d9NtoQya4xow4FTnMzzV64hVONrURp01pRxdbarCnB6svptlBPFi1EA7AXmcQ6xgUm5W0FseRDqGr5UxZTU9HjtaCf9lanPR0AS29fDRE1Hfbyyrg0bddy+QNBqAitg22kI6EpUJjKn/I4qNQR1YWmk2UglumbwXcNKMpoJmUqCmWThtbHsqVI7wJA4Ur82TnAt8ugSTLNLlrpfH3s7AFfwL5QC03cM3zQgEfhGPWpUmm+0bPqVv5+McO6pGdUXi/l6ry90flQ7Z+nnf+P61ndlh9xfx42jO514oFRncjBvOPmkK3MllN3NDde0GFMtbxHvcrfyP/ tiagat@golem"
  kubernetes_version  = "1.23.2"
  master_machine_type = "t3.medium"

  node_machine_type = "t3.medium"
  node_min_size     = 1
  node_max_size     = 2

  depends_on = [
    module.network,
    module.services
  ]

}

# module "kubernetes" {
#   source = "./kubernetes"

#   env_name = var.env_name

#   depends_on = [
#     module.network,
#     module.services,
#     module.kops
#   ]
# }
