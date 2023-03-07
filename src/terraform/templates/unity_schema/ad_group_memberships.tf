# locals {
#   ad_reader_names_always = [
#     module.sharedVariables.ad_domain_owner,
#   ]
#   ad_reader_membership_names = var.grant_domain_access ? [for subdomain in module.sharedVariables.subdomains : subdomain.ad_group_owner] : []
# }

# data "azuread_group" "readers" {
#   for_each     = toset(concat(local.ad_reader_membership_names, local.ad_reader_names_always))
#   display_name = each.key
# }

resource "azuread_group_member" "reader_members" {
  for_each         = toset(var.reader_group_member_object_ids)
  group_object_id  = local.ad_group_reader.id
  member_object_id = each.value
}

