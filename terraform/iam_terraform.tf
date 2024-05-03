data "aws_iam_policy_document" "assume_role" {
  policy_id = "assume_role"
  statement {
    sid = "1"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values = [local.deployment_ou_pro_path]
    }
    condition {
      test = "StringLike"
      variable = "aws:PrincipalArn"
      values = ["*AWSReservedSSO_terraform_*"]
    }
  }
}

resource "aws_iam_role" "terraform_execution" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description = "Role for executing terraform in the account"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  name = local.terraform_execution_role_name
  tags = {
		Name = local.terraform_execution_role_name,
    description = "Role for executing terraform in the account",
		resource_type = "iam",
		resource_subtype = "role",
    tenant = local.tenant,
    domain = local.default_domain,
    project = local.default_project,
    app = "organization",
    criticality = "high",
    cost_center = local.default_cost_center,
    "aws_custom:organization_id" = local.organization_id,
    "aws_custom:environment" = "pro",
    "aws_custom:account_name" = local.account_name,
    "aws_custom:account_id" = data.aws_caller_identity.default.account_id,
    "aws_custom:region" = data.aws_region.default.name,
	}
}