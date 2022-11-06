@description('Private DNS Zone Name')
param name string

@description('Virtual Network Link Params')
param virtualNetworkLink object

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: 'global'
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: virtualNetworkLink.name
  location: 'global'
  properties: {
    registrationEnabled: contains(virtualNetworkLink, 'autoRegistrationEnabled') ? virtualNetworkLink.autoRegistrationEnabled : false
    virtualNetwork: {
      id: virtualNetworkLink.vnetId
    }
  }
}

output id string = privateDnsZone.id
