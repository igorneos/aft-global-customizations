data "aws_caller_identity" "default" {}
data "aws_region" "default" {}

data "aws_ssm_parameter" "tenant" {
  name = "/aft/account-request/custom-fields/tenant"
}

data "aws_ssm_parameter" "account_name" {
  name = "/aft/account-request/custom-fields/account_name"
}

data "aws_ssm_parameter" "default_assingment" {
  name = "/aft/account-request/custom-fields/default_assingment"
}

data "aws_ssm_parameter" "additional_assingments" {
  name = "/aft/account-request/custom-fields/additional_assingments"
}

data "aws_ssm_parameter" "global_info" {
  provider = aws.management 
  name = "/lz/global_info"
}

data "aws_ssm_parameter" "structure_organizational_units" {
  provider = aws.management 
  name = "/lz/structure_organizational_units"
}

data "aws_ssm_parameter" "organizational_units" {
  provider = aws.management 
  name = "/lz/organizational_units"
}

data "aws_ssm_parameter" "default_account_permission_set_group_assignment" {
  provider = aws.management 
  name = "/lz/default_account_permission_set_group_assignment"
}

data "aws_ssm_parameter" "permission_sets" {
  provider = aws.management 
  name = "/lz/permission_sets"
}

data "aws_ssm_parameter" "groups" {
  provider = aws.management 
  name = "/lz/groups"
}

data "aws_ssoadmin_instances" "sso" {
  provider = aws.management 
}

/*
  SSM parameter data block retrieves the CloudWatch Cross Account Observability Sink ARN from the parameter store,
  So that the Sink arn can be associated with the source account while creating the Link
*/
data "aws_ssm_parameter" "monitoring_sink_arn" {
  provider = aws.management
  name     = "${var.monitoring_tenant}/modules/monitoring_account_sink_arn"
}

data "aws_ssm_parameter" "aws_global_breakglass" {
  provider = aws.management 
  name     = "/lz/accounts/aws-global-breakglass"
}
