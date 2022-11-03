@minLength(3)
@maxLength(24)
@description('Key Vault name.')
param name string

@description('The location.')
param location string

resource myKv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDiskEncryption: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: true
  }
}
