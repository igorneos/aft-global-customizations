data "aws_ssm_parameter" "module_info" {
  name = "/lz/modules/${var.module_identifier}"
}

data "aws_ssm_parameter" "tenant_module_info" {
  #for_each = {
  #  for element in [1] : "a" => "a"
  #  #if lookup(var.global_args,"tenant",null) != null && lookup(var.global_args,"tenant",null) != "global"
  #  if var.tenant != "global"
  #}
  #name = "/lz/${var.global_args.tenant}/modules/${var.module_identifier}"
  name = "/lz${(lookup(var.global_args,"tenant",null) != null && lookup(var.global_args,"tenant",null) != "global") ? "/${var.global_args.tenant}" : ""}/modules/${var.module_identifier}"
}

data "aws_ssm_parameter" "resource_types_short" {
  name = "/lz/resource_types_short"
}