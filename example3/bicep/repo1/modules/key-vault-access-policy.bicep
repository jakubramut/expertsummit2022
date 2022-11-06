@description('Key vault name')
param keyVaultName string

@description('The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.')
param objectId string

@description('Permissions the identity has for keys, secrets and certificates.')
param permissions object

resource accessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: objectId
        permissions: permissions
        tenantId: subscription().tenantId
      }
    ]
  }
}
