variable "environment" {
  default = "dev"
}

variable "domain" {
  description = "The domain of the infrastructure"
  default     = "cross"
}

variable "location" {
  description = "location of data platform."
  default     = "WestEurope"
}

variable "resource_names" {
  type = object({
    admin_log_analytics_workspace = string
    admin_rg                      = string

    vnet_delegation   = string
    vnet              = string
    subnet            = string
    spn               = string
    rg-infrastructure = string
    rg-data           = string
    nsg-dbw           = string
    nsg               = string
    subdomains        = map(object({ index = string }))
    # dbw_metastore           = string
    # storage-unity           = string
    # storage-unity-container = string
    # log_analytics_workspace = string
  })
}