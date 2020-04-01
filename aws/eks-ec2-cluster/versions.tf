terraform {
  required_version = "~> 0.12.0"

  required_providers {
    aws        = "~> 2.28.1"
    template   = "~> 2.0"
    null       = "~> 2.0"
    local      = "~> 1.3"
    kubernetes = "~> 1.15"
  }
}