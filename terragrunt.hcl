remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "terraform-states-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}.tfstate"
    kms_key_id     = "arn:aws:kms:eu-central-1:${get_aws_account_id()}:key/deec04b3-0137-4d37-b436-eb06984c5b03"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = merge(var.default_tags, tomap({"global.env" = "Development"}))
  }
}
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      version = ">= 4.0.0"
      source  = "hashicorp/aws"
    }
    archive = {
      version = ">= 2.2.0"
      source  = "hashicorp/archive"
    }
    random = {
      version = ">= 3.2.0"
      source  = "hashicorp/random"
    }
  }

}

EOF

}




locals {
  env                  = "nonprod"
  vpc_cidr             = "100.73.25.128/26"
  sns_email_recipients = ["oliver.goetz@axa.com"]
  proxy_address        = "10.174.202.43:8082"
  no_proxy_domains     = ".axa-cloud.com,.axa.com"
}

terraform {
  extra_arguments "common_var" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_parent_terragrunt_dir("root")}/..//common//tags.tfvars",

    ]
  }

  # after_hook "tfsec" {
  #   commands     = ["init"]
  #   execute      = ["bash", "${get_parent_terragrunt_dir("root")}/..//scripts/tfsec.sh", "${get_terraform_command()}"]
  #   run_on_error = true
  # }

}
