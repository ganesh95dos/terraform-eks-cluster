output "cluster_name" {
  value = module.eks-cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks-cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks-cluster.cluster_security_group_id
}
