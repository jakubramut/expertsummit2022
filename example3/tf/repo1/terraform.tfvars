location = "westeurope"
env      = "stage"
kvParams = {
  accessPolicies = [
    {
      objectId = "0514a8c8-5ffc-4f1a-921c-3c5e6d77f94f"
      permissions = {
        certificates = ["Get", "List"]
        keys         = ["Get", "List"]
        secrets      = ["Get", "List", "Delete", "Recover", "Backup"]
      }
    },
    {
      objectId = "3a6f1a9a-5b26-4454-8fa7-6e6f8494843a"
      permissions = {
        certificates = ["Get", "List"]
        keys         = ["Get", "List"]
        secrets      = ["Get", "List", "Set"]
      }
    },
    {
      objectId = "a79a4d70-5bd8-4e8e-bc0a-dd2e66bf8abb"
      permissions = {
        certificates = ["Get"]
        keys         = ["Get"]
        secrets      = ["Get", "List"]
      }
    }
  ]
  sku = {
    family = "A"
    name   = "Standard"
  }
}