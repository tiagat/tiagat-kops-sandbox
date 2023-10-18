locals {

  kops_subnets = var.public_subnets

  kops_subnet_public  = local.kops_subnets[0]
  kops_subnet_utility = local.kops_subnets[1]
}


resource "kops_cluster" "cluster" {

  name               = var.cluster_name
  admin_ssh_key      = var.admin_ssh_key
  kubernetes_version = var.kubernetes_version
  dns_zone           = var.dns_zone_name
  network_id         = var.vpc_id
  channel            = "stable"
  config_base        = "s3://${var.bucket_state}/${var.cluster_name}"
  master_public_name = "api.${var.dns_zone_name}"
  cluster_dns_domain = "cluster.local"
  container_runtime  = "containerd"

  ssh_access            = ["0.0.0.0/0"]
  kubernetes_api_access = ["0.0.0.0/0"]

  cloud_labels = {
    environment  = var.env_name
    cluster-name = var.cluster_name
  }

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
    legacy                   = false
  }

  additional_policies = {
    master = <<EOT
      [
        {
          "Effect": "Allow",
          "Action": "*",
          "Resource": "*"
        }
      ]
    EOT
    node   = <<EOT
      [
        {
          "Effect": "Allow",
          "Action": "*",
          "Resource": "*"
        }
      ]
    EOT
  }

  service_account_issuer_discovery {
    discovery_store          = "s3://${var.bucket_discovery}"
    enable_aws_oidc_provider = true
  }

  kube_proxy {
    enabled = false
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

  metrics_server {
    enabled  = true
    insecure = true
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

  karpenter {
    enabled = true
  }

  subnet {
    type        = "Public"
    name        = "subnet-public"
    provider_id = local.kops_subnet_public.id
    zone        = local.kops_subnet_public.zone
  }

  subnet {
    type        = "Utility"
    name        = "subnet-utility"
    provider_id = local.kops_subnet_utility.id
    zone        = local.kops_subnet_utility.zone
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
