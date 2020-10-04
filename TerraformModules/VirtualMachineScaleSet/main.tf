# Design Decisions applicable: #1575, #1580, #1582, #1583, #1589, #1593, #1598, #3387
# Design Decisions not applicable: #1581, #1584, #1585, #1586, #1590, #1600, #1857

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# -
# - Storage Account Data Source for diagnostic logs
# - 
data "azurerm_storage_account" "diagnostics_storage_account" {
  name                = var.diagnostics_sa_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_storage_account_sas" "diagnostics_storage_account_sas" {
  connection_string = data.azurerm_storage_account.diagnostics_storage_account.primary_connection_string
  https_only        = true

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = true
    file  = false
  }

  start  = formatdate("YYYY-MM-DD", timestamp())
  expiry = formatdate("YYYY-MM-DD", timeadd(timestamp(), "8760h"))

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags     = merge(var.vmss_additional_tags, data.azurerm_resource_group.this.tags)
  vmss_ids = [for x in azurerm_linux_virtual_machine_scale_set.this : x.id]

  key_permissions         = ["Get", "List", "Update", "Create", "Delete", "Purge"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Purge"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Delete", "Purge"]
  storage_permissions     = ["delete", "get", "list", "purge", "set", "update"]

  vmss_principal_ids = flatten([
    for x in azurerm_linux_virtual_machine_scale_set.this :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ]
  ])

  backend_pool_ids = flatten([
    for vmss_k, vmss_v in var.virtual_machine_scalesets : [
      for backend_pool_name in vmss_v["lb_backend_pool_names"] :
      lookup(var.lb_backend_address_pool_map, backend_pool_name, null)
    ]
  ])
}

# -
# - Generate Private/Public SSH Key for Linux Virtual Machine Scaleset
# -
resource "tls_private_key" "this" {
  for_each  = var.virtual_machine_scalesets
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -
# - Store Generated Private SSH Key to Key Vault Secrets
# - Design Decision #1582
# -
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.virtual_machine_scalesets
  name         = each.value["name"]
  value        = lookup(tls_private_key.this, each.key)["private_key_pem"]
  key_vault_id = var.key_vault_id
}

