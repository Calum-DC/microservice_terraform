output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.aws_vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.aws_vpc.private_subnets
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.aws_vpc.public_subnets
}

output "intra_subnet_ids" {
  description = "The IDs of the intra subnets"
  value       = module.aws_vpc.intra_subnets
}

