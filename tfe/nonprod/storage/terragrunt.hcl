include "root" {
  path   = find_in_parent_folders()
  #expose = true
}


include "env" {
  path = "${get_terragrunt_dir()}/../../_env/storage.hcl"
}

inputs = {
  env = "nonprod"
}