resource "azurerm_storage_account" "st" {
  name                     = local.st_name
  resource_group_name      = data.azurerm_resource_group.my_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
}