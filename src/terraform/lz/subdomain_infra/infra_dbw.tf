locals {
  #   dbwNameDomain              = local.resource_names_subdomain.dbw
  dbwName                    = local.resource_names_subdomain.dbw
  dbwMangedResourceGroupName = local.resource_names_subdomain.dbw_rg

  dbw = azurerm_databricks_workspace.dbw
}

// Used this setup https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/databricks/secure-connectivity-cluster/without-load-balancer/main.tf
// Might consider adding load balancer https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/databricks/secure-connectivity-cluster/with-load-balancer
resource "azurerm_databricks_workspace" "dbw" {
  name                = local.dbwName
  location            = local.resource_group_subdomain.location
  resource_group_name = local.resource_group_subdomain.name
  sku                 = "premium"

  managed_resource_group_name = local.dbwMangedResourceGroupName
  // This should be fixed once private link is enabled
  public_network_access_enabled = true

  custom_parameters {
    no_public_ip             = true
    public_subnet_name       = local.subnet_dbw_public.name
    private_subnet_name      = local.subnet_dbw_private.name
    virtual_network_id       = local.vnet.id
    storage_account_sku_name = "Standard_LRS"

    public_subnet_network_security_group_association_id  = local.nsgs_association_public.id
    private_subnet_network_security_group_association_id = local.nsgs_association_private.id
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "dbw" {
  name                       = local.dbwName
  target_resource_id         = local.dbw.id
  log_analytics_workspace_id = var.shared_infra.log_analytics_workspace.id

  log {
    category_group = "allLogs"
    enabled        = true
    retention_policy {
      enabled = true
      days    = local.logRetentionDays
    }
  }
}
