module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # Adds the current caller identity as an administrator via cluster access entry
  #TODO - Disable this one and add a service role instead this role/group will have me and luis within it
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  access_entries = var.define_admin_users == true ? var.access_entries : null

  #TODO - Turn it into a variable or something that can be dynamically added
  # a Dynamic block for example
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
    aws-ebs-csi-driver = {
      most_recent = false
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

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      iam_role_additional_policies = {
        ebs_csi    = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
        s3_access  = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
        ec2_access = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      }
      tags = try(var.extra_tags, {})
    }
  }
}

resource "kubernetes_storage_class" "ebs-gp2" {
  metadata {
    name = "ebs-gp2"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "kubernetes.io/aws-ebs"
  volume_binding_mode    = "Immediate"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type = "gp2"
  }

}
