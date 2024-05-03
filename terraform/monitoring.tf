/*
  Link resource to create the link between the source account and the sink in the monitoring account
*/
resource "aws_oam_link" "cw_link" {
  label_template    = "$AccountName"
  resource_types    = var.monitoring_account_resource_type
  sink_identifier   = data.aws_ssm_parameter.monitoring_sink_arn.value
}
