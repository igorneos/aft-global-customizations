module "info_loader" {
  source            = "../info_loader"
  module_identifier = "kms"
  global_args       = var.global_args
  module_args       = var.module_args
  extra_args        = var.extra_args
  tags              = var.tags
  providers = {
    aws = aws.parameter
  }
}
