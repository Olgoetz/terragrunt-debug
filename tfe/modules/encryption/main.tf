data "aws_caller_identity" "current" {}
data "aws_region" "current" {}




########## KMS KEY ##########


resource "aws_kms_key" "tfe" {
  description             = "KMS key for tfe prod resources"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.tfe.json
}

resource "aws_kms_alias" "tfe" {
  name          = "alias/${var.resource_prefix}-${var.env}"
  target_key_id = aws_kms_key.tfe.key_id
}

data "aws_iam_roles" "sso_admin" {
  name_regex  = "AWSReservedSSO_AdministratorAccess*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

locals {
  tfe_workspace_env = {
    "nonprod" = "dev"
    "prod"    = "prod"
  }
}

data "aws_iam_policy_document" "tfe" {

  # Only root has full access to key
  statement {
    sid    = "Enable root access"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalType"
      values   = ["Account"]
    }
  }

  # Allow management of key
  statement {
    sid    = "Enable IAM user/role permission"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = compact([var.env == "nonprod" ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/tfe_${var.env}_deployer" : "",
        tolist(data.aws_iam_roles.sso_admin.arns)[0],
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/merlot.eu-central-1-tfe-docker-${var.env}-ago-fr-openpaas-tfe-agent", # Credential rotator
        "arn:aws:iam::184614415019:root"                                                                                                        # Cross account backup
      ])
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Decrypt",
      "kms:Encrypt",
    "kms:GenerateDataKey"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

}




# # CLOUDWATCH
# statement {
#     sid="Allow CloudWatch for CMK"
#     effect = "Allow"
#     principals {
#         type = "Service"
#         identifiers = ["cloudwatch.amazonaws.com"]
#     }
#     actions= ["kms:Deycrypt", "kms:GenerateDataKey"]
#     resources = ["*"]
#     condition {
#         test     = "ArnEquals"
#         variable = "aws:SourceArn"
#         values   = ["arn:aws:cloudwatch:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
#     }
#     condition {
#         test     = "StringLike"
#         variable = "kms:EncryptionContext:aws:cloudwatch:arn"
#         values   = ["arn:aws:cloudwatch:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
#     }
# }





# {
#     "Version": "2012-10-17",
#     "Id": "key_default_1",
#     "Statement": [
#         {
#             "Sid": "Enable IAM User Permissions",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::037638919006:root"
#             },
#             "Action": "kms:*",
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow_CloudWatch_for_CMK",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "cloudwatch.amazonaws.com"
#             },
#             "Action": [
#                 "kms:Decrypt",
#                 "kms:GenerateDataKey"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow_EC2_for_CMK",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "ec2.amazonaws.com"
#             },
#             "Action": [
#                 "kms:Decrypt",
#                 "kms:GenerateDataKey"
#             ],
#             "Resource": "*"
#         },
# {
#     "Sid": "Allow_BACKUP_for_CMK",
#     "Effect": "Allow",
#     "Principal": {
#         "Service": "backup.amazonaws.com"
#     },
#     "Action": [
#         "kms:Decrypt",
#         "kms:GenerateDataKey",
#         "kms:CreateGrant",
#         "kms:RetireGrant",
#         "kms:DescribeKey"
#     ],
#     "Resource": "*"
# },
# {
#     "Sid": "Allow access for backup account",
#     "Effect": "Allow",
#     "Principal": {
#         "AWS": "arn:aws:iam::064484589831:root"
#     },
#     "Action": [
#         "kms:DescribeKey",
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey",
#         "kms:GenerateDataKeyWithoutPlaintext",
#         "kms:CreateGrant",
#         "kms:ListGrants",
#         "kms:RevokeGrant"
#     ],
#     "Resource": "*"
# },
# {
#     "Sid": "Allow service-linked role use of the customer managed key",
#     "Effect": "Allow",
#     "Principal": {
#         "AWS": "arn:aws:iam::037638919006:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
#     },
#     "Action": [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#     ],
#     "Resource": "*"
# },
#         {
#             "Sid": "Allow attachment of persistent resources",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::037638919006:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
#             },
#             "Action": "kms:CreateGrant",
#             "Resource": "*",
#             "Condition": {
#                 "Bool": {
#                     "kms:GrantIsForAWSResource": "true"
#                 }
#             }
#         }
#     ]
# }