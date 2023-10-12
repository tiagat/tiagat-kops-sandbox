
locals {
  karpenter_manifests = toset([
    "karpenter/provisioner.tftpl",
    "karpenter/aws-node-template.tftpl"
  ])
}


resource "kubectl_manifest" "karpenter" {
  for_each = local.karpenter_manifests
  yaml_body = templatefile("${abspath(path.module)}/${each.value}",
    {
      env_name     = var.env_name,
      cluster_name = var.cluster_name
    }
  )

}
