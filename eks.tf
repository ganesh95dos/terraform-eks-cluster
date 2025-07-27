module "eks-cluster" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"
  
  #this is cluster info
  cluster_name    = "${local.name}"
 

  cluster_version = "1.31"
  cluster_endpoint_public_access = true

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
  vpc_id     = module.vpc.vpc_id

  #This is for EKS control plan manage in intra net
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
  instance_types = ["t2.medium"]
  
  #attach security policy
  #with this any instance create its connected in this cluster security group
  attach_cluster_primary_security_group = true

  }

  eks_managed_node_groups = {
    tws-cluster-node-group = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
      capacity_type = "SPOT"  
      key_name       = "ec2-key-pair"
    }
  }
}