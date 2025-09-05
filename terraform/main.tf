terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws   = ">=3.54.0"
    local = ">=2.1.0"
  }
}

# backend.tf
terraform {
  backend "s3" {
    bucket               = "infra-terraform2"     # one bucket for all envs
    region               = "eu-central-1"
    key                  = "terraform.tfstate"   # base filename
    workspace_key_prefix = "state"               # gives state/<ws>/terraform.tfstate
#    dynamodb_table       = "tf-locks"            # enable locking
    encrypt              = true                  
  }
}



provider "aws" {
  region = "eu-central-1"
}

