module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = var.vpc_name
  cidr = var.vpc_cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  intra_subnets = var.intra_subnets
  enable_nat_gateway = false
  enable_dns_hostnames = true 

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  intra_subnet_tags = {
    Network = "internal"
  }
  
}

module "security_group_internal" {
  source = "terraform-aws-modules/security-group/aws"

  name = "Internal Security Group"
  description = "Security group to allow all internal communiction within VPC"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port = 80
      to_port = 65535
      protocol = "tcp"
      description = "Allow internal HTTP(S) and service communication"
      cidr_blocks = var.vpc_cidr
    },
    {
      from_port = 80
      to_port = 65535
      protocol = "udp"
      description = "Allow internal UDP traffic"
      cidr_blocks = var.vpc_cidr
    },
    {
      from_port = -1 
      to_port = -1  
      protocol = "icmp"
      description = "Allow internal ICMP (ping) traffic"
      cidr_blocks = var.vpc_cidr
    },
  ]
}
  