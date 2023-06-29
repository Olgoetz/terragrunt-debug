

# Create a random string
resource "random_password" "redis" {
  length  = 16
  upper   = true
  lower   = true
  numeric  = true
  special = true
  override_special = "%@!$"

  keepers = {
    timestamp = time_rotating.redis.rfc3339
  }
}

# Create the token for redis
resource "aws_secretsmanager_secret" "redis" {
  name = "${var.env}/${var.resource_prefix}/redis"
  kms_key_id                 = data.aws_kms_alias.this.target_key_arn
}

resource "aws_secretsmanager_secret_version" "redis" {
  secret_id     = aws_secretsmanager_secret.redis.id
  secret_string = jsonencode({ token = random_password.redis.result })
}

# Enable rotation of the token
resource "time_rotating" "redis" {
  rotation_months = 12
}


# resource "aws_elasticache_subnet_group" "redis" {
#   name       = "${var.resource_prefix}-redis-subnetgroup"
#   subnet_ids = var.private_subnet_ids
# }


# resource "aws_security_group" "redis" {
#   name        = "${var.resource_prefix}-redis-securitygroup"
#   description = "Security group for redis"
#   vpc_id      = var.vpc_id

#   ingress {
#     description = "TFE ingress to redis"
#     from_port   = 6379
#     to_port     = 6379
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }

#   tags = { "Name" = "${var.resource_prefix}-redis-securitygroup" }
# }

# resource "aws_elasticache_replication_group" "tfe" {
#   node_type            = var.node_type
#   replication_group_id = "${var.resource_prefix}-redis"
#   description          = "External Redis for TFE."
#   apply_immediately          = true
#   at_rest_encryption_enabled = true
#   auth_token                 = random_password.redis.result
#   automatic_failover_enabled = var.env == "nonprod" ? false : true
#   multi_az_enabled           = var.env == "nonprod" ? false : true
#   engine                     = "redis"
#   engine_version             = var.redis_engine_version
#   num_cache_clusters         = var.env == "nonprod" ? 1 : length(var.availability_zones)
#   parameter_group_name       = var.redis_parameter_group_name
#   port                       = 6379
#   security_group_ids         = [aws_security_group.redis.id]
#   subnet_group_name          = aws_elasticache_subnet_group.redis.name
#   transit_encryption_enabled = true
#   kms_key_id                 = data.aws_kms_alias.this.target_key_arn
#   tags = var.additional_tags
#   tags                       = { "Dynatrace" = var.enable_dynatrace_monitoring }

# }