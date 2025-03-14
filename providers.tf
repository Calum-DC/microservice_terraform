provider "aws" {
    region = "eu-west-2"

    default_tags {
      tags = {
        environment = "prod"
        project = "priority"
        cost_tag = "priority"
        managed_by = "Terraform"
      }
    }
}
