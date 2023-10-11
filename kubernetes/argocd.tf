resource "helm_release" "argocd" {
  chart            = "argo-cd"
  version          = "5.46.7"
  repository       = "https://argoproj.github.io/argo-helm"
  name             = "argocd"
  timeout          = 3600
  create_namespace = true
  replace          = true
  namespace        = "argocd"
  values = [
    templatefile("${path.module}/argocd.tftpl", {})
  ]
}
