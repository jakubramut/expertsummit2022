data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "my_rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_key_vault" "my_kv" {
  name                        = local.kv_name
  location                    = azurerm_resource_group.my_rg.location
  resource_group_name         = azurerm_resource_group.my_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
}