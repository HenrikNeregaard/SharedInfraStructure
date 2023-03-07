locals {
  appName     = module.sharedVariables.deploymentPrincipalName
  keyBaseName = "${var.domain}-${var.environment}"

  admins = toset([
    data.azuread_client_config.current.object_id,
    data.azuread_group.dlAdmins.id,
  ])
  identityOwners = toset(concat(
    [data.azuread_client_config.current.object_id],
  data.azuread_group.dlAdmins.members))
}

data "azuread_client_config" "current" {}

data "azuread_group" "dlAdmins" {
  display_name = "AAD_Datalake_admins"
}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  #  use_existing   = true
}

resource "azuread_application" "base" {
  display_name = local.appName
  owners       = local.identityOwners

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.OwnedBy"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Group.Create"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["GroupMember.Read.All"]
      type = "Role"
    }
    #    resource_access {
    #      id   = data.azuread_service_principal.msgraph.app_role_ids["GroupMember.Read.All"]
    #      type = "Role"
    #    }

  }
}

resource "azuread_service_principal" "base" {
  application_id = azuread_application.base.application_id
  owners         = local.identityOwners
}

resource "time_rotating" "service_pricipal_password" {
  rotation_days = 7
}


resource "azuread_service_principal_password" "base" {
  service_principal_id = azuread_service_principal.base.id

  rotate_when_changed = {
    rotation = time_rotating.service_pricipal_password.id
  }

  end_date_relative = "${60 * 24}h"

  lifecycle {
    create_before_destroy = true
  }
}

data "azurerm_subscription" "deploymentSubsciption" {
  subscription_id = var.subscription
}

resource "azurerm_role_assignment" "subscriptionRights" {
  principal_id         = azuread_service_principal.base.object_id
  scope                = data.azurerm_subscription.deploymentSubsciption.id
  role_definition_name = "Contributor"
}
resource "azurerm_role_assignment" "subscriptionAccessRights" {
  principal_id         = azuread_service_principal.base.object_id
  scope                = data.azurerm_subscription.deploymentSubsciption.id
  role_definition_name = "User Access Administrator"
}

