# Crear KMS key primaria
resource "aws_kms_key" "key" {
  description                        = local.args.description
  key_usage                          = local.args.key_usage
  custom_key_store_id                = local.args.custom_key_store_id
  customer_master_key_spec           = local.args.customer_master_key_spec
  policy                             = local.args.policy
  bypass_policy_lockout_safety_check = local.args.bypass_policy_lockout_safety_check
  deletion_window_in_days            = local.args.deletion_window_in_days
  is_enabled                         = local.args.is_enabled
  enable_key_rotation                = local.args.enable_key_rotation
  multi_region                       = local.args.multi_region
  tags                               = local.tags
}

# Nombre para la KMS key
resource "aws_kms_alias" "alias" {
  depends_on = [aws_kms_key.key]

  name          = "alias/${local.args.name}"
  target_key_id = aws_kms_key.key.key_id
}
