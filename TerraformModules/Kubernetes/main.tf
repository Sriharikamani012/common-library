data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                 = var.k8s_cluster.name
  resource_group_name  = data.azurerm_resource_group.this.name
  location             = data.azurerm_resource_group.this.location
  dns_prefix           = var.k8s_cluster.dns_prefix
  private_link_enabled = true
  kubernetes_version   = var.k8s_cluster.kubernetes_version

  default_node_pool {
    name                = var.k8s_default_pool.name
    node_count          = var.k8s_default_pool.count
    vm_size             = var.k8s_default_pool.vm_size
    os_disk_size_gb     = var.k8s_default_pool.os_disk_size_gb
    type                = "VirtualMachineScaleSets"
    availability_zones  = var.k8s_default_pool.availability_zones
    enable_auto_scaling = var.k8s_default_pool.enable_auto_scaling
    min_count           = var.k8s_default_pool.min_count
    max_count           = var.k8s_default_pool.max_count
    max_pods            = var.k8s_default_pool.max_pods

    # Required for advanced networking
    vnet_subnet_id = var.default_pool_subnet_id
  }

  service_principal {
    client_id     = var.k8s_client_id
    client_secret = var.k8s_client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = var.log_analytics_workspace_id != null ? true : false
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }

    kube_dashboard {
      enabled = true
    }
  }

  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = var.k8s_cluster.service_address_range
    dns_service_ip     = var.k8s_cluster.dns_ip
  }

  #role_based_access_control {
  #  enabled = false
  #  azure_active_directory {
  #    client_app_id     = var.k8s_client_id
  #    server_app_id     = var.k8s_client_id
  #    server_app_secret = var.k8s_client_secret
  #  }
  #}
}

resource "azurerm_kubernetes_cluster_node_pool" "example" {
  for_each              = var.k8s_extra_node_pools
  name                  = each.value["name"]
  node_count            = each.value["count"]
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value["vm_size"]
  os_disk_size_gb       = each.value["os_disk_size_gb"]
  availability_zones    = each.value["availability_zones"]
  enable_auto_scaling   = each.value["enable_auto_scaling"]
  min_count             = each.value["min_count"]
  max_count             = each.value["max_count"]
  max_pods              = each.value["max_pods"]

  # Required for advanced networking
  vnet_subnet_id = var.default_pool_subnet_id

}

resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  name                       = "loganalytics-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "kube-audit"
    enabled = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "kube-apiserver"
    enabled = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "kube-controller-manager"
    enabled = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "kube-scheduler"
    enabled = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "cluster-autoscaler"
    enabled = true
    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}
