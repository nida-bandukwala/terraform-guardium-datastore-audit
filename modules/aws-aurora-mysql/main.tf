
#
# Copyright IBM Corp. 2025
# SPDX-License-Identifier: Apache-2.0
#

locals {
  udc_name        = format("%s-%s-%s", var.aws_region, var.aurora_mysql_cluster_identifier, local.aws_account_id)
  aws_region      = var.aws_region
  aws_account_id  = module.common_aws-configuration.aws_account_id
  log_group       = format("/aws/rds/cluster/%s/audit", var.aurora_mysql_cluster_identifier)
  }

module "common_aws-configuration" {
  source = "IBM/common/guardium//modules/aws-configuration"
}

# Use the dedicated Aurora MySQL CloudWatch registration module
module "common_aurora-mysql-cloudwatch-registration" {
  count  = var.log_export_type == "Cloudwatch" ? 1 : 0
  source = "IBM/common/guardium//modules/aurora-mysql-cloudwatch-registration"

  aws_region                = var.aws_region
  aws_account_id            = local.aws_account_id
  gdp_client_id             = var.gdp_client_id
  gdp_client_secret         = var.gdp_client_secret
  gdp_password              = var.gdp_password
  gdp_username              = var.gdp_username
  gdp_server                = var.gdp_server
  gdp_port                  = var.gdp_port
  gdp_mu_host               = var.gdp_mu_host
  udc_name                  = var.udc_name
  udc_aws_credential        = var.udc_aws_credential
  log_group                 = local.log_group
  enable_universal_connector = var.enable_universal_connector
  csv_start_position        = var.csv_start_position
  csv_interval              = var.csv_interval
  csv_event_filter          = var.csv_event_filter
  codec_pattern             = var.codec_pattern
  cloudwatch_endpoint       = var.cloudwatch_endpoint
  use_aws_bundled_ca        = var.use_aws_bundled_ca
}
