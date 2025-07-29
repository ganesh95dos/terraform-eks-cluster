module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = local.name
  cidr = local.cicd

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  # ✅ Enable auto-assign public IP on public subnets
  map_public_ip_on_launch = true

  # ✅ Tags required for EKS LoadBalancer + ownership
  public_subnet_tags = {
    "kubernetes.io/role/elb"              = "1"
    "kubernetes.io/cluster/${local.name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/${local.name}" = "owned"
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