# -
# - Linux Virtual Machines Scalesets
# -
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  for_each            = var.virtual_machine_scalesets
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  # Automatic rolling upgrade - depends on health probe or health extension  
  upgrade_mode = coalesce(lookup(each.value, "enable_autoscaling"), false) == false ? "Manual" : "Rolling"

  dynamic "rolling_upgrade_policy" {
    for_each = coalesce(lookup(each.value, "enable_autoscaling"), false) == false ? [] : [each.value["enable_autoscaling"]]
    content {
      max_batch_instance_percent              = 20
      max_unhealthy_instance_percent          = 20
      max_unhealthy_upgraded_instance_percent = 5
      pause_time_between_batches              = "PT0S"
    }
  }

  # Required when using rolling upgrade policy
  health_probe_id = coalesce(lookup(each.value, "enable_autoscaling"), false) == false ? null : lookup(var.lb_probe_map, each.value["lb_probe_name"], null)

  # A collection of availability zones to spread the Virtual Machines over
  zones = coalesce(lookup(each.value, "enable_autoscaling"), false) == false ? lookup(each.value, "zones", null) : var.zones

  sku       = coalesce(lookup(each.value, "vm_size"), "Standard_DS1_v2")
  instances = each.value["instances"]

  disable_password_authentication = coalesce(lookup(each.value, "disable_password_authentication"), true)
  admin_username                  = var.administrator_user_name
  admin_password                  = coalesce(lookup(each.value, "disable_password_authentication"), true) == false ? var.administrator_login_password : null

  computer_name_prefix = each.value["name"]
  custom_data          = lookup(each.value, "custom_data_path", null) == null ? null : (base64encode(templatefile("${path.root}.${each.value["custom_data_path"]}", each.value["custom_data_args"])))

  dynamic "admin_ssh_key" {
    for_each = coalesce(lookup(each.value, "disable_password_authentication"), true) == true ? [var.administrator_user_name] : []
    content {
      username   = var.administrator_user_name
      public_key = lookup(tls_private_key.this, each.key)["public_key_openssh"]
    }
  }

  os_disk {
    caching                   = coalesce(lookup(each.value, "storage_os_disk_caching"), "ReadWrite")
    storage_account_type      = coalesce(lookup(each.value, "managed_disk_type"), "Standard_LRS")
    disk_size_gb              = lookup(each.value, "disk_size_gb", null)
    write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
    disk_encryption_set_id    = coalesce(lookup(each.value, "enable_cmk_disk_encryption"), false) == true ? lookup(azurerm_disk_encryption_set.this, each.key)["id"] : null
  }

  dynamic "source_image_reference" {
    for_each = var.linux_image_id == null ? (lookup(each.value, "source_image_reference_publisher", null) == null ? [] : [lookup(each.value, "source_image_reference_publisher", null)]) : []
    content {
      publisher = lookup(each.value, "source_image_reference_publisher", null)
      offer     = lookup(each.value, "source_image_reference_offer", null)
      sku       = lookup(each.value, "source_image_reference_sku", null)
      version   = lookup(each.value, "source_image_reference_version", null)
    }
  }

  source_image_id = var.linux_image_id

  # - Design Decision #1575, #1580, #3387
  dynamic "data_disk" {
    for_each = lookup(each.value, "storage_profile_data_disk", [])
    content {
      lun                       = lookup(data_disk.value, "lun", null)
      caching                   = lookup(data_disk.value, "caching", null)
      disk_size_gb              = lookup(data_disk.value, "disk_size_gb", null)
      storage_account_type      = lookup(data_disk.value, "managed_disk_type", null)
      write_accelerator_enabled = lookup(data_disk.value, "write_accelerator_enabled", null)
      disk_encryption_set_id    = coalesce(lookup(each.value, "enable_cmk_disk_encryption"), false) == true ? lookup(azurerm_disk_encryption_set.this, each.key)["id"] : null
    }
  }

  network_interface {
    name                          = "${each.value["name"]}-vmss-nic"
    primary                       = true
    enable_accelerated_networking = coalesce(lookup(each.value, "enable_acc_net"), false)
    enable_ip_forwarding          = coalesce(lookup(each.value, "enable_ip_forward"), false)
    ip_configuration {
      name                                   = "${each.value["name"]}-vmss-nic-cfg"
      primary                                = true
      subnet_id                              = lookup(each.value, "subnet_name", null) == null ? null : lookup(var.subnet_ids, lookup(each.value, "subnet_name"))
      load_balancer_backend_address_pool_ids = lookup(each.value, "enable_autoscaling", false) == false ? null : local.backend_pool_ids
    }
  }

  boot_diagnostics {
    storage_account_uri = var.sa_bootdiag_storage_uri
  }

  # Design Decision #1583
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : list(coalesce(lookup(each.value, "assign_identity"), false))
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [instances]
  }

  depends_on = [azurerm_disk_encryption_set.this]
}

# -
# - Create Key Vault Accesss Policy for VMSS MSI
# - Design Decision #1598
# -
resource "azurerm_key_vault_access_policy" "this" {
  count        = length(local.vmss_principal_ids)
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.vmss_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_linux_virtual_machine_scale_set.this]
}

#####################################################
# Linux VMSS CMK and Disk Encryption Set
#####################################################
locals {
  cmk_enabled_virtual_machine_scalesets = {
    for vmss_k, vmss_v in var.virtual_machine_scalesets :
    vmss_k => vmss_v if coalesce(lookup(vmss_v, "enable_cmk_disk_encryption"), false) == true
  }
}

# -
# - Generate CMK Key for Linux VMSS
# - Design Decision #1582, #1589
# -
resource "azurerm_key_vault_key" "this" {
  for_each     = local.cmk_enabled_virtual_machine_scalesets
  name         = each.value.name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt", "encrypt", "sign",
    "unwrapKey", "verify", "wrapKey"
  ]
}

# -
# - Enable Disk Encryption Set for Linux VMSS using CMK
#  Design Decision #1580, #1589
# -
resource "azurerm_disk_encryption_set" "this" {
  for_each            = local.cmk_enabled_virtual_machine_scalesets
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  key_vault_key_id    = lookup(azurerm_key_vault_key.this, each.key)["id"]
  identity {
    type = "SystemAssigned"
  }
}

# -
# - Adding Access Policies for Disk Encryption Set MSI
# - Design Decision #1589
# -
resource "azurerm_key_vault_access_policy" "cmk" {
  for_each     = local.cmk_enabled_virtual_machine_scalesets
  key_vault_id = var.key_vault_id

  tenant_id = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.tenant_id
  object_id = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.principal_id

  key_permissions    = ["get", "wrapkey", "unwrapkey"]
  secret_permissions = ["get"]
}

