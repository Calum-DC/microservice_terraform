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


# SQS Outputs

output "queue_1_name" {
  description = "Queue 1 Name Output"
  value = module.sqs.queue_1_name
}

output "queue_2_name" {
  description = "Queue 2 Name Output"
  value = module.sqs.queue_2_name
}

output "queue_3_name" {
  description = "Queue 3 Name Output"
  value = module.sqs.queue_3_name
}

output "queue_1_url" {
  description = "Queue 1 Name Output"
  value = module.sqs.queue_1_url
}

output "queue_2_url" {
  description = "Queue 2 Name Output"
  value = module.sqs.queue_2_url
}

output "queue_3_url" {
  description = "Queue 3 Name Output"
  value = module.sqs.queue_3_url
}