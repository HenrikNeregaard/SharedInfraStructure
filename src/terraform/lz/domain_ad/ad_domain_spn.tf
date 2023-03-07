locals {
  spn_name   = var.resource_names.spn
  spn_owners = toset(local.ad_domain_owners_flatened)

  spn_domain_application               = azuread_application.domain
  spn_domain_application_password      = azuread_application_password.domain
  spn_domain_serice_principal          = azuread_service_principal.domain
  spn_domain_serice_principal_password = azuread_service_principal_password.domain
}

resource "azuread_application" "domain" {
  display_name = local.spn_name
  owners       = local.spn_owners

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_application_password" "domain" {
  application_object_id = azuread_application.domain.object_id
}

resource "azuread_service_principal" "domain" {
  application_id               = azuread_application.domain.application_id
  owners                       = local.spn_owners
  app_role_assignment_required = false


  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "time_rotating" "service_pricipal_password" {
  rotation_days = 7
}

resource "azuread_service_principal_password" "domain" {
  service_principal_id = azuread_service_principal.domain.id

  rotate_when_changed = {
    rotation = time_rotating.service_pricipal_password.id
  }

  end_date_relative = "${91 * 24}h"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_group_member" "spn_in_domain_data_owner" {
  group_object_id  = local.ad_domain_data_owner_group.id
  member_object_id = local.spn_domain_serice_principal.id
}
