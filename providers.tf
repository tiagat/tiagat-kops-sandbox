terraform {

  required_version = ">= 1.2.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }

    kops = {
      source  = "eddycharly/kops"
      version = "1.25.4"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }

  }

}

provider "aws" {
  region  = "us-east-1"
  profile = "tiagat"
}

provider "kops" {
  state_store = "s3://tiagat.kops-state"
  aws {
    profile = "tiagat"
  }
}

data "kops_kube_config" "kube_config" {
  cluster_name = local.dns_zone_name
  depends_on   = [module.kops]
}

provider "kubectl" {
  host                   = data.kops_kube_config.kube_config.server
  username               = data.kops_kube_config.kube_config.kube_user
  password               = data.kops_kube_config.kube_config.kube_password
  client_certificate     = data.kops_kube_config.kube_config.client_cert
  client_key             = data.kops_kube_config.kube_config.client_key
  cluster_ca_certificate = data.kops_kube_config.kube_config.ca_certs
  load_config_file       = false
}

provider "kubernetes" {
  host                   = data.kops_kube_config.kube_config.server
  username               = data.kops_kube_config.kube_config.kube_user
  password               = data.kops_kube_config.kube_config.kube_password
  client_certificate     = data.kops_kube_config.kube_config.client_cert
  client_key             = data.kops_kube_config.kube_config.client_key
  cluster_ca_certificate = data.kops_kube_config.kube_config.ca_certs
}

provider "helm" {
  kubernetes {
    host                   = data.kops_kube_config.kube_config.server
    client_certificate     = data.kops_kube_config.kube_config.client_cert
    client_key             = data.kops_kube_config.kube_config.client_key
    cluster_ca_certificate = data.kops_kube_config.kube_config.ca_certs
    username               = data.kops_kube_config.kube_config.kube_user
    password               = data.kops_kube_config.kube_config.kube_password

  }
}
