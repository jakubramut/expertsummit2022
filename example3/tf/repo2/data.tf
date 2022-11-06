data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "my_shd_rg" {
  name = local.rg_shd_name
}

data "azurerm_key_vault" "my_kv" {
  name                = local.kv_name
  resource_group_name = data.azurerm_resource_group.my_shd_rg.name
}