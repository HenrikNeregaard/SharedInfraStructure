import pathlib
path = pathlib.Path(__file__).parent.resolve()

sub_domain_count = 15

index_string = "#####INSERT_INDEX####"
conditional_string = f'contains(keys(var.subdomain_index_to_name), "{index_string}")'

template = f"""
#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain{index_string}
module "subdomain_{index_string}_infra" {{
  count  = {conditional_string} ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["{index_string}"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {{
    azurerm = azurerm
    azuread = azuread
  }}

  depends_on = [
    module.ad,
  ]
}}

provider "databricks" {{
  alias = "subdomain_{index_string}"
  host  = {conditional_string} ? module.subdomain_{index_string}_infra[0].resources.dbw.workspace_url : ""
}}

module "subdomain_{index_string}_app" {{
  count  = {conditional_string} ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["{index_string}"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_{index_string}_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {{
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_{index_string}
    databricks.azure_account = databricks.azure_account
  }}
  depends_on = [
    module.subdomain_{index_string}_infra
  ]
}}
#endregion subdomain{index_string}

"""
template_string = ""
for i in range(sub_domain_count):
    template_string += template.replace(index_string, str(i))
    # print(subdomain_template)
with open(f'{path}/_subdomains.tf', 'w') as f:
    f.write(template_string)
