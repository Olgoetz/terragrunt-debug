# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "aws" {
  region = "eu-central-1"
  default_tags {
      tags = merge(var.default_tags, tomap({"global.env" = "Development"}))
    }
}
