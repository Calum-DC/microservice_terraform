# Module declarations
module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
  oidc_provider = var.oidc_provider
  aws_caller_identity_id = var.aws_caller_identity_id
  queue_1_name = module.sqs.queue_1_name
  queue_2_name = module.sqs.queue_2_name
  queue_3_name = module.sqs.queue_3_name
  queue_1_url = module.sqs.queue_1_url
  queue_2_url = module.sqs.queue_2_url
  queue_3_url = module.sqs.queue_3_url
  }

module "sqs" {
  source = "./modules/sqs"
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.vpc.vpc_id
  private_subnet = module.vpc.private_subnet_ids
  intra_subnet = module.vpc.intra_subnet_ids
  ebs_csi_driver_policy_arn = module.iam.ebs_csi_driver_policy_arn
}
