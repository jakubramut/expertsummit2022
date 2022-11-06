@description('The location')
param location string

@description('Virtual Network name')
param name string

@description('Virtual network address prefix')
param addressPrefix string

@description('Subnets definitions')
param subnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
        delegations: contains(subnet, 'delegations') ? subnet.delegations : []
        serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : []
        networkSecurityGroup: contains(subnet, 'networkSecurityGroup') ? subnet.networkSecurityGroup : null
        natGateway: contains(subnet, 'natGateway') ? subnet.natGateway : null
      }
    }]
  }
}

output id string = virtualNetwork.id
output name string = virtualNetwork.name
