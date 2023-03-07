param(
  [string] $environment = "dev",
  [int]$apply = $false,
  [int]$refresh = $true,
  [int]$autoApprove = $true,
  [int]$initialize = $false,
  [int]$upgradeState = $false
)

$basePath = "$PSScriptRoot/../terraform"
$domains = "dist", "em", "cross"

python "$basePath/Environments/domain_template/subdomain_generator.py"
terraform -chdir="$basePath" fmt -recursive

function deploy_environment_domain {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)] [string] $environment,
    [Parameter(Mandatory)] [string] $domain,
    [int]$apply = $false,
    [int]$refresh = $true,
    [int]$autoApprove = $true,
    [int]$initialize = $false,
    [int]$upgradeState = $false
  )

  $domainPath = "$basePath/Environments/$environment/$domain"

  if ($initialize) {
    if ($upgradeState) {
      terraform -chdir="$domainPath" init -upgrade
    }
    else {
      terraform -chdir="$domainPath" init
    }
  }
  if ($apply) {
    if ($autoApprove) {
      terraform -chdir="$domainPath" apply -refresh="$refresh" -auto-approve
    }
    else {
      terraform -chdir="$domainPath" apply -refresh="$refresh"
    }
  }
  else {
    terraform -chdir="$domainPath" plan -refresh="$refresh"
  }
}

Foreach ($domain IN $domains) {
  deploy_environment_domain -environment $environment `
    "$domain" `
    -apply $apply `
    -refresh $refresh `
    -autoApprove $autoApprove `
    -initialize $initialize `
    -upgradeState $upgradeState
}