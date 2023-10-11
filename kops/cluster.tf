locals {
  subnet_public  = var.subnets[0]
  subnet_utility = var.subnets[1]
}

resource "kops_cluster" "cluster" {

  name                  = "cluster.${var.dns_zone_name}"
  admin_ssh_key         = var.admin_ssh_key
  kubernetes_version    = var.kubernetes_version
  dns_zone              = var.dns_zone_name
  network_id            = var.vpc_id
  channel               = "stable"
  config_base           = "s3://tiagat.kops-state/cluster.${var.dns_zone_name}"
  master_public_name    = "api.cluster.${var.dns_zone_name}"
  ssh_access            = ["0.0.0.0/0"]
  kubernetes_api_access = ["0.0.0.0/0"]
  non_masquerade_cidr   = "100.64.0.0/10"

  api {
    dns {}
  }

  authorization {
    rbac {}
  }
  cloud_provider {
    aws {}
  }

  iam {
    allow_container_registry = true
  }

  kube_proxy {
    enabled = false
  }

  kubelet {
    anonymous_auth {
      value = false
    }
  }

  networking {
    calico {}
  }

  topology {
    masters = "public"
    nodes   = "public"
    dns {
      type = "Public"
    }
  }

  subnet {
    type        = "Public"
    name        = "subnet-public"
    provider_id = local.subnet_public.id
    zone        = local.subnet_public.zone
  }

  subnet {
    type        = "Utility"
    name        = "subnet-utility"
    provider_id = local.subnet_utility.id
    zone        = local.subnet_utility.zone
  }

  # etcd clusters
  etcd_cluster {
    name = "main"

    cpu_request    = "200m"
    memory_request = "100Mi"

    member {
      encrypted_volume = true
      name             = "a"
      instance_group   = "control-plane"
    }

  }

  etcd_cluster {
    name = "events"

    cpu_request    = "100m"
    memory_request = "100Mi"

    member {

      encrypted_volume = true
      name             = "a"
      instance_group   = "control-plane"
    }

  }

  lifecycle {
    ignore_changes = [secrets]
  }

}
