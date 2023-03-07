terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

locals {
  domain = {
    id   = "5f9d0b1f-bd50-4b00-8695-58e65969cffa"
    name = "dbw-dl-em-prd"
  }
}

variable "name" {
  type = string
}
variable "storage_url" {
  type = string
}

output "dbw_metastore" {
  value = local.domain
}