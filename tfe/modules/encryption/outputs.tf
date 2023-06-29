output "kms_key_alias" {
  value       = aws_kms_alias.tfe.name
  description = "Full KMS key alias"
}

output "kms_key_arn" {
  value       = aws_kms_alias.tfe.arn
  description = "KMS key arn"
}
