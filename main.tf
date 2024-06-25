data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

resource "azuread_user" "mark_johnson" {
  user_principal_name = "mjohnson@M365x25212640.OnMicrosoft.com"
  display_name        = "Mark Johnson"
  mail_nickname       = "mjohnson"
  password            = random_password.mark_johnson.result
}

resource "random_password" "mark_johnson" {
  length           = 16
  special          = true
  override_special = "!#@%&*()-_=+[]{}<>:?"
}

# Subscription level RBAC
resource "azurerm_role_assignment" "mark_johnson" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.mark_johnson.object_id
}
