param SAname string
param location string = resourceGroup().location

resource stg 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: SAname
  kind: 'StorageV2'
  location: location
  sku: {
    name: 'Standard_LRS'
  }

  resource default 'blobServices@2021-06-01' = {
    name: 'default'

    resource stateContainer 'containers@2021-06-01' = {
      name: toLower('adminState')
      properties: {

      }
    }
  }
}

output storageId string = stg.id
output storageName string = stg.name