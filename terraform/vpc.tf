locals {
  cluster_name = "monitoring-eks"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"  

  name = "eks-vpc"
  cidr = "10.0.0.0/24" #CIDR block for the VPC can add upto 256 IP addresses

  azs             = ["ap-south-1"] # we can add multiple azs
  private_subnets = ["10.0.0.0/25"] # for private access
  public_subnets = ["10.0.0.128/25"] #for jump server

  enable_nat_gateway = true #NAT Gateway for outbound internet access from private subnets
  single_nat_gateway = true 

  private_subnet_tags = {
    "kubernetes.io/cluster/ ${local.cluster_name}" = "private"
    "kubernetes.io/role/internal-elb"            = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                     = "1"
  }
}
