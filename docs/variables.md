## GENERAL
- These variables pass in general data from the calling module, such as the AWS Region and billing tags.


    variable "default_tags" {
      description = "Default billing tags to be applied across all resources"
      type        = "map"
      default     = {
            "BusinessUnit" = "Finance"
            "ManagedBy"    = "Terraform"
            "SquadName"    = "DevOps"
            "Environment"  = "Production"
            "CostCenter"   = "ProjectName"
        }
    }
    
    variable "region" {
      description = "The AWS region for these resources, such as us-east-1."
    }


## TOGGLES
- Toogle to true to create resources

## RESOURCE VALUES
- These variables pass in actual values to configure resources. CIDRs, Instance Sizes, etc.

## RESOURCE REFERENCES
- These variables pass in metadata on other AWS resources, such as ARNs, Names, etc.

## NAMING
- This manages the names of resources in this module.
    
    
    variable "namespace" {
      description = "Namespace, which could be your organization name. First item in naming sequence."
    }
    
    variable "stage" {
      description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`. Second item in naming sequence."
    }
    
    variable "name" {
      description = "Name, which could be the name of your solution or app. Third item in naming sequence."
    }
    
    variable "attributes" {
      type        = "list"
      default     = []
      description = "Additional attributes, e.g. `1`"
    }
    
    variable "convert_case" {
      description = "Convert fields to lower case"
      default     = "true"
    }
    
    variable "delimiter" {
      type        = "string"
      default     = "-"
      description = "Delimiter to be used between (1) `namespace`, (2) `name`, (3) `stage` and (4) `attributes`"
    }

## NAMING PREFIXES
- This manages the naming prefixes in this module.