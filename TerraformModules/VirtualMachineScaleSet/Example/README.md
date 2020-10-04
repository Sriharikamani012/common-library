## Create Virtual Machine Scaleset in Azure.
This module allows you to create virtual machine scale set in Azure.

## Features
 1. you can deploy multiple VMSS in an existing resource group.
 2. create public and private ssh key for login and store them in key vault.
 3. Encrypt both os and data disks of VMSS using customer managed key.
 4. Enable MSI on VMSS.

## Example of Module Consumption
```hcl
module "VirtualmachineScaleSet" {
source = "../../common-library/TerraformModules/VirtualMachineScaleSet"
resource_group_name = module.BaseInfrastructure.resource_group_name
key_vault_id = module.BaseInfrastructure.key_vault_id
virtual_machine_scalesets = var.vmss
linux_image_id = var.linux_image_id
administrator_user_name = var.administrator_user_name
administrator_login_password = var.administrator_login_password
subnet_ids = module.BaseInfrastructure.map_subnet_ids
lb_probe_id = module.LoadBalancer.pri_lb_probe_ids #(Optional set it to null)
pri_lb_backend_ids = module.LoadBalancer.pri_lb_backend_ids #(Optional set it to null)
sa_bootdiag_storage_uri = module.BaseInfrastructure.primary_blob_endpoint[0] #(Mandatory)
diagnostics_sa_name = module.BaseInfrastructure.sa_name[0]
workspace_id = module.BaseInfrastructure.law_workspace_id
workspace_key = module.BaseInfrastructure.law_key
vmss_additional_tags = var.additional_tags
zones = module.LoadBalancer.pri_lb_zones
}

```

## Example 
Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the VMSS module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the VMSS module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the VMSS module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming     conventions.
2.  While declaring variables with data type  'map(object)'. It's mandatory      to define all the objects.If you don't want to use any specific              objects define it as null or empty list as per the object data type.
    
     - for example:
     ```hcl
      variable "example" {
      type = map(object({
      name         = string 
      permissions  = list(string) 
      cmk_enable   = bool 
      auto_scaling = string 
      })) 
     ```
      
     - In above example, if you don't want to use the objects permissions and auto_scaling, you can define it as below.
     ```hcl
       example = {
          name = "example"
          permissions = []
          auto_scaling = null
          }
    ```       
3.  Please make sure all the Required paramaters are declared.Refer below 
    section to understand the required and optional paramters of this module. 

4. Please verify that the values provided to the variables are with in the      allowed values.Refer below section to understand the allowed values to       each paramter.
    
## Inputs

# **Required Parameters**

## resource_group_name   ```string```
    The name of the resource group in which the VMSS will be  created.

## virtual_machine_scalesets  ```map(object({}))```
    Define map of virtual machine scalesets.
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of the virtual machine| NA |
| vm_size   | string | Required | Size  of the virtual machine| NA |
| zone   | string | Optional | Availability zone for VM | NA |
| assign_identitty   | bool | Optional | assign managed system identity for the VM | NA |
| subnet_name   | string | Optional | name of the subnet in which VM should be deployed| NA |
| internal_lb_iteration  |number | Optional | id of the load balancer| NA |
| disable_password_authentication  |bool | Optional | disable password authentication | NA |
| source_image_reference_publisher  |string | Optional |publisher name of source image reference  | NA |
| source_image_reference_offer  |string | Optional |offer name of source image reference  | NA |
| source_image_reference_sku  |string | Optional |sku name of source image reference  | NA |
| source_image_reference_version |string | Optional |version name of source image reference  | NA |
| storage_os_disk_caching |string | Optional |Disk caching of OS caching | NA |
| managed_disk_type |string | Optional | pecifies the type of managed disk to create. | Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS |
| disk_size_gb |string | Optional | size of the OS Disk | NA |
| write_accelerator_enabled |bool | Optional | enable write accelerator for os disk  | NA |
| enable_disk_encryption_set |bool | Optional | enable disk encryption set for the VM | NA |
| internal_dns_name_label |string | Optional | internal DNS label name for NIC | NA |
| enable_ip_forwarding |bool | Optional | enable IP forwarding on NIC | NA |
| enable_accelerated_networking |bool | Optional | enable accelerated networking on NIC | NA |
| dns_servers |list(string) | Optional | list of DNS servers on nic | NA |
| static_ip  |string | Optional | static IP of NIC | NA |
| recovery_services_vault_key  |string | Optional | key name of recovery servie vault | NA |
| storage_profile_data_disk  |list(object) | Optional | key name of recovery servie vault | NA |
|  custom_data_path |string | Optional |  path for custom data filed | NA |

## storage_profile_data_disk ```list(object)```
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| lun  | string | Required | Specifies the logical unit number of the data disk| NA |
| storage_account_type  | string | Required | Specifies the logical unit number of the data disk| NA |
| disk_size | string | optional | Specifies the size of the data disk in gigabytes.| NA |
| caching | string | Optional| Specifies the caching requirements for the Data Disk| None, ReadOnly and ReadWrite|
| write_accelerator_enabled | string | Optional| Specifies if Write Accelerator is enabled on the disk | NA|    
    
## subnet_ids ```map(string)```
    subnet id in which VMSS needs to be created.

## diagnostics_sa_name ```string```
    storage account name where the diagnostic logs will be stored.

## sa_bootdiag_storage_uri ```string```
    URI of the blob diagnostic storage account in which boot diagnostic logs will be stored.

## workspace_id ```string```
    log analytics work space id   

## key_vault_id ```string```
    resource Id of the key vault where the ssh keys will be stored.

## administrator_user_name ```string```
    username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.   
              

# **Optional Parameters**

## pri_lb_backend_ids ```string```
    backendpool id of load balancer to which VMSS to be added

## lb_probe_id  ```string``` 
    health probe id of load balancer for rolling upgrade policy

## linux_image_id  ```string```   
    The ID of an Image which each instance in this Scale Set should be based on
## administrator_login_password  ```string```  
    username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.

## tags  ```map(string)```
    A mapping of tags to assign to the resource. 
## Outputs

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference
[azurerm_linux_virtual_machine_scale_set](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html) <br />     

