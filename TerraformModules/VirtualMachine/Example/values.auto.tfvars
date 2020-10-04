
# Example  variable declaration for Linux VM
linux_vms = {
  vm1 = {
    name                             = "testvm"
    vm_size                          = "Standard_DS1_v2" #(Mandatory) 
    lb_backend_pool_name             = "springbootlbbackend"     
    assign_identity                  = true
    zone                             = "1"
    subnet_name                      = "loadbalancer" #(Mandatory)
    disable_password_authentication  = true
    source_image_reference_offer     = "UbuntuServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher = "Canonical"   # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku       = "18.04-LTS"   # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version   = "Latest"      # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    storage_os_disk_caching          = "ReadWrite"
    managed_disk_type                = "Premium_LRS"  
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    internal_dns_name_label          = null
    enable_ip_forwarding             = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking    = null # set it to true if you want to enable accelerated networking
    dns_servers                      = null
    static_ip                        = null
    recovery_services_vault_key      = "rsv1"
    enable_cmk_disk_encryption       = true # set it to true if you want to enable disk encryption using customer managed key
    custom_data_path                 = "//Terraform//Scripts//CustomData.tpl" #Optional
    custom_data_args                 = {name = "VMandVMSS", destination = "EASTUS2", version = "1.0"}
  }
}

tags = {
  "env" = "dev"
}
administrator_user_name = "test"
administrator_login_password = "test1234" # don't define it if you set  disable_password_authentication to true
linux_image_id = "" # don't define this if you are passing image created through packer to the VM    


# managed data disks

  managed_data_disks = {
    disk1 = {
      disk_name = "diskvm2"
      vm_name   = "firstvm1"
      lun       = 10
      storage_account_type = "Standard_LRS"
      disk_size     = "1024"
      caching       = "None" 
      write_accelerator_enabled = false 
    }
  }

# Example  variable declaration for windows VM
   windows_vms = {
      vm1 = {
        type                             = "secondvm"               #(Mandatory) suffix of the vm
        id                               = "2"                      #(Mandatory) Id of the VM
        source_image_reference_offer     = "WindowsServer"           
        source_image_reference_publisher = "MicrosoftWindowsServer"  
        source_image_reference_sku       = "2016-Datacenter"         
        source_image_reference_version   = "Latest"                    
        subnet_name                      = "proxy"                  #(Mandatory) Id of the Subnet   
        vm_size                          = "Standard_DS1_v2"        #(Mandatory) 
        managed_disk_type                = "Premium_LRS"            #(Mandatory) 
        internal_lb_iteration            = "0"
        assign_identity                  = true
      }
    }

