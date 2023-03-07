targetScope= 'subscription'
param environment string = 'dev'
param location string = 'WestEurope'

var domain = 'admin'
var SAname  = 'stdl${domain}${environment}state'
var resourceGroupName  = 'rg-dl-${domain}-${environment}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}

module sa './stateResources.bicep' = {
  name: 'storageAccount'
  scope: rg
  params: {
    SAname: SAname
    location: location
  }
}

output storageId string = sa.outputs.storageId
output storageName string = sa.outputs.storageName
output resourceGroupName string = rg.name
