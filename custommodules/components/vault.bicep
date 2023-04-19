param parKeyVaultName string
param parSecretName string

@secure()
param parSecretValue string
@minLength(1)
#disable-next-line secure-secrets-in-params
param parSecretWriterUserPrincipalName string
@minLength(1)
#disable-next-line secure-secrets-in-params
param parSecretReaderUserPrincipalName string

param location string = resourceGroup().location

module identityWriter './userManagedIdentity.bicep' = {
  name: 'identityWriter'
  params:{
    location:location
    name: parSecretWriterUserPrincipalName
  }
}
module idenityReader './userManagedIdentity.bicep' = {
  name: 'idenityReader'
  params:{
    location:location
    name: parSecretReaderUserPrincipalName
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: parKeyVaultName
  location: location
  
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies:[
      {
        tenantId: subscription().tenantId
        objectId: identityWriter.outputs.AssignedIdentityId
        permissions: {
          secrets: [
            'set'
          ]
        }
      }
      {
        tenantId: subscription().tenantId
        objectId: idenityReader.outputs.AssignedIdentityId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: parSecretName

  properties: {
    value: parSecretValue
  }
}

// resource uami1AccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
//   // parent: keyVault
//   name: parUami1Id

//   properties: {
//     accessPolicies: [
//       {
//         tenantId: subscription().tenantId
//         objectId: parUami1Id
//         permissions: {
//           secrets: [
//             'get'
//           ]
//         }
//       }
//     ]
//   }
// }

// resource uami2AccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
//   parent: keyVault
//   name: parUami2Id
//   properties: {
//     accessPolicies: [
//       {
//         tenantId: subscription().tenantId
//         objectId: parUami2Id
//         permissions: {
//           secrets: [
//             'get'
//           ]
//         }
//       }
//     ]
//   }
// }
