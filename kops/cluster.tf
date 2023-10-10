resource "kops_cluster" "cluster" {

  name                = "cluster.${var.dns_zone_name}"
  admin_ssh_key       = var.admin_ssh_key
  kubernetes_version  = var.kubernetes_version
  dns_zone            = var.dns_zone_name
  network_id          = var.vpc_id
  channel             = "stable"
  config_base         = "s3://tiagat.kops-state/cluster.${var.dns_zone_name}"
  master_public_name  = "api.cluster.kops.${var.dns_zone_name}"
  ssh_access          = ["0.0.0.0/0"]
  non_masquerade_cidr = "100.64.0.0/10"

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
    cilium {
      preallocate_bpf_maps        = true
      enable_remote_node_identity = true
      enable_node_port            = true
    }
  }

  topology {
    masters = "public"
    nodes   = "public"
    dns {
      type = "Public"
    }
  }

  dynamic "subnet" {
    for_each = { for subnet in var.subnets : subnet.id => subnet }
    content {
      type        = "Private"
      name        = "private-subnet-${subnet.value.index + 1}"
      provider_id = subnet.value.id
      zone        = subnet.value.zone
    }
  }

  dynamic "subnet" {
    for_each = { for subnet in var.subnets : subnet.id => subnet }
    content {
      name        = "utility-${subnet.value.index + 1}"
      type        = "Utility"
      provider_id = subnet.value.id
      zone        = subnet.value.zone
    }
  }

  # etcd clusters
  etcd_cluster {
    name = "main"

    cpu_request    = "200m"
    memory_request = "100Mi"

    dynamic "member" {
      for_each = { for subnet in var.subnets : subnet.id => subnet }
      content {
        encrypted_volume = true
        name             = "master-${member.value.index + 1}"
        instance_group   = "master-${member.value.index + 1}"
      }
    }
  }

  etcd_cluster {
    name = "events"

    cpu_request    = "100m"
    memory_request = "100Mi"

    dynamic "member" {
      for_each = { for subnet in var.subnets : subnet.id => subnet }
      content {
        name           = "master-${member.value.index + 1}"
        instance_group = "master-${member.value.index + 1}"
      }
    }

  }

  lifecycle {
    ignore_changes = [secrets]
  }

}
