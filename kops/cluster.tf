locals {
  subnet_public  = var.subnets[0]
  subnet_utility = var.subnets[1]
}

resource "kops_cluster" "cluster" {

  name               = var.dns_zone_name
  admin_ssh_key      = var.admin_ssh_key
  kubernetes_version = var.kubernetes_version
  dns_zone           = var.dns_zone_name
  network_id         = var.vpc_id
  channel            = "stable"
  config_base        = "s3://tiagat.kops-state/cluster.${var.dns_zone_name}"
  master_public_name = "api.${var.dns_zone_name}"
  cluster_dns_domain = "cluster.local"
  container_runtime  = "containerd"

  ssh_access            = ["0.0.0.0/0"]
  kubernetes_api_access = ["0.0.0.0/0"]

  kube_api_server {
    anonymous_auth {
      value = false
    }
  }

  cloud_labels = {
    environment  = var.env_name
    cluster-name = var.dns_zone_name
  }

  api {
    dns {}
  }

  authorization {
    rbac {}
  }
  cloud_provider = "aws"
  iam {
    allow_container_registry = true
    legacy                   = false
  }

  kube_proxy {
    enabled = false
  }

  kube_dns {
    provider = "CoreDNS"
    node_local_dns {
      enabled        = true
      memory_request = "5Mi"
      cpu_request    = "25m"
    }
  }

  kubelet {
    anonymous_auth {
      value = false
    }
  }

  cert_manager {
    enabled = true
    managed = false
  }

  networking {
    cilium {
      enable_prometheus_metrics   = true
      enable_node_port            = true
      enable_remote_node_identity = true
      preallocate_bpf_maps        = true
      hubble {
        enabled = false
      }
    }
  }

  topology {
    masters = "public"
    nodes   = "public"
    dns {
      type = "Public"
    }
  }

  cluster_autoscaler {
    enabled                          = true
    expander                         = "least-waste"
    skip_nodes_with_local_storage    = true
    skip_nodes_with_system_pods      = true
    scale_down_utilization_threshold = "0.5"
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
      name             = "member"
      instance_group   = "control-plane"
    }

  }

  etcd_cluster {
    name = "events"

    cpu_request    = "100m"
    memory_request = "100Mi"

    member {

      encrypted_volume = true
      name             = "member"
      instance_group   = "control-plane"
    }

  }

  lifecycle {
    ignore_changes = [secrets]
  }

}
