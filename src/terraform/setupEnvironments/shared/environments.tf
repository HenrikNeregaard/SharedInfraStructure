locals {
  environments = {
    cross = {
      domain       = "cross"
      subscription = var.crossSubscriptionId
    }
    em = {
      domain       = "em"
      subscription = var.energyMarketSubscriptionId
    }
    dist = {
      domain       = "dist"
      subscription = var.distributionSubscriptionId
    }
    emma = {
      domain       = "emma"
      subscription = var.crossSubscriptionId
    }
    krp = {
      domain       = "krp"
      subscription = var.crossSubscriptionId
    }
    jis = {
      domain       = "jis"
      subscription = var.crossSubscriptionId
    }
    anna = {
      domain       = "anna"
      subscription = var.crossSubscriptionId
    }
  }
}



module "cross" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.cross.domain
  environment         = var.environment
  subscription        = local.environments.cross.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}

module "energyMarket" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.em.domain
  environment         = var.environment
  subscription        = local.environments.em.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}

module "distribution" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.dist.domain
  environment         = var.environment
  subscription        = local.environments.dist.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}

module "emma" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.emma.domain
  environment         = var.environment
  subscription        = local.environments.emma.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}

module "krp" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.krp.domain
  environment         = var.environment
  subscription        = local.environments.krp.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}

module "jis" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.jis.domain
  environment         = var.environment
  subscription        = local.environments.jis.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}

module "anna" {
  source              = "./modules/domainEnvironment"
  domain              = local.environments.anna.domain
  environment         = var.environment
  subscription        = local.environments.anna.subscription
  keyvaultId          = azurerm_key_vault.base.id
  storageAccount      = azurerm_storage_account.stateStorage
  keyvaultAccessId    = azurerm_key_vault_access_policy.secretOfficers["current"].id
  stateSubscriptionId = var.subscription
}
