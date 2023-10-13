resource "kops_instance_group" "master" {

  cluster_name        = kops_cluster.cluster.name
  name                = "control-plane"
  role                = "Master"
  min_size            = 1
  max_size            = 1
  machine_type        = local.master_machine_type
  subnets             = ["subnet-public"]
  associate_public_ip = true
  depends_on          = [kops_cluster.cluster]

}

resource "kops_instance_group" "node" {

  cluster_name        = kops_cluster.cluster.name
  manager             = "Karpenter"
  name                = "node"
  role                = "Node"
  min_size            = local.node_min_size
  max_size            = local.node_max_size
  machine_type        = local.node_machine_type
  associate_public_ip = true
  subnets             = ["subnet-public"]
  root_volume_size    = 100
  depends_on          = [kops_cluster.cluster]

}
