# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids  
}

output "public_subnet" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids  
}

output "intra_subnet" {
  description = "The IDs of the intra subnets"
  value       = module.vpc.intra_subnet_ids
}

