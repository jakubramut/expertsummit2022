data "azurerm_resource_group" "my_rg" {
  name = local.existing_rg_name
}

resource "azurerm_user_assigned_identity" "mui" {
  location            = data.azurerm_resource_group.my_rg.location
  name                = "mui"
  resource_group_name = data.azurerm_resource_group.my_rg.name
}

resource "azurerm_user_assigned_identity" "mui2" {
  location            = data.azurerm_resource_group.my_rg.location
  name                = "mui2"
  resource_group_name = data.azurerm_resource_group.my_rg.name
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = data.azurerm_resource_group.my_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.mui.principal_id
}