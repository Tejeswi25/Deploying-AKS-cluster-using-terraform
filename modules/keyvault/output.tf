output "keyvault_id" {
    value = azurerm_key_vault.kv.id
}

output "tenant_id"{
    value = data.azurerm_client_config.current.tenant_id
}
