terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

variable "group_display_name" {
  type = string
}
variable "group_member_emails" {
  type = list(string)
}

data "azuread_group" "group" {
  display_name = var.group_display_name
}

data "azuread_user" "members" {
  for_each            = toset(var.group_member_emails)
  user_principal_name = each.key
}

resource "azuread_group_member" "members" {
  for_each         = data.azuread_user.members
  group_object_id  = data.azuread_group.group.object_id
  member_object_id = each.value.object_id
}