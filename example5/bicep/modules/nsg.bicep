@description('The location')
param location string

@description('Nsg name')
param name string

@description('securityRules')
param securityRules array

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: name
  location: location
  properties: {
    securityRules: [for securityRule in securityRules: {
      name: securityRule.name
      properties: {
        description: contains(securityRule, 'description') ? securityRule.description : ''
        protocol: securityRule.protocol
        sourcePortRange: contains(securityRule, 'sourcePortRange') ? securityRule.sourcePortRange : ''
        sourcePortRanges: contains(securityRule, 'sourcePortRanges') ? securityRule.sourcePortRanges : []
        destinationPortRange: contains(securityRule, 'destinationPortRange') ? securityRule.destinationPortRange : ''
        destinationPortRanges: contains(securityRule, 'destinationPortRanges') ? securityRule.destinationPortRanges : []
        sourceAddressPrefix: contains(securityRule, 'sourceAddressPrefix') ? securityRule.sourceAddressPrefix : ''
        sourceAddressPrefixes: contains(securityRule, 'sourceAddressPrefixes') ?securityRule.sourceAddressPrefixes : []
        destinationAddressPrefix: contains(securityRule, 'destinationAddressPrefix') ? securityRule.destinationAddressPrefix : ''
        destinationAddressPrefixes: contains(securityRule, 'destinationAddressPrefixes') ? securityRule.destinationAddressPrefixes : []
        access: securityRule.access
        priority: securityRule.priority
        direction: securityRule.direction        
      }
    }]
  }
}

output nsgId string = nsg.id
