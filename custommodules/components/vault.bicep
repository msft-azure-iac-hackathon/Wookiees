param keyVaultName string
param secretName string
@secure()
param secretValue string
param uami1Id string
param uami2Id string

param location string = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: secretName

  properties: {
    value: secretValue
  }
}

resource uami1AccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  parent: keyVault
  name: uami1Id

  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: uami1Id
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}

resource uami2AccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  parent: keyVault
  name: uami2Id
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: uami2Id
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}
