targetScope = 'subscription'

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

@description('AKS deployment parameters')
param aksParams object

var rg_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-rg-04'
var vnet_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-vnet-04'
var st_name = 'bp${company}${env}${substring(location, 0, 2)}st04'
var aks_name = 'bp-${company}-${env}-${substring(location, 0, 2)}-aks-04'

#disable-next-line no-hardcoded-env-urls
var pdnszone_name_blob = 'privatelink.blob.core.windows.net'

resource myRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rg_name
  location: location
}

module nsgcommon './modules/nsg.bicep' = {
  scope: myRg
  name: 'nsgcommon'
  params: {
    location: location
    name: 'nsgcommon'
    securityRules: []
  }
}

module nsgpe './modules/nsg.bicep' = {
  scope: myRg
  name: 'nsgpe'
  params: {
    location: location
    name: 'nsgpe'
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
      // {
      //   name: 'data-snet'
      //   addressPrefix: '10.100.1.0/24'
      //   privateEndpointNetworkPolicies: 'Enabled'
      //   privateLinkServiceNetworkPolicies: 'Enabled'
      //   networkSecurityGroup: {
      //     id: nsgpe.outputs.nsgId
      //   }
      // }
    ]
  }
}

module sa 'modules/sa.bicep' = {
  scope: myRg
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

module stPrivateDnsZone './modules/private-dns-zone.bicep' = {
  scope: myRg
  name: 'stPrivateDnsZone'
  params: {
    name: pdnszone_name_blob
    virtualNetworkLink: {
      name: 'st-vnet-link'
      vnetId: vnet.outputs.id
    }
  }
}

module stPrivateEndpoint './modules/private-endpoint.bicep' = {
  scope: myRg
  name: 'stPrivateEndpoint'
  params: {
    name: '${st_name}-pe'
    location: location
    subnetId: '${vnet.outputs.id}/subnets/data-snet'
    privateDnsZoneId: stPrivateDnsZone.outputs.id
    linkServiceConnections: [
      {
        name: 'conn-${st_name}-pe'
        groupIds: ['blob']
        serviceId: sa.outputs.id
      }
    ]
  }
}

module aks './modules/aks.bicep' = {
  scope: myRg
  name: aks_name
  params: {
    systemPoolProfiles: aksParams.systemPoolProfile
    userPoolProfile: aksParams.userPoolProfile
    aksName: aks_name
    nodeResourceGroupName: '${aks_name}-rg'
    kubernetesVersion: '1.24.6'
    location: location
    subnetID: '${vnet.outputs.id}/subnets/aks-snet'
    clusterAdminAadGroupObjectId: aksParams.clusterAdminAadGroupObjectId
    networkPlugin: 'azure'
    networkPolicy: 'azure'
  }
}
