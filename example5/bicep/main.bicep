targetScope = 'resourceGroup'

@description('Azure region for deployment')
@allowed(['westeurope', 'northeurope'])
param location string

@description('Environment name')
@allowed(['dev', 'test', 'stage', 'prod'])
param env string

@description('Company name')
param company string = 'summit'

@description('Virtual Network address prefix')
param vnetAddressPrefix string

@description('Storage account parameters')
param saParams object

var vnet_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-vnet-05'
var st_name = 'bp${company}${env}${substring(location, 0, 2)}st05'

module nsgcommon './modules/nsg.bicep' = {
  name: 'nsgcommon'
  params: {
    location: location
    name: 'nsgcommon'
    securityRules: []
  }
}

module vnet './modules/vnet.bicep' = {
  name: 'mng01Vnet'
  params: {
    name: vnet_name
    location: location
    addressPrefix: vnetAddressPrefix
    subnets: [      
      {
        name: 'aks-snet'
        addressPrefix: '10.100.0.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
        networkSecurityGroup: {
          id: nsgcommon.outputs.nsgId
        }
      }
      {
        name: 'data-snet'
        addressPrefix: '10.100.1.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
  }
}

module sa 'modules/sa.bicep' = {
  name: st_name
  params: {
    name: st_name
    location: location
    accessTier: saParams.accessTier
    networkAcls: saParams.networkAcls
    kind: saParams.kind
    sku: saParams.sku
  }
}
