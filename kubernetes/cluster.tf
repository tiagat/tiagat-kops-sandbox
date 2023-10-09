resource "kops_cluster" "cluster" {

  name               = "cluster.${var.dns_zone_name}"
  admin_ssh_key      = file("${path.module}/certificates/id_rsa.pub")
  kubernetes_version = "1.28"
  dns_zone           = var.dns_zone_name
  network_id         = var.vpc_id

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
