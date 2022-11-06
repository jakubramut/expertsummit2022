@description('The location.')
param location string

@description('Storage account name.')
param name string

@description('The SKU name. Required for account creation; optional for update.')
param sku string

@description('Indicates the type of storage account.')
param kind string

@description('Required for storage accounts where kind = BlobStorage. The access tier is used for billing.')
param accessTier string

@description('Network rule sets for storage account.')
param networkAcls object

resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    accessTier: accessTier
    minimumTlsVersion: 'TLS1_2'
    networkAcls: networkAcls
  }
}

output id string = sa.id
