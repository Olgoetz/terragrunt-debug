
terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/encryption"
}

# locals {
#   common_vars = read_terragrunt_config("${get_terragrunt_dir()}/../../common.hcl")
# }

# input ={
#   resource_prefix = 
# }