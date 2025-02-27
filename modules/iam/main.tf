# External DNS Policy
resource "aws_iam_policy" "external_dns_policy" {
  name = "external-dns-policy"
  description = "Grants Route 53 permissions for managing DNS records"
  policy = data.aws_iam_policy_document.external_dns_policy.json
}


data "aws_iam_policy_document" "external_dns_policy" {
  statement {
    actions = ["route53:ChangeResourceRecordSets", "route53:ListResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
}

# EBS CSI Driver Policy
resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name = "ebs-csi-driver-policy"
  description = "Allows managing EBS storage for EKS"
  policy = data.aws_iam_policy_document.ebs_csi_driver_policy.json
}

data "aws_iam_policy_document" "ebs_csi_driver_policy" {
  statement {
    actions = ["ec2:DescribeVolumes", "ec2:CreateVolume", "ec2:AttachVolume", "ec2:DeleteVolume" ]
    resources = ["arn:aws:ec2:*:*:volume/*"]
  }
}

# ECR Access Policy
resource "aws_iam_policy" "ecr_access_policy" {
  name = "ecr_access_policy"
  description = "Grants permissions to pull container images from AWS EC"
  policy = data.aws_iam_policy_document.ecr_access_policy.json
}

data "aws_iam_policy_document" "ecr_access_policy" {
  statement {
    actions = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
    resources = ["*"]
  }
}

# SQS Role Policy
resource "aws_iam_policy" "sqs_access_policy" {
  name = "sqs_access_policy"
  description = "Grant access to SQS queues"
  policy = data.aws_iam_policy_document.sqs_access_policy.json
}

data "aws_iam_policy_document" "sqs_access_policy" {
  statement {
    actions   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
    resources = ["arn:aws:sqs:*:*:queue-name"]
  }
}


# TODO
# Assume role policy ready to be applied to following roles
