targetScope = 'resourceGroup'

param location string = resourceGroup().location

module vault 'components/vault.bicep' = {
  name: 'myVault' 
  params: {
    location:location
  }
}
