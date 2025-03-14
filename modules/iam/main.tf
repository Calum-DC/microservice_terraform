data "aws_caller_identity" "current" {}


##############################
       # IAM Policies #       
##############################


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


resource "aws_iam_policy" "sqs_access_policy" {
  name        = "sqs_access_policy"
  description = "AWS SQS queues policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:ReceiveMessage",
            "sqs:SendMessage"
          ],
          "Resource" : ["*"]
        }
      ]
    }
  )
}


#DevOps Role
resource "aws_iam_role" "cal_sqs_role" {
  name = "cal_sqs_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_caller_identity_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com",
            "${var.oidc_provider}:sub" = "system:serviceaccount:sqs-microservice:frontend-microservice-application-service-account"
          }
        }
      }
    ]
  })
}

#DevOps Role Attachment
resource "aws_iam_policy_attachment" "cal_sqs_role_attach" {
  name       = "cal_sqs_role_attach"
  roles      = [aws_iam_role.cal_sqs_role.name]
  policy_arn = aws_iam_policy.sqs_access_policy.arn 
}


###########################
       # IAM Roles #       
###########################

module "cal_role_eks_labsnow" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "cal-role-eks-labsnow"

  role_policy_arns = {
    AmazonEKSClusterPolicy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  }

  oidc_providers = {
    one = {
      provider_arn               = "arn:aws:iam::${var.aws_caller_identity_id}:oidc-provider/${var.oidc_provider}"  
      namespace_service_accounts = ["kube-system:cal-eks"]
    }
  }
}


# EBS CSI Driver
resource "aws_iam_role" "cal_ebs_csi_role" {
  name = "cal_ebs_csi_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_caller_identity_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com",
            "${var.oidc_provider}:sub" = "system:serviceaccount:kube-system:cal-ebs-csi"
          }
        }
      }
    ]
  })
}

#############################################
       # IAM Role Policy Attachments #       
#############################################


#EBS CSI Driver attachment
resource "aws_iam_policy_attachment" "cal_ebs_csi_role_attach" {
  name       = "cal_ebs_csi_role_attach"
  roles      = [aws_iam_role.cal_ebs_csi_role.name]
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
}


# External DNS
resource "aws_iam_policy" "external_dns" {
  name        = "cal-external-dns"
  description = "allows externaldns to update route53"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "external_dns_role" {
  name = "cal-external-dns-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_caller_identity_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com",
            "${var.oidc_provider}:sub" = "system:serviceaccount:kube-system:cal-external-dns"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_attachment" {
  policy_arn = aws_iam_policy.external_dns.arn
  role       = aws_iam_role.external_dns_role.name
}


resource "aws_iam_policy" "cal_lb_controller" {
  name        = "cal-lb-controller"
  description = "Custom policy for the AWS Load Balancer Controller"
  policy      = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*",
        "ec2:DescribeSecurityGroups",
        "ec2:CreateSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:CreateTags",
        "ec2:DescribeInstances",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:ModifyInstanceAttribute",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress"
      ],
      "Resource": "*"
    }
  ]
})
}

resource "aws_iam_role" "lb_controller_role" {
  name = "cal-lb-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_caller_identity_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com",
            "${var.oidc_provider}:sub" = "system:serviceaccount:kube-system:cal-lb-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lb_controller_attachment" {
  policy_arn = aws_iam_policy.cal_lb_controller.arn
  role       = aws_iam_role.lb_controller_role.name
}


resource "aws_iam_policy" "ses_iam_policy" {
  name        = "ses_iam_policy"

  policy = jsonencode({
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":["ses:SendEmail","ses:SendRawEmail","ses:SendTemplatedEmail","bedrock-runtime:InvokeModel"
      ],
      "Resource":"*"
    }
  ]
})
}

resource "aws_iam_policy_attachment" "cal_sqs_role_attach_ses_policy" {
  name       = "cal_sqs_role_attach_ses_policy"
  roles      = [aws_iam_role.cal_sqs_role.name]
  policy_arn = aws_iam_policy.ses_iam_policy.arn
}

