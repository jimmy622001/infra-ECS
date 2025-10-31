########################################################################################################################
# AWS provider setup
########################################################################################################################

provider "aws" {
  alias      = "main"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.region
}

#############################################################################################
# Terraform remote state S3 setup
########################################################################################################################

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "demo1-terraform-state"
    region = var.region
    key    = "${var.s3_bucket_prefix}/common/terraform-common.tfstate"
  }
}
