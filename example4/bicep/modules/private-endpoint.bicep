@description('The location')
param location string

@description('Private endpoint name')
param name string

@description('subnet id for private endpoint')
param subnetId string

@description('Connection target array of { name: string, serviceId: string, groupIds: array of string }')
param linkServiceConnections array

@description('Private DNZ Zone Id')
param privateDnsZoneId string = ''

resource endpoint 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: name
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [for item in linkServiceConnections: {
      name: item.name
      properties: {
        privateLinkServiceId: item.serviceId
        groupIds: item.groupIds
      }
    }]
  }
}

resource pvtEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-08-01' = if (privateDnsZoneId != '') {
  name: '${name}/dnsgroupname'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnszonegroupconfig'
        properties: {
          privateDnsZoneId: (privateDnsZoneId != '') ? privateDnsZoneId : ''
        }
      }
    ]
  }
  dependsOn: [
    endpoint
  ]
}
