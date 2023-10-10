resource "kops_instance_group" "master" {

  for_each = { for subnet in var.subnets : subnet.index => subnet }

  cluster_name        = kops_cluster.cluster.name
  name                = "master-${each.key + 1}"
  role                = "Master"
  min_size            = 1
  max_size            = 1
  machine_type        = var.master_machine_type
  subnets             = ["subnet-${each.key + 1}"]
  associate_public_ip = true
  depends_on          = [kops_cluster.cluster]

}


resource "kops_instance_group" "node" {

  for_each = { for subnet in var.subnets : subnet.index => subnet }

  cluster_name        = kops_cluster.cluster.name
  name                = "node-${each.key + 1}"
  role                = "Node"
  min_size            = var.node_min_size
  max_size            = var.node_max_size
  machine_type        = var.master_machine_type
  associate_public_ip = true
  subnets             = ["subnet-${each.key + 1}"]

  depends_on = [kops_cluster.cluster]

}
