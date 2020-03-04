terraform {
  required_version = ">= 0.12.8"

  backend "s3" {}
}

variable "aws_assume_role_arn" {
  type = "string"
}

provider "aws" {
  version = ">= 2.48.0"
  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}

# since we're explicitly looking for the vpc_id (unique),
# we make assumptions:
# 1. we don't need to filter by tags
# 2. this vpc_id exists and is available
variable "vpc_id" {}

# use data to pull in existing vpc by tag
data "aws_vpc" "selected" {
  id = var.vpc_id
  state = "available"
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id
  tags = { Network = "Public" }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id
  tags = { Network = "Private" }
}