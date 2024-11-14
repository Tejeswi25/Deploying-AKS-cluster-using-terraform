output "service_principal_name" {
    description = "The object id of service principal.Can be used to assign roles"
    value = azuread_service_principal.example.display_name
}

output "service_principal_object_id" {
    description = "The object id of service principal"
    value = azuread_service_principal.example.object_id
}

output "service_principal_tenant_id" {
    value = azuread_service_principal.example.application_tenant_id
}

output "client_id" {
    description = "The object id of service principal"
    value = azuread_application.example.client_id
}

output "service_principal_application_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.example.client_id
}

output "client_secret" {
    description = "Password for service principal"
    value = azuread_service_principal_password.example.value
}