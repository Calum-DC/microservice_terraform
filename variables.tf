# AWS Region
variable "region" {
  description = "The AWS region where resources will be created"
  default     = "eu-west-2"
}

variable "aws_caller_identity_id" {
  description = "The AWS account ID of the caller"
  type        = string
}

variable "oidc_provider" {
  description = "The OIDC provider URL for the EKS cluster"
  type        = string
}

