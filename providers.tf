
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0"
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
      version = "~> 5.0"
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
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}
#
# Configure Helm provider to use kubeconfig
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
#
# Kubernetes provider is configured in k8s-deployments.tf
#
provider "null" {
}
resource "random_pet" "aksrandom" {}

terraform {
  backend "s3" {
    bucket = "dev-pharametrade"
    key    = "terraform-pharmetrade-production/terraform.tfstate"
    region = "us-east-1"
  }
}
