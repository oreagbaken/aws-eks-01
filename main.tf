locals {
  eks_tags = {
    CreatedBy = "ci_de_sre_role"
  }
  common_tags = {
    owner          = "sre-cog"
    terraform      = true
    aws_region     = var.region
    cloud_provider = "aws"
    cloud_region   = replace(var.region, "-", "_")
    eks-cluster    = var.eks_cluster_name
  }
  ng_names        = keys(local.eks_cluster_node_groups)
  asg_tags        = {for name in local.ng_names : name => lookup(try(local.eks_cluster_node_groups[name], {}), "asg_tags", {})}
  
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v18.31.1"

  cluster_enabled_log_types               = var.eks_cluster_enable_log_types
  cluster_endpoint_private_access         = var.eks_cluster_endpoint_private_access
  cluster_endpoint_public_access          = var.eks_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs    = var.eks_cluster_endpoint_public_access_cidrs
  cloudwatch_log_group_retention_in_days  = var.eks_cluster_log_retention_in_days
  cluster_name                            = var.eks_cluster_name
  cluster_version                         = var.eks_kubernetes_version
  create                                  = var.eks_create_cluster
  enable_irsa                             = var.eks_enable_irsa
  eks_managed_node_groups                 = merge(local.eks_cluster_node_groups)
  eks_managed_node_group_defaults         = var.eks_cluster_node_groups_defaults
  subnet_ids                              = var.private_subnets
  iam_role_permissions_boundary           = var.cluster_iam_role_permission_boundary
  tags                                    = merge(local.eks_tags, local.common_tags, local.finops_tags)
  vpc_id                                  = var.vpc_id
  cluster_security_group_additional_rules = {
    ingress_allow_all_from_node_sg = {
      description                = "Node groups to all port/protocols in cluster"
      protocol                   = "all"
      from_port                  = 0
      to_port                    = 0
      type                       = "ingress"
      source_node_security_group = true
    }
  }
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "all"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_allow_all_from_cluster_sg = {
      description                   = "Worker nodes to all ports/protocols in control plane"
      protocol                      = "all"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}
