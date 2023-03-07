
#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain0
module "subdomain_0_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "0") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["0"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_0"
  host  = contains(keys(var.subdomain_index_to_name), "0") ? module.subdomain_0_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_0_app" {
  count  = contains(keys(var.subdomain_index_to_name), "0") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["0"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_0_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_0
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_0_infra
  ]
}
#endregion subdomain0


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain1
module "subdomain_1_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "1") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["1"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_1"
  host  = contains(keys(var.subdomain_index_to_name), "1") ? module.subdomain_1_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_1_app" {
  count  = contains(keys(var.subdomain_index_to_name), "1") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["1"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_1_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_1
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_1_infra
  ]
}
#endregion subdomain1


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain2
module "subdomain_2_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "2") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["2"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_2"
  host  = contains(keys(var.subdomain_index_to_name), "2") ? module.subdomain_2_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_2_app" {
  count  = contains(keys(var.subdomain_index_to_name), "2") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["2"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_2_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_2
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_2_infra
  ]
}
#endregion subdomain2


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain3
module "subdomain_3_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "3") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["3"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_3"
  host  = contains(keys(var.subdomain_index_to_name), "3") ? module.subdomain_3_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_3_app" {
  count  = contains(keys(var.subdomain_index_to_name), "3") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["3"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_3_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_3
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_3_infra
  ]
}
#endregion subdomain3


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain4
module "subdomain_4_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "4") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["4"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_4"
  host  = contains(keys(var.subdomain_index_to_name), "4") ? module.subdomain_4_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_4_app" {
  count  = contains(keys(var.subdomain_index_to_name), "4") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["4"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_4_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_4
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_4_infra
  ]
}
#endregion subdomain4


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain5
module "subdomain_5_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "5") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["5"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_5"
  host  = contains(keys(var.subdomain_index_to_name), "5") ? module.subdomain_5_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_5_app" {
  count  = contains(keys(var.subdomain_index_to_name), "5") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["5"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_5_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_5
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_5_infra
  ]
}
#endregion subdomain5


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain6
module "subdomain_6_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "6") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["6"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_6"
  host  = contains(keys(var.subdomain_index_to_name), "6") ? module.subdomain_6_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_6_app" {
  count  = contains(keys(var.subdomain_index_to_name), "6") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["6"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_6_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_6
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_6_infra
  ]
}
#endregion subdomain6


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain7
module "subdomain_7_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "7") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["7"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_7"
  host  = contains(keys(var.subdomain_index_to_name), "7") ? module.subdomain_7_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_7_app" {
  count  = contains(keys(var.subdomain_index_to_name), "7") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["7"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_7_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_7
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_7_infra
  ]
}
#endregion subdomain7


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain8
module "subdomain_8_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "8") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["8"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_8"
  host  = contains(keys(var.subdomain_index_to_name), "8") ? module.subdomain_8_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_8_app" {
  count  = contains(keys(var.subdomain_index_to_name), "8") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["8"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_8_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_8
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_8_infra
  ]
}
#endregion subdomain8


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain9
module "subdomain_9_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "9") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["9"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_9"
  host  = contains(keys(var.subdomain_index_to_name), "9") ? module.subdomain_9_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_9_app" {
  count  = contains(keys(var.subdomain_index_to_name), "9") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["9"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_9_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_9
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_9_infra
  ]
}
#endregion subdomain9


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain10
module "subdomain_10_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "10") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["10"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_10"
  host  = contains(keys(var.subdomain_index_to_name), "10") ? module.subdomain_10_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_10_app" {
  count  = contains(keys(var.subdomain_index_to_name), "10") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["10"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_10_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_10
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_10_infra
  ]
}
#endregion subdomain10


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain11
module "subdomain_11_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "11") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["11"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_11"
  host  = contains(keys(var.subdomain_index_to_name), "11") ? module.subdomain_11_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_11_app" {
  count  = contains(keys(var.subdomain_index_to_name), "11") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["11"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_11_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_11
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_11_infra
  ]
}
#endregion subdomain11


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain12
module "subdomain_12_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "12") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["12"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_12"
  host  = contains(keys(var.subdomain_index_to_name), "12") ? module.subdomain_12_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_12_app" {
  count  = contains(keys(var.subdomain_index_to_name), "12") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["12"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_12_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_12
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_12_infra
  ]
}
#endregion subdomain12


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain13
module "subdomain_13_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "13") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["13"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_13"
  host  = contains(keys(var.subdomain_index_to_name), "13") ? module.subdomain_13_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_13_app" {
  count  = contains(keys(var.subdomain_index_to_name), "13") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["13"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_13_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_13
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_13_infra
  ]
}
#endregion subdomain13


#Don't make changes in these subdomain files, instead make changes in the file creating them; eg. subdomain_generator.py
#region subdomain14
module "subdomain_14_infra" {
  count  = contains(keys(var.subdomain_index_to_name), "14") ? 1 : 0
  source = "../../lz/subdomain_infra"

  sub_domain_name = var.subdomain_index_to_name["14"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.ad,
  ]
}

provider "databricks" {
  alias = "subdomain_14"
  host  = contains(keys(var.subdomain_index_to_name), "14") ? module.subdomain_14_infra[0].resources.dbw.workspace_url : ""
}

module "subdomain_14_app" {
  count  = contains(keys(var.subdomain_index_to_name), "14") ? 1 : 0
  source = "../../lz/subdomain_app"

  sub_domain_name = var.subdomain_index_to_name["14"]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  subdomain_infra = module.subdomain_14_infra[count.index].resources
  resource_names  = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_14
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_14_infra
  ]
}
#endregion subdomain14

