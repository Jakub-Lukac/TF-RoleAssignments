data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

resource "azuread_user" "mark_johnson" {
  user_principal_name = "mjohnson@M365x25212640.OnMicrosoft.com"
  display_name        = "Mark Johnson"
  mail_nickname       = "mjohnson"
  password            = random_password.pass.result
}

resource "azuread_user" "max_willson" {
  user_principal_name = "mwillson@M365x25212640.OnMicrosoft.com"
  display_name        = "Max Willson"
  mail_nickname       = "mwillson"
  password            = random_password.pass.result
}

resource "random_password" "pass" {
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

resource "azuread_group" "testers" {
  display_name     = "Testers"
  owners           = [data.azurerm_client_config.current.object_id]
  security_enabled = true
}

resource "azurerm_role_assignment" "testers" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.testers.object_id
}

resource "azuread_group_member" "tester" {
  group_object_id  = azuread_group.testers.object_id
  member_object_id = azuread_user.max_willson.object_id
}