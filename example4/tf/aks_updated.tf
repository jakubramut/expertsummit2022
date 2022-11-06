# resource "azurerm_kubernetes_cluster" "aks" {
#   name                                = local.aks_name
#   location                            = azurerm_resource_group.my_rg.location
#   resource_group_name                 = azurerm_resource_group.my_rg.name
#   dns_prefix                          = "tf01"
#   private_cluster_enabled             = true
#   private_cluster_public_fqdn_enabled = false
#   local_account_disabled              = true
#   azure_policy_enabled                = true
#   node_resource_group                 = "${local.aks_name}-rg"

#   network_profile {
#     network_plugin = "azure"
#     network_policy = "azure"
#   }

#   default_node_pool {
#     name           = "default"
#     vnet_subnet_id = azurerm_subnet.subnet_aks.id
#     node_count     = 1
#     vm_size        = "Standard_DS2_v2"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   azure_active_directory_role_based_access_control {
#     managed            = true
#     azure_rbac_enabled = false
#   }

#   key_vault_secrets_provider {
#     secret_rotation_enabled  = true
#     secret_rotation_interval = "2m"
#   }
# }