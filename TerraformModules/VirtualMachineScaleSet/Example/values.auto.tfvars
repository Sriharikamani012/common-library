# VMSS
vmss = {
  vm1 = {
    name = "nginx23467" #(Mandatory) suffix of the vm
    storage_profile_data_disk = [
      {
        lun                       = 0
        caching                   = "ReadWrite"
        disk_size_gb              = 32
        managed_disk_type         = "Standard_LRS"
        write_accelerator_enabled = null
      }
    ]
    subnet_name                      = "proxy" #(Mandatory) Id of the Subnet
    internal_lb_iteration            = 0
    zones                            = ["1", "2"]        #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line if mutli zone is enabled with LB, LB has to be standard
    vm_size                          = "Standard_DS1_v2" #(Mandatory)
    enable_ip_forwarding             = false             # true #(Optional)
    assign_identity                  = true
    enable_autoscaling               = false
    instances                        = 1
    disable_password_authentication  = true
    source_image_reference_offer     = "UbuntuServer" #set this to null if you are using image id
    source_image_reference_publisher = "Canonical"    #set this to null if you are using image id
    source_image_reference_sku       = "18.04-LTS"    #set this to null if you are using image id
    source_image_reference_version   = "Latest"       #set this to null if you are using image id
    storage_os_disk_caching          = "ReadWrite"
    managed_disk_type                = "Premium_LRS" #(Mandatory)
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    enable_acc_net                   = null
    enable_ip_forward                = null
    enable_cmk_disk_encryption       = true
    custom_data_path                 = "//Terraform//Scripts//CustomData.sh" #Optional (relative path from the root of the repo)
    custom_data_args                 = { name = "VMSS", destination = "EASTUS2", version = "1.0" } # Optional arguments for the custom-data script
  }
}

tags = {
  "env" = "dev"
}
administrator_user_name      = "test"
administrator_login_password = "test1234" # define this as 'null' if you are not using password authentication for the VM.
linux_image_id               = ""         # don't define this if you are passing image created through packer to the VMSSs
