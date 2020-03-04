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

module "origin_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.4.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, ["origin"]))
  tags       = var.tags
}

resource "aws_s3_bucket" "origin" {
  bucket        = var.bucket_name
  acl           = var.bucket_acl
  force_destroy = var.origin_force_destroy
  tags          = module.origin_label.tags

//  provisioner "local-exec" {
//    #command = "aws s3 cp image.png s3://${aws_s3_bucket.images.bucket} --acl=public-read"
//    command = "aws s3 cp image.png s3://${aws_s3_bucket.origin.bucket}"
//  }

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    enabled = var.lifecycle_rule_enabled
    tags = module.origin_label.tags
    prefix = var.prefix

    abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days

    expiration {
      expired_object_delete_marker = var.expired_object_delete_marker_enabled
    }

    noncurrent_version_transition {
        days          = 90
        storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
        days          = 180
        storage_class = "ONEZONE_IA"
    }

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.origin.id

  dynamic "access_blocks" {
    for_each = length(keys(var.access_blocks)) == 0 ? [] : [
      var.access_blocks]
    content {
      block_public_acls = lookup(access_blocks.value, "block_public_acls", true)
      ignore_public_acls = lookup(access_blocks.value, "ignore_public_acls", true)
      block_public_policy = lookup(access_blocks.value, "block_public_policy", true)
      restrict_public_buckets = lookup(access_blocks.value, "restrict_public_buckets", true)
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-cloudfront-bucket"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = var.default_root_object
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  aliases             = var.aliases
  wait_for_deployment = var.wait_for_deployment
  tags                = var.tags

  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = var.s3_origin_id
    origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # todo: should use your own certs
  //  viewer_certificate {
  //    acm_certificate_arn            = var.acm_certificate_arn
  //    ssl_support_method             = "sni-only"
  //    minimum_protocol_version       = var.minimum_protocol_version
  //    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
  //  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # todo: add a logging bucket
  # To use a bucket from a different AWS account, enter the bucket name in the format bucket-name.s3.amazonaws.com
  //  logging_config {
  //    include_cookies = true
  //    bucket          = "${aws_s3_bucket.images_logs.bucket_domain_name}"
  //    prefix          = ""
  //  }

  # todo: this requires a route53 zone + cert
  #aliases = ["${var.subdomain}.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.s3_origin_id
    compress         = var.compress

    forwarded_values {
      query_string = var.forward_query_string
      headers      = var.forward_header_values

      cookies {
        forward = var.forward_cookies
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    default_ttl            = var.default_ttl
    min_ttl                = var.min_ttl
    max_ttl                = var.max_ttl
  }
}

data "aws_iam_policy_document" "app" {

  statement {
    sid = "AWSS3TopLevelPolicy"
    effect = "Allow"
    actions = ["S3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid = "AWSS3BasePolicy"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }

  statement {
    sid = "AWSS3ObjectPolicy"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
    ]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
}

resource "aws_iam_user" "app" {
  name = "${var.name}-${var.stage}-user"
  tags = module.origin_label.tags
}

resource "aws_iam_access_key" "app-access-key" {
  user = aws_iam_user.app.name
}

resource "aws_iam_user_policy" "app" {
  name = "${var.name}-${var.stage}-policy"
  user = aws_iam_user.app.name
  policy = data.aws_iam_policy_document.app.json
}

data "aws_iam_policy_document" "origin" {

  statement {
    sid = "S3GetObjectForCloudFront"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
        aws_iam_user.app.arn
      ]
    }
  }

  statement {
    sid = "S3ListBucketForCloudFront"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
    principals {
      type        = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
        aws_iam_user.app.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = aws_s3_bucket.origin.id
  policy = data.aws_iam_policy_document.origin.json
}