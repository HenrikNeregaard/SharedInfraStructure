terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }

}

variable "name" {
  type = string
}

variable "owners" {
  type = list(string)
}


data "azuread_service_principal" "databricks_scim" {
  display_name = "databricks-Unity-catalog-scim"
}

resource "azuread_group" "group" {
  display_name     = var.name
  security_enabled = true
  owners           = var.owners

  lifecycle {
    ignore_changes = [owners, members]
  }
}


resource "azuread_app_role_assignment" "group_unity_catalog" {
  app_role_id         = "a34c49f1-a169-404b-a890-00b3bfdbc1d6"
  principal_object_id = azuread_group.group.object_id
  resource_object_id  = data.azuread_service_principal.databricks_scim.object_id
}

output "group" {
  value = azuread_group.group
}

resource "databricks_group" "unity_replicated_group" {
  display_name = azuread_group.group.display_name
  external_id  = azuread_group.group.object_id
  force        = true
}
