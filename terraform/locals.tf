locals {
  tenant = jsondecode(nonsensitive(data.aws_ssm_parameter.tenant.value))
  account_name = jsondecode(nonsensitive(data.aws_ssm_parameter.account_name.value))
  global_info = jsondecode(nonsensitive(data.aws_ssm_parameter.global_info.value))
  structure_organizational_units = jsondecode(nonsensitive(data.aws_ssm_parameter.structure_organizational_units.value))
  organizational_units = jsondecode(nonsensitive(data.aws_ssm_parameter.organizational_units.value))
  default_assingment = jsondecode(nonsensitive(data.aws_ssm_parameter.default_assingment.value))
  additional_assingments = jsondecode(nonsensitive(data.aws_ssm_parameter.additional_assingments.value))
  default_account_permission_set_group_assignment = jsondecode(nonsensitive(data.aws_ssm_parameter.default_account_permission_set_group_assignment.value))
  permission_sets = jsondecode(nonsensitive(data.aws_ssm_parameter.permission_sets.value))
  groups = jsondecode(nonsensitive(data.aws_ssm_parameter.groups.value))
  default_domain = local.global_info.lz_default_domain
  default_project = local.global_info.lz_default_project
  default_cost_center = local.global_info.lz_default_project
  organization_id = local.global_info.lz_organization_id
  terraform_execution_role_name = "${local.default_domain}-${local.default_project}-organization-pro-terraform_execution${local.global_info.is_multi_tenant ? "_${local.tenant}" : ""}"
  deployment_ou_pro_path_aux1 = local.global_info.is_multi_tenant ? local.organizational_units[local.tenant].id : "delete"
  deployment_ou_pro_path_aux2 = local.global_info.is_multi_tenant ? local.organizational_units["${local.tenant}/deployments"].id : local.organizational_units["deployments"].id
  deployment_ou_pro_path_aux3 = local.global_info.is_multi_tenant ? local.organizational_units["${local.tenant}/deployments/production"].id : local.organizational_units["deployments/production"].id
  deployment_ou_pro_path_aux4 = join("/", [
    local.organizational_units.organization.id,
    local.organizational_units.root.id,
    local.deployment_ou_pro_path_aux1,
    local.deployment_ou_pro_path_aux2,
    local.deployment_ou_pro_path_aux3,
    ""
  ])
  deployment_ou_pro_path = replace(local.deployment_ou_pro_path_aux4, "/delete", "")
  aws_global_breakglass = jsondecode(nonsensitive(data.aws_ssm_parameter.aws_global_breakglass.value))
}