provider "aws" {
  alias = "management"
  profile = "ct-management"
  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}