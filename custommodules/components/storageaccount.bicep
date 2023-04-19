targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - Resource Group creation module'
metadata description = 'Module used to create Resource Groups for Azure Landing Zones'

@sys.description('Azure Region where Resource Group will be created.')
param location string = resourceGroup().location

@sys.description('Name of Resource Group to be created.')
param parStorageAccountName string

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: parStorageAccountName
  location: location
  tags: {}
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    defaultToOAuthAuthentication: true
  }
  kind:'Storage'
}

output outStorageAccountName string = resStorageAccount.name
output outStorageAccountId string = resStorageAccount.id
