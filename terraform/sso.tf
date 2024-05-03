module "sso_account_assignments" {
  source = "./modules/sso_account_assignments"
  global_args = {}
  module_args = {
    instance_arn = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
    accounts = {
        # TODO quitar el replace de la siguiente linea, solo esta asi por un problema en el entorno de prueba
        "${replace(local.account_name, "tf_", "")}" = {
            id = data.aws_caller_identity.default.account_id
            default_assingment = local.default_assingment
            additional_assingments = local.additional_assingments
        }
    }
    default_account_permission_set_group_assignment = local.default_account_permission_set_group_assignment
    is_multi_tenant = local.global_info.is_multi_tenant
    permission_sets = local.permission_sets
    groups = local.groups
  }
  providers = {
    aws = aws.management
  }
}