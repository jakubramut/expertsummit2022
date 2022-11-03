data "azurerm_subscription" "current" {}

data "azurerm_policy_definition" "RGRequireTag" {
  display_name = "Require a tag on resource groups"
}

resource "azurerm_subscription_policy_assignment" "RGrequireTagAssignment" {
  name                 = "tf-RGrequireTagAssignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.RGRequireTag.id

  parameters = <<PARAMS
    {
      "tagName": {
        "value": "ExpertSummit2022"
      }
    }
PARAMS
}