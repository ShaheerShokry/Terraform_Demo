terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws   = ">=3.54.0"
    local = ">=2.1.0"
  }
}


provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket               = "infra-terraform2"
    region               = "eu-central-1"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "state"
    encrypt              = true
  }
}
