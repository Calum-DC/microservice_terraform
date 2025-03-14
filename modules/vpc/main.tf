module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = var.vpc_name

  cidr = var.vpc_cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  intra_subnets = var.intra_subnets
  
  enable_nat_gateway = true
  enable_dns_hostnames = true 
  single_nat_gateway = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    cluster_name = "cal-cluster"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    cluster_name = "cal-cluster"
  }

  intra_subnet_tags = {
    Network = "internal"
    cluster_name = "cal-cluster"
  }
  
}

module "security_group_internal" {
  source = "terraform-aws-modules/security-group/aws"

  name = "Internal Security Group"
  description = "Security group to allow all internal communiction within VPC"
  vpc_id = module.aws_vpc.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      type = "ingress"
      from_port = 80
      to_port = 65535
      protocol = "tcp"
      description = "Allow internal HTTP(S) and service communication"
      cidr_blocks = var.vpc_cidr
    },
    {
      type = "ingress"
      from_port = 80
      to_port = 65535
      protocol = "udp"
      description = "Allow internal UDP traffic"
      cidr_blocks = var.vpc_cidr
    },
    {
      type = "ingress"
      from_port = -1 
      to_port = -1  
      protocol = "icmp"
      description = "Allow internal ping traffic"
      cidr_blocks = var.vpc_cidr
    },
  ]
    egress_with_cidr_blocks = [{
    type              = "egress"
    description       = "Allow outbound traffic to the internet"
    from_port         = -1
    to_port           = -1
    protocol          = "all"
    cidr_blocks       = "0.0.0.0/0"
  }]
}
  