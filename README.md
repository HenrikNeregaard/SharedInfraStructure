# Shared infrastructure

Documentation for Terraform Code
================================

This Terraform code is used to set up the necessary providers, locals and modules to create a domain and its associated resources.

Providers
---------

The code specifies three providers:

-  azurerm: used to access the Azure Resource Manager API.
-  azuread: used to access the Azure Active Directory API.
-  databricks: used to access the Databricks API.

Locals
------

The code also defines several local variables:

-   domain: the name of the domain to be created.
-   environment: the environment in which the domain will be created.
-   subdomain_names: a list of subdomains to be created.
-   location: the geographic location of the domain.
-   metastore`: the ID and name of the metastore to be used.
-   databricks_account_console_id: the ID of the Databricks account.

Modules
-------

The code utilizes several modules to create the domain and its associated resources:

-   resource_names: used to generate the names of the resources to be created.
-   ad: used to create the Active Directory resources.
-   shared_infra: used to create the shared infrastructure resources.
-   domain_infra: used to create the domain-specific infrastructure resources.
-   domain_app: used to create the domain-specific application resources.

## Group setup
Users needs this setup

G.U.datalake_admins member  -- change this to AAD_Datalake_admins
databricks-Unity-catalog-scim owner  
Azure databricks account console admin  
Access to Andel domain  
Access to Andel DevOps med basic license  


## Setup
###Scoop
install everything needed for this to work using powershell
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
irm get.scoop.sh | iex
scoop install git
scoop bucket add extras
scoop install terraform azure-cli vscode 7zip python
az bicep upgrade
```
#### scoop buckets  
- scoop bucket add
- extras
- 
- github-gh
- jetbrains
- java

#### scoop programs
- git
- 
- terraform  
- azurestorageexplorer  
- azure-cli  
- vscode
- gh
- python
- java 8?
- intellij / pycharm

### others  
windows terminal  
WSL ubuntu 2020  


## Todo
- [x] Create All required resources
  - [x] Keyvault
  - [x] Databricks
  - [x] Synapse
  - [x] Data factory
- [x] Synapse setup
  - [x] Storage linked service
  - [x] Keyvault linked service
  - [x] firewall
- [ ] Data factory setup
  - [x] Storage linked service
  - [x] Databricks linked service
  - [x] Keyvault linked service
  - [ ] Use shared runtime
- [x] Databricks setup
  - [x] Mounts
  - [x] secret
  - [x] Access to vnet data
  - [x] Create Ds storage for ds workspace
  - [x] Create DS workspace SPN
  - [x] Setup data engineering workspace, and ds workspace
- [ ] DevOps
  - [x] Setup Environment admin deployment
    - [x] Create admin state storage
    - [x] Create state storage for domains
    - [x] Setup admin keyvault
    - [x] Create domain and environment SPN
    - [x] Configure Github provider
    - [x] Setup github secrets and permissions for each domain so they cannot interact
  - [ ] Setup build server 
  - [ ] Setup shared integration runtime on premise 
  - [x] Base pipeline that push changes with no refresh
  - [x] Daily run that forces infra to comply with code
  - [ ] Example pipeline up and running
- [ ] Security
  - [x] Closed environment using firewalls
  - [ ] Setup read only for DS workspace and Synapse
- [ ] v2
  - [ ] Local runtime
  - [ ] Private link 
  - [ ] Databricks linked service


## Architechture
We will have multiple environments levels for each domain.
We will have to persistant environments level, dev and production.
For each environment level we will also have an administration environment.
This will contain purview, terraform states, key vault for github etc.
This admin environment will be setup using using bicep.

Each environment level will be managed by by a dedicated terraform project 
all referencing the sharedInfrastructure fold.
This is because all environments need their own reference to a storage account container.
When updating the environment level, first update the dataless cross domain environment 
to make sure update works

## Notes
Purview is to be set up elsewhere