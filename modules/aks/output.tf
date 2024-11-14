output "config" {
    value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}




output "kubeconfig" {
  value = {
    host                   = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host
    cluster_ca_certificate = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.cluster_ca_certificate
    client_certificate     = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate
    client_key             = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_key
  }
  sensitive = true
}