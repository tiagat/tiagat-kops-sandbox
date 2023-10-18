terraform {

  required_version = ">= 1.2.6"

  required_providers {

    kops = {
      source  = "eddycharly/kops"
      version = "1.25.4"
    }

  }

}
