@description('The object id of the identity to which the role should be assigned')
param principalId string

@description('Role definition resource id')
param roleDefinitionResourceId string

@allowed(['Device', 'ForeignGroup', 'Group', 'ServicePrincipal', 'User'])
@description('The principal type of the assigned principal ID')
param principalType string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(principalId, roleDefinitionResourceId)
  properties: {
    roleDefinitionId: roleDefinitionResourceId
    principalId: principalId
    principalType: principalType
  }
}
