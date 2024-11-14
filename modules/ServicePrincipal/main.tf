data "azuread_client_config" "current" {}

resource "azuread_application" "example" {
    display_name = var.azuread_service_principal_name
    owners = [
        data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example"{
    client_id = azuread_application.example.client_id
    app_role_assignment_required = true
    owners = [
        data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "example" {
  service_principal_id = azuread_service_principal.example.id
}