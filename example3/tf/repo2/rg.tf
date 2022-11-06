resource "azurerm_resource_group" "my_rg" {
  name     = local.rg_name
  location = var.location
}