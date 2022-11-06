targetScope = 'subscription'

@description('Azure region for deployment')
@allowed(['westeurope', 'northeurope'])
param location string

@description('Environment name')
@allowed(['dev', 'test', 'stage', 'prod'])
param env string

@description('Company name')
param company string = 'summit'

@description('Key Vault parameters')
param kvParams object

var rg_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-rg-shd-01'
var kv_name = 'bp${company}${env}${substring(location, 0, 2)}kv01'

resource myRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rg_name
  location: location
}

module myKv './modules/kv.bicep' = {
  scope: myRg
  name: 'myKv'
  params: {
    name: kv_name
    location: location
    sku: kvParams.sku
    accessPolicies: kvParams.accessPolcies
  }
}
