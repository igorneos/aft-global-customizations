# Common Variables including tenant, domain, project, app, environment
variable "global_args" {
  description = "global_args"
  type = any
}

# Resource variables including variables indicated here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy#argument-reference
variable "module_args" {
  description = "module_args"
  type = object({
    instance_arn = string
    accounts = any
    default_account_permission_set_group_assignment = any
    is_multi_tenant = bool
    permission_sets = any
    groups = any
  })
}

# Variable for including extra needed variables
variable "extra_args" {
  description = "extra_args"
  type = any
  default = {}
}

# Tags
variable "tags" {
  description = "Resource tags"
  type = map(any)
  default = {}
}
