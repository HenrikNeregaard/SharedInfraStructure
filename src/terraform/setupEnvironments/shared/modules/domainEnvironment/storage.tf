locals {
  stateName = lower("${var.domain}State")
}

resource "azurerm_role_assignment" "storageReader" {
  principal_id         = azuread_service_principal.base.object_id
  scope                = var.storageAccount.id
  role_definition_name = "Reader"
  provider             = azurerm.admin
}

resource "azurerm_storage_data_lake_gen2_filesystem" "tfstate" {
  name               = local.stateName
  storage_account_id = var.storageAccount.id
  provider           = azurerm.admin
  ace {
    permissions = "rwx"
    type        = "user"
    scope       = "access"
    id          = azuread_service_principal.base.object_id
  }
  ace {
    permissions = "rwx"
    type        = "user"
    scope       = "default"
    id          = azuread_service_principal.base.object_id
  }
  ace {
    permissions = "---"
    scope       = "access"
    type        = "other"
  }
  ace {
    permissions = "---"
    scope       = "default"
    type        = "other"
  }
  ace {
    permissions = "r-x"
    scope       = "access"
    type        = "group"
  }
  ace {
    permissions = "r-x"
    scope       = "default"
    type        = "group"
  }
  ace {
    permissions = "rwx"
    scope       = "access"
    type        = "mask"
  }
  ace {
    permissions = "rwx"
    scope       = "access"
    type        = "user"
  }
  ace {
    permissions = "rwx"
    scope       = "default"
    type        = "mask"
  }
  ace {
    permissions = "rwx"
    scope       = "default"
    type        = "user"
  }
}