module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.11.1"
  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
      eks_nodes = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t2.micro"
      key_name      = "test.pem" 
      additional_security_group_ids = [aws_security_group.eks_nodes_sg.id]
    }
  }

  enable_irsa = true
}
