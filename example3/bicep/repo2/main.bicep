targetScope = 'subscription'

@description('Azure region for deployment')
@allowed(['westeurope', 'northeurope'])
param location string

@description('Environment name')
@allowed(['dev', 'test', 'stage', 'prod'])
param env string

@description('Company name')
param company string = 'summit'

@description('AKS deployment parameters')
param aksParams object

@description('Virtual Network address prefix')
param vnetAddressPrefix string

@description('AKS Subnet Address Prefix')
param aksSubnetAddressPrefix string

var rg_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-rg-01'
var shd_rg_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-rg-shd-01'
var kv_name = 'bp${company}${env}${substring(location, 0, 2)}kv01'
var aks_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-aks-01'
var vnet_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-vnet-01'

resource myRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rg_name
  location: location
}

resource myExistingKv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  scope: resourceGroup(shd_rg_name)
  name: kv_name
}

module akssubnetnsg './modules/nsg.bicep' = {
  scope: myRg
  name: 'akssubnetnsg'
  params: {
    location: location
    name: 'aks-snet-nsg'
    securityRules: []
  }
}

module vnet './modules/vnet.bicep' = {
  scope: myRg
  name: 'mng01Vnet'
  params: {
    name: vnet_name
    location: location
    addressPrefix: vnetAddressPrefix
    subnets: [      
      {
        name: 'aks-snet'
        addressPrefix: aksSubnetAddressPrefix
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
        networkSecurityGroup: {
          id: akssubnetnsg.outputs.nsgId
        }
      }
    ]
  }
}

module aks './modules/aks.bicep' = {
  scope: myRg
  name: 'aks'
  params: {
    systemPoolProfiles: aksParams.systemPoolProfile
    userPoolProfile: aksParams.userPoolProfile
    aksName: aks_name
    nodeResourceGroupName: '${aks_name}-rg'
    clusterAdminAadGroupObjectId: aksParams.clusterAdminAadGroupObjectId
    kubernetesVersion: '1.24.6'
    location: location
    subnetID: '${vnet.outputs.id}/subnets/aks-snet'
    kvName: myExistingKv.name
    kvResourceGroupName: shd_rg_name
  }
}
