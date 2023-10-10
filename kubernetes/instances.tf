resource "kops_instance_group" "master" {

  for_each = { for subnet in var.private_subnets : subnet.id => subnet }

  cluster_name = kops_cluster.cluster.name
  name         = "master-${each.value.index + 1}"
  role         = "Master"
  min_size     = 1
  max_size     = 1
  machine_type = var.master_machine_type
  subnets      = ["private-subnet-${each.value.index + 1}"]

  depends_on = [kops_cluster.cluster]

}


resource "kops_instance_group" "node" {

  for_each = { for subnet in var.private_subnets : subnet.id => subnet }

  cluster_name = kops_cluster.cluster.name
  name         = "node-${each.value.index + 1}"
  role         = "Node"
  min_size     = var.node_min_size
  max_size     = var.node_max_size
  machine_type = var.master_machine_type
  subnets      = ["private-subnet-${each.value.index + 1}"]

  depends_on = [kops_cluster.cluster]

}