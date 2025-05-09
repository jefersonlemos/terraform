module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name                   = local.full_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # Adds the current caller identity as an administrator via cluster access entry
  #TODO - Disable this one and add a service role instead this role/group will have me and luis within it
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions


  #TODO - Turn it into a variable or something that can be dynamically added
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  
  #TODO - Turn it into a variable or something that can be dynamically added
  eks_managed_node_groups = {
    amc-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = var.extra_tags
      }
    }
  }
}
