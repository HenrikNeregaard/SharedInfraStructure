locals {
  githubRepoSharedRepoName = "SharedInfraStructure"
  githubRepoShared         = "andel-bi/${local.githubRepoSharedRepoName}"
}

# This one appears empty if github token is not set
# Set github token tf variable to get proper value
# can give error: "repository": required field is not set
data "github_repository" "repo" {
  full_name = local.githubRepoShared
}

resource "github_repository_environment" "repo_environment" {
  environment = "${var.domain}-${var.environment}-deployment"
  repository  = data.github_repository.repo.name
  #  repository = local.githubRepoShared
}

resource "github_actions_environment_secret" "githubSecrets" {
  for_each = {
    clientId       = azuread_application.base.application_id
    clientSecret   = azuread_service_principal_password.base.value
    subscriptionId = var.subscription
    tenantId       = azuread_service_principal.base.application_tenant_id
  }

  #  repository      = local.githubRepoShared
  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.repo_environment.environment
  secret_name     = each.key
  plaintext_value = each.value
}
