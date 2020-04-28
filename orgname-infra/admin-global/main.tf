data "aws_caller_identity" "current" {}

#
# Logs
#

module "logs" {
  source  = "trussworks/logs/aws"
  version = "~> 8.0.0"

  default_allow = false
  allow_config  = true

  region         = var.region
  s3_bucket_name = var.logging_bucket
}

#
# Config
#

module "config" {
  source  = "trussworks/config/aws"
  version = "~> 2.5"

  config_name        = format("%s-config-%s", data.aws_iam_account_alias.current.account_alias, var.region)
  config_logs_bucket = module.logs.aws_logs_bucket

  aggregate_organization = true

  check_cloud_trail_encryption          = true
  check_cloud_trail_log_file_validation = true
  check_multi_region_cloud_trail        = true
}

#
# GuardDuty
#

resource "aws_guardduty_detector" "member" {
  enable = true
}

resource "aws_guardduty_invite_accepter" "member" {
  detector_id       = aws_guardduty_detector.member.id
  master_account_id = var.account_id_org_root
}

# This module allows the users from the id account to assume the infra
# role in this account. See the README for more details at
# https://github.com/trussworks/terraform-aws-iam-cross-acct-dest
module "infra_role" {
  source  = "trussworks/iam-cross-acct-dest/aws"
  version = "1.0.3"

  iam_role_name     = "infra"
  source_account_id = var.account_id_id
}

resource "aws_iam_role_policy_attachment" "infra_role_policy" {
  role       = module.infra_role.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}