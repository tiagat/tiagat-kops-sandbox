terraform {
  cloud {
    organization = "tiagat"

    workspaces {
      name = "kops-karpenter-poc"
    }
  }
}
