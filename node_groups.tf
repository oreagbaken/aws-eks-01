locals {
  az1 = element(split("-", var.vpc_availability_zones[0]), 2)
  az2 = element(split("-", var.vpc_availability_zones[1]), 2)
  az3 = element(split("-", var.vpc_availability_zones[2]), 2)
}
locals {
  instance_type_config = {
    persist-medium-r5-large = {
      instance_type_family = "r5"
      capacity             = "large"
      node_workload_type   = "persist"
    }
    persist-medium-r5-2xlarge = {
      instance_type_family = "r5"
      capacity             = "2xlarge"
      node_workload_type   = "persist"
    }
    persist-medium-r5-4xlarge = {
      instance_type_family = "r5"
      capacity             = "4xlarge"
      node_workload_type   = "persist"
    }
  }
  node_labels = {
    management = {
      labels = {
        "node.workload.type" = "management"
      }
      asg_tags = [
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.type"
          value = "management"
        },
        {
          key                 = "owner"
          value               = "sre-cog"
          propagate_at_launch = true
        }
      ]
    }
    compute = {
      labels = {
        "node.workload.capacity" = "medium"
        "node.workload.type"     = "compute"
      }
      asg_tags = [
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.capacity"
          value = "medium"
        },
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.type"
          value = "compute"
        },
        {
          key                 = "owner"
          value               = "sre-cog"
          propagate_at_launch = true
        }
      ]
    }
    gpu-g4dn-2xlarge = {
      labels = {
        "node.workload.capacity" = "small"
        "node.workload.type"     = "gpu"
      }
      asg_tags = [
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.capacity"
          value = "small"
        }, {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.type"
          value = "gpu"
        },
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu"
          value = "true"
        },
        {
          key   = "k8s.io/cluster-autoscaler/node-template/resources/nvidia.com/gpu"
          value = "1"
        },
        {
          key                 = "owner"
          value               = "sre-cog"
          propagate_at_launch = true
        }
      ]
    }
    persist = {
      labels = {
        "node.workload.type"     = "persist"
        "node.workload.capacity" = "medium"
      }
      asg_tags = [
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.capacity"
          value = "medium"
        },
        {
          key   = "k8s.io/cluster-autoscaler/node-template/label/node.workload.type"
          value = "persist"
        },
        {
          key                 = "owner"
          value               = "sre-cog"
          propagate_at_launch = true
        }
      ]
    }
  }
}
locals {
  persist-medium-r5-large = {
    node_group_iam_role_name_az1 = join("-", ["cog", local.instance_type_config.persist-medium-r5-large.node_workload_type, local.instance_type_config.persist-medium-r5-large.instance_type_family, local.instance_type_config.persist-medium-r5-large.capacity, local.az1])
    node_group_iam_role_name_az2 = join("-", ["cog", local.instance_type_config.persist-medium-r5-large.node_workload_type, local.instance_type_config.persist-medium-r5-large.instance_type_family, local.instance_type_config.persist-medium-r5-large.capacity, local.az2])
    node_group_iam_role_name_az3 = join("-", ["cog", local.instance_type_config.persist-medium-r5-large.node_workload_type, local.instance_type_config.persist-medium-r5-large.instance_type_family, local.instance_type_config.persist-medium-r5-large.capacity, local.az3])
    aws_instance_type            = join(".", [local.instance_type_config.persist-medium-r5-large.instance_type_family, local.instance_type_config.persist-medium-r5-large.capacity])
  }
  persist-medium-r5-2xlarge = {
    node_group_iam_role_name_az1 = join("-", ["cog", local.instance_type_config.persist-medium-r5-2xlarge.node_workload_type, local.instance_type_config.persist-medium-r5-2xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-2xlarge.capacity, local.az1])
    node_group_iam_role_name_az2 = join("-", ["cog", local.instance_type_config.persist-medium-r5-2xlarge.node_workload_type, local.instance_type_config.persist-medium-r5-2xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-2xlarge.capacity, local.az2])
    node_group_iam_role_name_az3 = join("-", ["cog", local.instance_type_config.persist-medium-r5-2xlarge.node_workload_type, local.instance_type_config.persist-medium-r5-2xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-2xlarge.capacity, local.az3])
    aws_instance_type            = join(".", [local.instance_type_config.persist-medium-r5-2xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-2xlarge.capacity])
  }
  persist-medium-r5-4xlarge = {
    node_group_iam_role_name_az1 = join("-", ["cog", local.instance_type_config.persist-medium-r5-4xlarge.node_workload_type, local.instance_type_config.persist-medium-r5-4xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-4xlarge.capacity, local.az1])
    node_group_iam_role_name_az2 = join("-", ["cog", local.instance_type_config.persist-medium-r5-4xlarge.node_workload_type, local.instance_type_config.persist-medium-r5-4xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-4xlarge.capacity, local.az2])
    node_group_iam_role_name_az3 = join("-", ["cog", local.instance_type_config.persist-medium-r5-4xlarge.node_workload_type, local.instance_type_config.persist-medium-r5-4xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-4xlarge.capacity, local.az3])
    aws_instance_type            = join(".", [local.instance_type_config.persist-medium-r5-4xlarge.instance_type_family, local.instance_type_config.persist-medium-r5-4xlarge.capacity])
  }
}

