@minLength(3)
@maxLength(24)
@description('Key Vault name.')
param name string

@description('The location.')
param location string

@description('The Type of the SKU used for this Key Vault.')
param sku object 

@maxLength(16)
@description('An array up to 16 objects describing Key Vault access policies.')
param accessPolicies array

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: sku.name
      family: sku.family
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDiskEncryption: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: true
  }
}

@batchSize(1)
module kvAccessPolicy './key-vault-access-policy.bicep' = [for policy in accessPolicies: {
  name: guid(policy.objectId, keyVault.name)
  params: {
    keyVaultName: keyVault.name
    objectId: policy.objectId
    permissions: policy.permissions
  }
}]