# -
# - Assigning Reader Role to Disk Encryption Set
# - Design Decision #1589
# -
resource "azurerm_role_assignment" "this" {
  for_each                         = local.cmk_enabled_virtual_machine_scalesets
  scope                            = var.key_vault_id
  role_definition_name             = "Reader"
  principal_id                     = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.principal_id
  skip_service_principal_aad_check = true
}

#####################################################
# Linux VM Scaleset Extension
#####################################################
locals {
  vmss_diag_storage = {
    for vmss_k, vmss_v in var.virtual_machine_scalesets :
    azurerm_linux_virtual_machine_scale_set.this[vmss_k].id => vmss_v.diagnostics_storage_config_path
  }

  diagnostics_storage_config_parms = {
    storage_account  = data.azurerm_storage_account.diagnostics_storage_account.name
    log_level_config = "LOG_DEBUG"
  }
}

# -
# - Enable Storage Diagnostics and Logs on Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "storage" {
  count                        = length(local.vmss_ids)
  name                         = "storage-diagnostics"
  virtual_machine_scale_set_id = element(local.vmss_ids, count.index)
  publisher                    = "Microsoft.Azure.Diagnostics"
  type                         = "LinuxDiagnostic"
  type_handler_version         = "3.0"
  auto_upgrade_minor_version   = true

  settings = lookup(local.vmss_diag_storage, element(local.vmss_ids, count.index), null) == null ? templatefile("${path.module}/diagnostics/config.json", merge({ vm_id = element(local.vmss_ids, count.index) }, local.diagnostics_storage_config_parms)) : templatefile("${path.root}.${lookup(local.vmss_diag_storage, element(local.vmss_ids, count.index))}", merge({ vm_id = element(local.vmss_ids, count.index) }, local.diagnostics_storage_config_parms))

  protected_settings = <<SETTINGS
    {
      "storageAccountName": "${data.azurerm_storage_account.diagnostics_storage_account.name}",
      "storageAccountSasToken": "${data.azurerm_storage_account_sas.diagnostics_storage_account_sas.sas}",
      "storageAccountEndPoint": "https://core.windows.net/"
    }
  SETTINGS

  depends_on = [azurerm_linux_virtual_machine_scale_set.this]
}

# -
# - Enable Log Analytics Diagnostics and Logs on Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "log_analytics" {
  count                        = length(local.vmss_ids)
  name                         = "log-analytics"
  virtual_machine_scale_set_id = element(local.vmss_ids, count.index)
  publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
  type                         = "OmsAgentForLinux"
  type_handler_version         = "1.7"

  settings = <<SETTINGS
    {
      "workspaceId": "${var.law_workspace_id}"
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {
      "workspaceKey": "${var.law_workspace_key}"
    }
  SETTINGS

  depends_on = [azurerm_linux_virtual_machine_scale_set.this]
}

# -
# - Enabling Network Watcher extension on Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "network_watcher" {
  count                        = length(local.vmss_ids)
  name                         = "network-watcher"
  virtual_machine_scale_set_id = element(local.vmss_ids, count.index)
  publisher                    = "Microsoft.Azure.NetworkWatcher"
  type                         = "NetworkWatcherAgentLinux"
  type_handler_version         = "1.4"
  auto_upgrade_minor_version   = true
  depends_on                   = [azurerm_linux_virtual_machine_scale_set.this]
}

# -
# - Enabling Azure Monitor Dependency virtual machine extension for Azure VMSS 
# -
resource "azurerm_virtual_machine_scale_set_extension" "vm_insights" {
  count                        = length(local.vmss_ids)
  name                         = "vm-insights"
  virtual_machine_scale_set_id = element(local.vmss_ids, count.index)
  publisher                    = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                         = "DependencyAgentLinux"
  type_handler_version         = "9.5"
  auto_upgrade_minor_version   = true
  depends_on = [
    azurerm_linux_virtual_machine_scale_set.this,
    azurerm_virtual_machine_scale_set_extension.log_analytics
  ]
}

# -
# - Enabling Auto Scale Setting for Virtual Machine Scalesets
# -
resource "azurerm_monitor_autoscale_setting" "this" {
  for_each            = var.virtual_machine_scalesets
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.this[each.key].id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 40
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