locals {
  eks_cluster_node_groups = {
    cog-management = {
      tags           = merge(local.common_tags, local.finops_tags)
      instance_types = ["m5.2xlarge"]
      min_size       = 1
      desired_size   = 1
      labels         = local.node_labels.management.labels
      asg_tags       = local.node_labels.management.asg_tags
    }
    cog-compute-r5-4xl = {
      tags           = merge(local.common_tags, local.finops_tags)
      instance_types = ["r5.4xlarge"]
      labels         = local.node_labels.compute.labels
      asg_tags       = local.node_labels.compute.asg_tags
    }
    cog-gpu-g4dn-2x = {
      ami_type       = "AL2_x86_64_GPU"
      instance_types = ["g4dn.2xlarge"]
      labels = local.node_labels.gpu-g4dn-2xlarge.labels
      asg_tags = local.node_labels.gpu-g4dn-2xlarge.asg_tags
    }
    cog-persist-r5-4xlarge-az1 = {
      tags                     = merge(local.common_tags, local.finops_tags)
      use_name_prefix          = true
      iam_role_use_name_prefix = true
      iam_role_name            = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az1
      name                     = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az1
      launch_template_name     = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az1
      subnet_ids               = data.aws_subnets.private-subnet-2a.ids
      max_size                 = 72
      instance_types           = [local.persist-medium-r5-4xlarge.aws_instance_type]
      labels = local.node_labels.persist.labels
      asg_tags = local.node_labels.persist.asg_tags
    }
    cog-persist-r5-4xlarge-az2 = {
      tags                     = merge(local.common_tags, local.finops_tags)
      use_name_prefix          = true
      iam_role_use_name_prefix = true
      iam_role_name            = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az2
      name                     = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az2
      launch_template_name     = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az2
      subnet_ids               = data.aws_subnets.private-subnet-2b.ids
      max_size                 = 72
      instance_types           = [local.persist-medium-r5-4xlarge.aws_instance_type]
      labels = local.node_labels.persist.labels
      asg_tags = local.node_labels.persist.asg_tags
    }
    cog-persist-r5-4xlarge-az3 = {
      tags                     = merge(local.common_tags, local.finops_tags)
      use_name_prefix          = true
      iam_role_use_name_prefix = true
      iam_role_name            = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az3
      name                     = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az3
      launch_template_name     = local.persist-medium-r5-4xlarge.node_group_iam_role_name_az3
      subnet_ids               = data.aws_subnets.private-subnet-2c.ids
      max_size                 = 72
      instance_types           = [local.persist-medium-r5-4xlarge.aws_instance_type]
      labels = local.node_labels.persist.labels
      asg_tags = local.node_labels.persist.asg_tags
    }
  }
}
