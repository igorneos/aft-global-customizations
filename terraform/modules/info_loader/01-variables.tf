variable "module_identifier" {
  description = "module_identifier"
  type = string
}

# Common Variables including tenant, domain, project, app, environment
variable "global_args" {
  description = "global_args"
  type = any
}

# Resource variables
variable "module_args" {
  description = "module_args"
  type = any
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
}
