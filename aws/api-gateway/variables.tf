variable "namespace" {
  description = "Namespace (e.g. `eg` or `cp`)"
  type        = string
  default     = ""
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name  (e.g. `bastion` or `app`)"
  type        = string
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "enabled" {
  type        = bool
  default     = true
}

####################
# VPC
####################
variable vpc_cidr {
  description = "VPC CIDR"
}

variable igw_cidr {
  description = "VPC Internet Gateway CIDR"
}

variable public_subnets_cidr {
  description = "Public Subnets CIDR"
  type        = "list"
}

variable private_subnets_cidr {
  description = "Private Subnets CIDR"
  type        = "list"
}

variable nat_cidr {
  description = "VPC NAT Gateway CIDR"
  type        = "list"
}

variable azs {
  description = "VPC Availability Zones"
  type        = "list"
}

####################
# Lambda
####################
variable "lambda_runtime" {
  description = "Lambda Function runtime"
}

variable "lambda_zip_path" {
  description = "Lambda Function Zipfile local path for S3 Upload"
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "HttpServer"
}

variable "lambda_handler" {
  description = "Lambda Function Handler"
}

variable "lambda_memory" {
  description = "Lambda memory size, 128 MB to 3,008 MB, in 64 MB increments"
  default = "128"
}

variable "lambda_arn" {
  description = "The lambda arn to invoke"
}

####################
# API Gateway
####################

variable "account_id" {
  description = "Account ID needed to construct ARN to allow API Gateway to invoke lambda function"
}