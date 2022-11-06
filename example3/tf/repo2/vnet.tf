resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = [var.vnetAddressPrefix]
}

resource "azurerm_subnet" "subnet_aks" {
  name                 = "aks-snet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.my_rg.name
  address_prefixes     = [var.aksSubnetAddressPrefix]
}

resource "azurerm_network_security_group" "nsg_aks" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_subnet_network_security_group_association" "aks_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_aks.id
  network_security_group_id = azurerm_network_security_group.nsg_aks.id
}
