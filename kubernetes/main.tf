resource "kubectl_manifest" "karpenter" {
  for_each = toset([
    "karpenter/provisioner.tftpl"
  ])
  yaml_body = templatefile("${abspath(path.module)}/${each.value}",
    {
      env_name     = var.env_name,
      cluster_name = var.cluster_name
    }
  )
}


resource "kubectl_manifest" "inflate" {
  for_each = toset([
    "inflate/pause.yaml",
  ])
  yaml_body = templatefile("${abspath(path.module)}/${each.value}",
    {
      env_name     = var.env_name,
      cluster_name = var.cluster_name
    }
  )
}

resource "kubectl_manifest" "kube_ops_view" {
  for_each = toset([
    "kube-ops-view/rbac-service-account.yaml",
    "kube-ops-view/rbac-cluster-role.yaml",
    "kube-ops-view/rbac-cluster-role-binding.yaml",
    "kube-ops-view/service.yaml",
    "kube-ops-view/deployment.yaml",
    "kube-ops-view/redis-deployment.yaml",
    "kube-ops-view/redis-service.yaml"
  ])
  yaml_body = templatefile("${abspath(path.module)}/${each.value}",
    {
      env_name     = var.env_name,
      cluster_name = var.cluster_name
    }
  )
}
