output "aks_resource_id" {
  description = "Resource ID of AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "aks" {
  value       = azurerm_kubernetes_cluster.this
}