data "aws_kms_alias" "this" {
    name = var.kms_key_alias
}