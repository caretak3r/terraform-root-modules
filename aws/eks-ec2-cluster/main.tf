terraform {
  required_version = ">= 0.12.24"

  backend "s3" {}
}

variable "aws_assume_role_arn" {
  type = "string"
}

provider "aws" {
  region  = var.region
  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}