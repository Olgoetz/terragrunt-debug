
terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/storage"

}

dependency "encryption" {
  config_path = "../encryption"
}

locals {
  #common_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}//../../common.hcl")

}

inputs = {
    kms_key_alias = dependency.encryption.outputs.kms_key_alias
}