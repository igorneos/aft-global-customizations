locals {
  resource_types_short = jsondecode(data.aws_ssm_parameter.resource_types_short.value)
  global_args = merge(
    var.global_args,
    {
      resource_type_short = lookup(local.resource_types_short, var.module_identifier, "tbd")
    }
  )
  module_args = {
    for key, value in var.module_args : key => value
    if value != null
  }
  module_info = jsondecode(data.aws_ssm_parameter.module_info.value)
  tenant_module_info = jsondecode(data.aws_ssm_parameter.tenant_module_info.value)
  merged_info = merge(
    local.module_info,
    local.tenant_module_info
  )
  default_args_aux = merge(
    local.module_info.default_args,
    lookup(local.tenant_module_info, "default_args", {})
  )
  default_args = {
    for key, value in local.default_args_aux : key => value
    if value != "null"
  }
  default_tags_aux = merge(
    local.module_info.default_tags,
    lookup(local.tenant_module_info, "default_tags", {})
  )
  final_args_aux = merge(
    local.default_args,
    local.module_args
  )
  name_field_aux = local.default_tags_aux.Name
  is_name_from_args = startswith(local.name_field_aux, "#ARG_")
  name_field = local.is_name_from_args ? replace(local.name_field_aux, "#ARG_", "") : null
  default_name_map = split("-", local.is_name_from_args ? local.final_args_aux[local.name_field] : local.merged_info.name)
  default_name_map_aux = [
    for element in local.default_name_map : lookup(local.global_args, lower(replace(element, "#", "")), lookup(var.extra_args, lower(replace(element, "#", "")), ""))
  ]
  default_name = join("-", compact(local.default_name_map_aux))
  module_args_without_name = {
    for key, value in local.module_args : key => value
    if key != local.name_field
  }
  final_args = merge(
    local.default_args,
    local.module_args,
    local.is_name_from_args && !lookup(var.extra_args, "overwrite_name", false) ? {
      "${local.name_field}" = local.default_name
    } : {}
    #local.is_name_from_args ? {
    #  "${local.name_field}" = local.default_name
    #} : {},
    #lookup(var.extra_args, "overwrite_name", false) ? local.module_args : merge(
    #  local.module_args_without_name,
    #  local.is_name_from_args ? {
    #    "${local.name_field}" = local.default_name
    #  } : {},
    #)
  )
  default_tags = {
    for key, value in local.default_tags_aux : key => startswith(value, "#ARG_") ? local.final_args[replace(value, "#ARG_", "")] : (startswith(value, "#EXTRAARG_") ? var.extra_args[replace(value, "#EXTRAARG_", "")] : (startswith(value, "#NAME") ? local.default_name : value))
  }
  final_tags = merge(
    local.default_tags,
    var.tags
  )
}
