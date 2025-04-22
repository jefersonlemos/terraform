provider "aws" {
  default_tags {
    tags = {
      Name        = local.full_name
      Environment = var.environment
      Terraform   = "true"
      CreatedBy   = "Terraform"
    }
  }
}
