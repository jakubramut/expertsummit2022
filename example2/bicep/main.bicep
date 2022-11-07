targetScope = 'subscription'

@description('Azure region for deployment')
@allowed(['westeurope', 'northeurope'])
param location string

@description('Environment name')
@allowed(['dev', 'test', 'stage', 'prod'])
param env string

@description('Company name')
param company string = 'expertsummit'

var rg_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-rg-02'

var requireTagPolicyId = tenantResourceId('Microsoft.Authorization/policyDefinitions', '96670d01-0a4d-4649-9c89-2d3abc0a5025')

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'RGrequireTagAssignment'
  properties: {
    policyDefinitionId: requireTagPolicyId
    displayName: 'bicep-RGrequireTagAssignment'
    parameters: {
      tagName: {
        value: 'ExpertSummit2022'
      }
    }
  }
}

// resource policyTestRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//   name: rg_name
//   location: location
// }
