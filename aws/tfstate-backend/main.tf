terraform {
  required_version = "~> 0.12.24"
  required_providers {
    aws        = "~> 2.56.0"
    template   = "~> 2.0"
    null       = "~> 2.0"
    local      = "~> 1.3"
  }  
}

variable "aws_assume_role_arn" {}

provider "aws" {
  assume_role {
    role_arn = var.aws_assume_role_arn
    region = var.region
  }
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = string
  description = "Application or solution name (e.g. `app`)"
  default     = "terraform"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = ["state"]
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "region" {
  type        = string
  description = "AWS Region the S3 bucket should reside in"
  default     = "us-east-1"
}

variable "force_destroy" {
  type        = string
  description = "A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable."
  default     = false
}

module "tfstate_backend" {
  source        = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.15.0"
  namespace     = var.namespace
  name          = var.name
  stage         = var.stage
  attributes    = var.attributes
  tags          = var.tags
  region        = var.region
  force_destroy = var.force_destroy
}
