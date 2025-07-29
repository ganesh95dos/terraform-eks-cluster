module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31.0"

  # Cluster info
  cluster_name                   = local.name
  cluster_version                = "1.31"
  cluster_endpoint_public_access = true

 # Add-ons
  cluster_addons = {
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  vpc_id                         = module.vpc.vpc_id
  enable_irsa                    = true
  subnet_ids                     = module.vpc.private_subnets
  control_plane_subnet_ids       = module.vpc.intra_subnets
  # manage_aws_auth_configmap    = true  # Optional

  # Node Group Defaults
  eks_managed_node_group_defaults = {
    instance_types                              = ["t2.medium"]
    attach_cluster_primary_security_group       = true
  }

  # Managed Node Groups
  eks_managed_node_groups = {
    tws-cluster-node-group = {
      instance_types = ["t2.medium"]

      min_size      = 1
      max_size      = 2
      desired_size  = 2
      capacity_type = "SPOT"
      key_name      = "ec2-key-pair"
    }
  }
}

