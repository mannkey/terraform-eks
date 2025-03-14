locals {
  cluster_name = "pharmetrade-eks-cluster"
}

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.33.0"
  cluster_name                   = local.cluster_name
  cluster_version                = var.kubernetes_version
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  enable_irsa = true

  tags = {
    cluster = "pharmetrade"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 1
      max_size     = 6
      desired_size = 1
    }
  }
}

