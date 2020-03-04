---
    #
    # This is the canonical configuration for the `README.md`
    # Run `make readme` to rebuild the `README.md`
    #

# Name of this project
name: "terraform-root-modules"

# Tags of this project
tags:
  - terraform
  - terraform-modules
  - aws
  - root

# Categories of this project
categories:
  - terraform-modules/root

# License of this project
license: "APACHE2"

# Canonical GitHub repo
github_repo: "/terraform-root-modules"

references:
  - name: ""
    description: "
    url: ""

related:
  - #todo: put related docs used to formalize this

# Short description of this project
description: |-
  This is a collection of reusable [Terraform "root modules" invocations].

introduction: |-
  The "root modules" form the module catalog of your organization.
  This becomes the model in which devs/ops can self-serve capabilities for themselves.
  This is a _highly opinionated_ implementation.
  An organization will create their own modules and [generic building blocks].

include:
  - "docs/variables.md"
  - "docs/modules.md"

# Contributors to this project
contributors:
  - name: "rgudi"
    github: ""
    email: ""