resource "azurerm_kubernetes_cluster" "aks" {
  name                                = local.aks_name
  location                            = data.azurerm_resource_group.my_shd_rg.location
  resource_group_name                 = data.azurerm_resource_group.my_shd_rg.name
  dns_prefix                          = "tf01"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  local_account_disabled              = true
  azure_policy_enabled                = true
  node_resource_group                 = "${local.aks_name}-rg"

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  default_node_pool {
    name           = "default"
    vnet_subnet_id = azurerm_subnet.subnet_aks.id
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

}

resource "azurerm_key_vault_access_policy" "aks_kv_permission" {
  key_vault_id = data.azurerm_key_vault.my_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id

  secret_permissions = [
    "Get", "Set", "List"
  ]
}