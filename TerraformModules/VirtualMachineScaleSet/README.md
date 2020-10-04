# Virtual Machine ScaleSet
vms = {
  vm1 = {
    type = "nva" #(Mandatory) suffix of the vm
    id          = "0"   #(Mandatory) ID of each VMSS has to be UNIQUE!!!
    #storage_profile_data_disk   = []        #(Mandatory) For no data disks set []
    storage_profile_data_disk = [
      {
        id                = "1" #Disk id
        lun               = "0"
        caching           = "ReadWrite"
        create_option     = "Empty"
        disk_size_gb      = "32"
        managed_disk_type = "Standard_LRS"
      },
    ]
    subnet_iteration                  = "1"               #(Mandatory) Id of the Subnet
    zones                             = ["1", "2"]        #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line if mutli zone is enabled with LB, LB has to be standard
    vm_size                           = "Standard_DS1_v2" #(Mandatory) 
    tier                              = "Standard"        #(Mandatory) 
    capacity                          = "2"               #(Mandatory) 
    managed_disk_type                 = "Standard_LRS"    #(Mandatory) 
    storage_image_reference_offer     = "UbuntuServer"    #(Mandatory)        
    storage_image_reference_publisher = "Canonical"       #(Mandatory) 
    storage_image_reference_sku       = "16.04-LTS"       #(Mandatory)     
    storage_image_reference_version   = "Latest"          #(Mandatory)       
    enable_ip_forwarding              = false             # true      #(Optional)
    enable_autoscaling                = null              #(Optional)
    internal_lb_iteration             = null              #"0"         #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
  }

  vm2 = {
    type = "ssh" #(Mandatory) suffix of the vm
    id          = "1"   #(Mandatory) ID of each VMSS has to be UNIQUE!!!
    storage_profile_data_disk = [
      {
        id                = "1" #Disk id
        lun               = "0"
        caching           = "ReadWrite"
        create_option     = "Empty"
        disk_size_gb      = "32"
        managed_disk_type = "Premium_LRS"
      },
    ]                                                            #(Mandatory) For no data disks set []
    subnet_iteration                  = "0"                      #(Mandatory) Id of the Subnet
    zones                             = ["1"]                    #(Optional) Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    security_group_iteration          = null                     #(Optional) Id of the Network Security Group, set to null if there is no Network Security Groups
    static_ip                         = "10.0.128.4"             #(Optional) Set null to get dynamic IP or delete this line
    enable_accelerated_networking     = false                    #(Optional) 
    enable_ip_forwarding              = false                    #(Optional) 
    vm_size                           = "Standard_DS1_v2"        #(Mandatory) 
    tier                              = "Standard"               #(Mandatory) 
    capacity                          = "2"                      #(Mandatory) 
    managed_disk_type                 = "Premium_LRS"            #(Mandatory) 
    storage_image_reference_offer     = "UbuntuServer"           #(Mandatory)        
    storage_image_reference_publisher = "Canonical"              #(Mandatory) 
    storage_image_reference_sku       = "16.04-LTS"              #(Mandatory)     
    storage_image_reference_version   = "Latest"                 #(Mandatory)
    backup_policy_name                = "BackupPolicy-Schedule1" #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    enable_autoscaling                = true                     #(Optional)
    internal_lb_iteration             = "0"                      #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    public_lb_iteration               = null                     #(Optional) Id of the public Load Balancer, set to null or delete the line if there is no public Load Balancer
    public_ip_iteration               = null                     #(Optional) Id of the public Ip, set to null if there is no public Ip
  }
}

linux_storage_image_reference = {

  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "Latest"

}

## Boot Diagnostics for VMs
enable_log_analytics_dependencies = false
