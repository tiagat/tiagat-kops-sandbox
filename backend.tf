terraform {
  cloud {
    organization = "tiagat"

    workspaces {
      name = "tiagat-kops-sandbox"
    }
  }
}
