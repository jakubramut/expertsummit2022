# resource "azurerm_user_assigned_identity" "mui" {
#   location                    = azurerm_resource_group.my_rg.location
#   name                = local.mui_name
#   resource_group_name         = azurerm_resource_group.my_rg.name
# }

# resource "azurerm_key_vault_access_policy" "mui_kv_access_policy" {
#   key_vault_id = azurerm_key_vault.my_kv.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_user_assigned_identity.mui.principal_id

#   key_permissions         = ["Get"]
#   secret_permissions      = ["Get"]
#   certificate_permissions = ["Get"]
# }