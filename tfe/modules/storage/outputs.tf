##### REDIS #####

output "redis_token_expiration" {
    value = time_rotating.redis.rotation_rfc3339
    description = "The token will be rotated at this date when executing terragrunt."
}


# output "redis_replication_group_arn" {
#     value = aws_elasticache_replication_group.redis.arn
#     description = "ARN of the Redis repication group."
# }


##### RDS #####