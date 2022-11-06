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
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_subnet" "subnet_data" {
  name                                           = "data-snet"
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = azurerm_resource_group.my_rg.name
  address_prefixes                               = ["10.100.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = false
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

resource "azurerm_subnet_network_security_group_association" "data_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_data.id
  network_security_group_id = azurerm_network_security_group.nsg_aks.id
}
