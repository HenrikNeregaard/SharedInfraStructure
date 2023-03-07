resource "azuread_application" "sub_domain" {
  for_each     = var.resource_names.subdomains
  display_name = each.value.spn
  owners       = local.spn_owners

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_service_principal" "sub_domain" {
  for_each       = var.resource_names.subdomains
  application_id = azuread_application.sub_domain[each.key].application_id
  owners         = local.spn_owners

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}

resource "azuread_service_principal_password" "sub_domain" {
  for_each             = var.resource_names.subdomains
  service_principal_id = azuread_service_principal.sub_domain[each.key].id

  rotate_when_changed = {
    rotation = time_rotating.service_pricipal_password.id
  }

  end_date_relative = "${91 * 24}h"

  lifecycle {
    create_before_destroy = true
  }
}
