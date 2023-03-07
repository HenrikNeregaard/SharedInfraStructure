locals {
  # input
  resource_group_subdomain_name_def = local.resource_names_subdomain.rg

  resource_group_subdomain = azurerm_resource_group.subdomain
}
resource "azurerm_resource_group" "subdomain" {
  location = var.location
  name     = local.resource_group_subdomain_name_def
}

resource "azurerm_role_assignment" "sub_domain_rg_reader" {
  scope                = local.resource_group_subdomain.id
  role_definition_name = "Reader"
  principal_id         = local.ad_sub_domain_owner_group.object_id
}