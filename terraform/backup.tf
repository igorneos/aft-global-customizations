# Fetches information about the AWS Organization
data "aws_organizations_organization" "org" {}

# Define local variable for organization id
locals {
  org_id = data.aws_organizations_organization.org.id
}

# Create an AWS IAM role for backup operations
resource "aws_iam_role" "backup_lz_iam_role" {
  name = "AWSBackupLZ"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "backup.amazonaws.com"
        }
      },
    ]
  })
}

# Create kms policy for cross account backup
data "aws_iam_policy_document" "kms_policy" {
  version = "2012-10-17"

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [local.org_id]
    }
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:CancelKeyDeletion",
      "kms:Create*",
      "kms:Delete*",
      "kms:Describe*",
      "kms:Disable*",
      "kms:Enable*",
      "kms:Get*",
      "kms:List*",
      "kms:Put*",
      "kms:Revoke*",
      "kms:ScheduleKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Update*"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [local.org_id]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [local.org_id]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [local.org_id]
    }
  }
}

# Create an AWS KMS key for cross-account backup
module "kms" {
  source = "./modules/kms"
  providers = {
    aws           = aws
    aws.parameter = aws.management
  }
  global_args = {}
  module_args = {
    description             = "KMS Key for cross account backup"
    key_usage               = "ENCRYPT_DECRYPT"
    policy                  = data.aws_iam_policy_document.kms_policy.json
    deletion_window_in_days = 30
    is_enabled              = true
    enable_key_rotation     = true
    multi_region            = true
  }
  extra_args = {
    identifier = "backup"
  }
}

# Create AWS backup vaults
resource "aws_backup_vault" "main_vault" {
  name        = "Main_Vault"
  kms_key_arn = module.kms.arn
}

# Define IAM policy document for the backup vaults
data "aws_iam_policy_document" "vault_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "backup:CopyIntoBackupVault"
    ]
    resources = ["*"]
  }
}

# Define IAM policy document for the backup vaults
resource "aws_backup_vault_policy" "backup_vault_policy" {
  backup_vault_name = aws_backup_vault.main_vault.name
  policy            = data.aws_iam_policy_document.vault_policy_document.json
}

# Configure backup region settings
resource "aws_backup_region_settings" "backup_region_settings" {
  resource_type_opt_in_preference = {
    "Aurora"                 = true
    "DocumentDB"             = true
    "DynamoDB"               = true
    "CloudFormation"         = true
    "EBS"                    = true
    "EC2"                    = true
    "EFS"                    = true
    "FSx"                    = true
    "Neptune"                = true
    "RDS"                    = true
    "Redshift"               = false
    "S3"                     = true
    "SAP HANA on Amazon EC2" = false
    "Storage Gateway"        = false
    "Timestream"             = false
    "VirtualMachine"         = true
  }

  resource_type_management_preference = {
    "DynamoDB" = true
    "EFS"      = true
  }
}