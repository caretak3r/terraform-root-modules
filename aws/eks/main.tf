terraform {
  required_version = ">= 0.12.8"

  backend "s3" {}
}

variable "aws_assume_role_arn" {
  type = "string"
}

provider "aws" {
  version = ">= 2.48.0"
  region  = var.region
  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}