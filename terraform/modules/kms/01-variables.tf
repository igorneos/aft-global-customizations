# Common Variables including tenant, domain, project, app, environment
variable "global_args" {
  description = "global_args"
  type        = any
}

# Resource variables
variable "module_args" {
  description = "module_args"
  type = object({
    name                               = optional(string, null)
    description                        = optional(string, null)
    key_usage                          = optional(string, null)
    custom_key_store_id                = optional(string, null)
    customer_master_key_spec           = optional(string, null)
    policy                             = optional(string, null)
    bypass_policy_lockout_safety_check = optional(bool, null)
    deletion_window_in_days            = optional(number, null)
    is_enabled                         = optional(bool, null)
    enable_key_rotation                = optional(bool, null)
    multi_region                       = optional(bool, null)
    tags                               = optional(map(string), null)
  })
}

# Variable for including extra needed variables
variable "extra_args" {
  description = "extra_args"
  type        = any
  default     = {}
}

# Tags
variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}
