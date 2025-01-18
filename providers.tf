
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.68.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
  }
}
#
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
#
provider "kubernetes" {
  config_path = "~/.kube/config"
}
#
provider "null" {
}
resource "random_pet" "aksrandom" {}

# terraform {
#   backend "s3" {
#     bucket = ""
#     key    = "terraform-prod/terraform.tfstate"
#     region = "ap-south-1"
#   }
# }
