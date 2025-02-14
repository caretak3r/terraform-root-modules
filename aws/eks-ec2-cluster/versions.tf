terraform {
  required_version = "~> 0.12.24"

  required_providers {
    aws        = "~> 2.56.0"
    template   = "~> 2.0"
    null       = "~> 2.0"
    local      = "~> 1.3"
    kubernetes = "~> 1.15"
  }
}
