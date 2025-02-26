# Module declarations
module "vpc" {
  source = "./modules/vpc"
}

module "security_group_internal" {
  source = "./modules/vpc"
}