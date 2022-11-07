targetScope = 'subscription'

@description('Azure region for deployment')
@allowed(['westeurope', 'northeurope'])
param location string

var rg_name = 'bp-rg-test-06'

var roles = {
  NetworkContributor: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
}

resource myRg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: rg_name
}

module mui 'modules/mui.bicep' = {
  name: 'mui'
  scope: myRg
  params: {
    name: 'mui'
    location: location
  }
}

module mui2 'modules/mui.bicep' = {
  name: 'mui2'
  scope: myRg
  params: {
    name: 'mui2'
    location: location
  }
}

module roleAssignmentNetworkContributor './modules/role-assignment.bicep' = {
  scope: myRg
  name: 'roleAssignmentNetworkContributor'
  params: {
    principalId: mui.outputs.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionResourceId: roles.NetworkContributor
  }
}
