resource "kops_cluster" "cluster" {

  name               = "cluster.${var.dns_zone_name}"
  admin_ssh_key      = var.admin_ssh_key
  kubernetes_version = "stable"
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
      type = "private"
    }
  }

  subnet {
    name        = "private-0"
    type        = "Private"
    provider_id = ""
    zone        = ""
  }

  subnet {
    name        = "utility-0"
    type        = "Utility"
    provider_id = ""
    zone        = ""
  }

  # etcd clusters
  etcd_cluster {
    name = "main"
    member {
      name           = "master-0"
      instance_group = "master-0"
    }
    member {
      name           = "master-1"
      instance_group = "master-1"
    }
  }
  etcd_cluster {
    name = "events"
    member {
      name           = "master-0"
      instance_group = "master-0"
    }
    member {
      name           = "master-1"
      instance_group = "master-1"
    }
  }

}
