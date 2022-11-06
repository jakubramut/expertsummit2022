@description('The AKS resouce name')
param aksName string

@description('Azure region for deployment')
param location string

@description('Azure AD Group in the identified tenant that will be granted the highly privileged cluster-admin role. If Azure RBAC is used, then this group will get a role assignment to Azure RBAC, else it will be assigned directly to the cluster\'s admin group.')
param clusterAdminAadGroupObjectId string

@description('The DNS prefix to use with hosted Kubernetes API server FQDN.')
var dnsPrefix = 'bp01'

@description('kubernetes Version')
param kubernetesVersion string

@description('The name of AKS resource group')
param nodeResourceGroupName string

@description('The AKS system agent pool profile')
param systemPoolProfiles object

@description('The AKS user agent pool profile')
param userPoolProfile object

@description('The node subnet ID')
param subnetID string

@allowed(['azure', 'kubenet'])
@description('Network policy used for building the Kubernetes network.')
param networkPolicy string

@allowed(['azure', 'calico'])
@description('Network plugin used for building the Kubernetes network.')
param networkPlugin string

var localSubnetID = {
  vnetSubnetID: subnetID
}
var localSystemPoolProfile = union(systemPoolProfiles, localSubnetID)
var localUserPoolProfile = union(userPoolProfile, localSubnetID)

resource aksCluster 'Microsoft.ContainerService/managedClusters@2020-12-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    addonProfiles: {
      aciConnectorLinux: {
        enabled: false
      }
      azurepolicy: {
        enabled: true
        config: {
          version: 'v2'
        }
      }
      httpApplicationRouting: {
        enabled: false
      }
      azureKeyvaultSecretsProvider: {
        enabled: true
      }
    }
    agentPoolProfiles: [
      localSystemPoolProfile
      localUserPoolProfile
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    aadProfile: {
      adminGroupObjectIDs: [
        clusterAdminAadGroupObjectId
      ]
      managed: true
      tenantID: subscription().tenantId
      enableAzureRBAC: true
    }
    dnsPrefix: dnsPrefix
    enableRBAC: true
    kubernetesVersion: kubernetesVersion
    nodeResourceGroup: nodeResourceGroupName
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPolicy: networkPolicy
      networkPlugin: networkPlugin
    }
    servicePrincipalProfile: {
      clientId: 'msi'
    }
  }
}
