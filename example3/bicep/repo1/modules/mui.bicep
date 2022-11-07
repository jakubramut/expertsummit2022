@description('Managed user identity name')
param name string

@description('Azure region for deployment')
param location string

resource mui 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: name
  location: location
}

output principalId string = mui.properties.principalId
