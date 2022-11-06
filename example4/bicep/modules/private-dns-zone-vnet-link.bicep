@description('Private DNS Zone Name')
param privateDnsZoneName string

@description('Common tags for resources')
param commonTags object

@description('Vnet to link')
param vnet object

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'link-to-${vnet.vnetName}'
  parent: privateDnsZone  
  tags: commonTags
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(vnet.subId, vnet.rgName, 'Microsoft.Network/virtualNetworks', vnet.vnetName)
    }
  }
}
