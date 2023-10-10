resource "kops_cluster" "cluster" {

  name               = "cluster.${var.dns_zone_name}"
  admin_ssh_key      = var.admin_ssh_key
  kubernetes_version = var.kubernetes_version
  dns_zone           = var.dns_zone_name
  network_id         = var.vpc_id

  api {
    load_balancer {
      additional_security_groups = []
      class                      = "Classic"
      cross_zone_load_balancing  = false
      idle_timeout_seconds       = 0
      type                       = "Public"
      use_for_internal_api       = false
    }
  }

  authorization {
    always_allow {}
  }
  cloud_provider {
    aws {}
  }

  iam {
    allow_container_registry = true
  }

  networking {
    calico {}
  }

  topology {
    masters = "private"
    nodes   = "private"
    dns {
      type = "Public"
    }
  }

  dynamic "subnet" {
    for_each = { for subnet in var.private_subnets : subnet.id => subnet }
    content {
      type        = "Private"
      name        = "private-subnet-${subnet.value.index + 1}"
      provider_id = subnet.value.id
      zone        = subnet.value.zone
    }
  }

  dynamic "subnet" {
    for_each = { for subnet in var.private_subnets : subnet.id => subnet }
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

    dynamic "member" {
      for_each = { for subnet in var.private_subnets : subnet.id => subnet }
      content {
        name           = "master-${member.value.index + 1}"
        instance_group = "master-${member.value.index + 1}"
      }
    }
  }
  etcd_cluster {
    name = "events"
    dynamic "member" {
      for_each = { for subnet in var.private_subnets : subnet.id => subnet }
      content {
        name           = "master-${member.value.index + 1}"
        instance_group = "master-${member.value.index + 1}"
      }
    }
  }

}
