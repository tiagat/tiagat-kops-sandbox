terraform {

  required_version = ">= 1.2.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }

    kops = {
      source  = "eddycharly/kops"
      version = "1.25.4"
    }
  }

}

provider "aws" {
  region  = "us-east-1"
  profile = "tiagat"
}

provider "kops" {
  state_store = "s3://kops.tiagat.dev-cluster-state"
  aws {
    profile = "tiagat"
  }
}
