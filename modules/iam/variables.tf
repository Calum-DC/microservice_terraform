variable "aws_caller_identity_id" {
  description = "The AWS account ID of the caller"
  type        = string
}

variable "oidc_provider" {
  description = "The OIDC provider URL for the EKS cluster"
  type        = string
}

variable "queue_1_name" {
  description = "SQS Queue 1"
  type        = string
}

variable "queue_2_name" {
  description = "SQS Queue 1"
  type        = string
}

variable "queue_3_name" {
  description = "SQS Queue 1"
  type        = string
}


variable "queue_1_url" {
  description = "Queue 1 Name Output"
  type =  string
}

variable "queue_2_url" {
  description = "Queue 2 Name Output"
  type =  string
}

variable "queue_3_url" {
  description = "Queue 3 Name Output"
  type =  string
}
