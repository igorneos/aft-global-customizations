data "aws_iam_policy_document" "breakglass_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_global_breakglass["id"]}:user/emergency_user${local.global_info.is_multi_tenant ? "_${local.tenant}" : ""}"]
    }
  }
}

resource "aws_iam_role" "breakglass_assume_role" {
  name                = "RoleForEmergencyBreakglassAccess"
  assume_role_policy  = data.aws_iam_policy_document.breakglass_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}