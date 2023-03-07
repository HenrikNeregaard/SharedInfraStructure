
variable "environment" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomains_index_to_name" {
  type = map(string)
}

module "naming" {
  source  = "Azure/naming/azurerm"
  suffix  = local.suffix
  version = "0.2.0"
}

module "naming_admin" {
  source  = "Azure/naming/azurerm"
  suffix  = local.suffix_admin
  version = "0.2.0"
}

locals {
  suffix                  = ["dl", var.domain, var.environment]
  suffix_admin            = ["dl", "admin", var.environment]
  baseResourceName        = join("-", local.suffix)
  baseStorageAccountName  = module.naming.storage_account.name
  baseResourceGroupName   = module.naming.resource_group.name
  baseAadGroupName        = "AAD-${local.baseResourceName}"
  baseSpnName             = "SPN-${local.baseResourceName}"
  deploymentPrincipalName = "${local.baseSpnName}-Github"
  aad_admin_group_name    = "AAD_Datalake_admins"


  adf_keyvault_name = "keyVault"

}

