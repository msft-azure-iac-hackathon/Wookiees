param parKeyVaultName string
param parSecretName string
@secure()
param parSecretValue string
param parUami1Id string
param parUami2Id string

param location string = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: parKeyVaultName
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
  name: parSecretName

  properties: {
    value: parSecretValue
  }
}

resource uami1AccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  parent: keyVault
  name: parUami1Id

  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: parUami1Id
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
  name: parUami2Id
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: parUami2Id
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}
