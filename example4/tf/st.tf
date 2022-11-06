resource "azurerm_storage_account" "st" {
  name                     = local.st_name
  resource_group_name      = azurerm_resource_group.my_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_private_dns_zone" "pdns_zone_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_private_endpoint" "pe_st" {
  name                = "${local.st_name}-pe"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  subnet_id           = azurerm_subnet.subnet_data.id

  private_service_connection {
    name                           = "conn-${local.st_name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.st.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "st-vnet-link"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdns_zone_blob.id]
  }
}