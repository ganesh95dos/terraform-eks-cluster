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

  vpc_id                   = module.vpc.vpc_id
  enable_irsa              = true
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
  # manage_aws_auth_configmap    = true  # Optional



  # Node Group Defaults
  eks_managed_node_group_defaults = {
    instance_types                        = ["t2.medium"]
    attach_cluster_primary_security_group = true
  }

  # Managed Node Groups
  eks_managed_node_groups = {
    tws-cluster-node-group = {
      subnet_ids     = module.vpc.public_subnets
      instance_types = ["t2.medium"]

      min_size      = 1
      max_size      = 2
      desired_size  = 2
      capacity_type = "SPOT"
      key_name      = "ec2-key-pair"
    }
  }
  node_security_group_additional_rules = {
    allow_http_ingress = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP traffic"
    }

    allow_argocd_ui = {
      type        = "ingress"
      from_port   = 31718
      to_port     = 31718
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ArgoCD UI"
    }

    allow_prometheus = {
      type        = "ingress"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Prometheus access"
    }

    allow_grafana = {
      type        = "ingress"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Grafana dashboard access"
    }
  }
}

