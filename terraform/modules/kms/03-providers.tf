terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.66.1"
      configuration_aliases = [aws.parameter]
    }
  }
}
