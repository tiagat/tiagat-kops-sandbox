# resource "kops_cluster" "cluster" {

#   name               = "cluster.${var.dns_zone_name}"
#   admin_ssh_key      = var.admin_ssh_key
#   kubernetes_version = "1.28"
#   dns_zone           = var.dns_zone_name
#   network_id         = var.vpc_id

#   cloud_provider {
#     aws {}
#   }

#   iam {
#     allow_container_registry = true
#   }

#   networking {
#     calico {}
#   }

#   topology {
#     masters = "private"
#     nodes   = "private"
#     dns {
#       type = "Public"
#     }
#   }

#   dynamic "subnet" {
#     for_each = { for subnet in var.private_subnets : subnet.id => subnet }
#     content {
#       type        = "Private"
#       name        = "private-subnet-${subnet.value.index + 1}"
#       provider_id = subnet.value.id
#       zone        = subnet.value.zone
#     }
#   }

#   dynamic "subnet" {
#     for_each = { for subnet in var.private_subnets : subnet.id => subnet }
#     content {
#       name        = "utility-${subnet.value.index + 1}"
#       type        = "Utility"
#       provider_id = subnet.value.id
#       zone        = subnet.value.zone
#     }
#   }

#   # etcd clusters
#   etcd_cluster {
#     name = "main"
#     member {
#       name           = "master-0"
#       instance_group = "master-0"
#     }
#     member {
#       name           = "master-1"
#       instance_group = "master-1"
#     }
#   }
#   etcd_cluster {
#     name = "events"
#     member {
#       name           = "master-0"
#       instance_group = "master-0"
#     }
#     member {
#       name           = "master-1"
#       instance_group = "master-1"
#     }
#   }

# }
