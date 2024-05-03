variable "monitoring_tenant" {
  description = "Variable corresponding to the tenant for monitoring account."
  type = string
  default = "/lz/tenant1"
}

variable "monitoring_account_resource_type" {
  description = "Variable corresponding to the tenant for monitoring account."
  type = list(string)
  default = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup", "AWS::XRay::Trace"]
}
