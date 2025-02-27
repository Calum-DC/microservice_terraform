provider "aws" {
    region = "us-east-1"

    default_tags {
      tags = {
        environment = "prod"
        project = "priority"
        cost_tag = "priority"
        managed_by = "Terraform"
      }
    }
}
