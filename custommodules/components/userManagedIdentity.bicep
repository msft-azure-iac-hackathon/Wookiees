targetScope = 'resourceGroup'

@minLength(1)
param name string
param location string = resourceGroup().location

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name 
  location: location
}

output AssignedIdentityId string = userAssignedIdentity.properties.principalId
