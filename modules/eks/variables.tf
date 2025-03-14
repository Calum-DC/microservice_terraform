variable "vpc_id" {
    type = string
    default = ""
}

variable "private_subnet" {
  default = [""]
  type = list(string)
}


variable "intra_subnet" {
  default = [""]
  type = list(string)
}

variable "cluster_name" {
    type = string
    default = "cal-cluster"
}

variable "ebs_csi_driver_policy_arn" {
  description = "ARN of the EBS CSI Driver IAM Policy"
  type        = string
}