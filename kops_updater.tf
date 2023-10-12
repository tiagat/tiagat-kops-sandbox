resource "kops_cluster_updater" "updater" {
  cluster_name = kops_cluster.cluster.name
  keepers = merge({
    cluster = kops_cluster.cluster.revision,
    master  = kops_instance_group.master.revision,
    worker  = kops_instance_group.node.revision
  })

  apply {
    skip = false
  }

  validate {
    skip = false
  }

  rolling_update {
    skip                = false
    fail_on_drain_error = true
    fail_on_validate    = true
    validate_count      = 1
  }

  depends_on = [
    kops_cluster.cluster,
    kops_instance_group.master,
    kops_instance_group.node
  ]

}
