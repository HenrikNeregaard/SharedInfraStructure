
resource "azurerm_storage_data_lake_gen2_filesystem" "containers" {
  for_each           = toset(var.containers)
  name               = each.key
  storage_account_id = azurerm_storage_account.base.id

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
