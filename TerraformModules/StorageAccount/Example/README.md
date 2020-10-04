## Create Storage Account in Azure.
    This Module allows you to create storage account in azure.

## Features
   1. create multiple Storage accounts in an existing resource
   2. create containers,blobs,queues,tables, file shares in a storage account.
   3. encrypt the storage account using customer managed key.
   4. Enable MSI identity for a storage account.

## usage
```hcl
module "StorageAccount" {   
  source              = "../../common-library/TerraformModules/StorageAccount"
  resource_group_name = var.resource_group_name
  storage_accounts    = var.storage_accounts
  containers          = var.containers
  blobs               = var.blobs
  queues              = var.queues
  file_shares         = var.file_shares
  tables              = var.tables
  sa_additional_tags  = var.tags
  # you can also consume the key vault id from base infra module as below
  key_vault_id       =  module.BaseInfrastructure.key_vault_id
  subnet_ids         =  module.BaseInfrastructure.map_subnet_ids 
  subnet_ids          = var.subnet_ids
  vnet_ids =  module.BaseInfrastructure.map_vnet_ids
 }
```

## Example 
Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the storage account module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the storage account module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the storage account module.

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

## resource_group_name  ```string```
    The name of the resource group in which storage account will be created.

## storage_accounts  ```map(object({}))```
    Map of storage accounts which needs to be created in a resource group
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of storage account| NA |
| sku   | string | Required | sku is the combination of combination of values of account_tier and account_replication_type. for example if your account_tier is "Standard" and account_replication_type is LRS, you should define it as 'Standard_LRS'.| NA | 
| account_kind   | string | Optional | Defines the Kind of account| BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 |
| access_tier   | string | Optional | Defines the Tier to use for this storage account| Standard,Premium |
| assign_identity   | bool | Optional | assign MSI to storage account| NA |
| cmk_enable   | bool | Optional | enable CMK encryption on storage account| NA | 
|network_rules   | object({}) | Optional |Network rules for storage account| NA |
|sa_pe_is_manual_connection  | bool | Optional | is approval required for the private endpoint connection| NA |
| sa_pe_subnet_name   | string | Optional | subnet name of private endpoint| NA |
| sa_pe_vnet_name   | string | Optional | vnet name to which private dns zone needs to be linked| NA |
| sa_pe_enabled_services   | list(string) | Optional | List of services to which private endpoint  needs to be created| blob,table,file |   
 
## network_rules ```object({})```
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| bypass  | string | Optional | list of services which needs to be bypassed | Logging, Metrics, AzureServices, or None |
| default_action  | string | Required | Specifies the default action of allow or deny when no other rules match | NA |
| ip_rules  | string | Optional | List of IP ranges in CIDR format | NA |
| virtual_network_subnet_ids  | string | Optional | List of resource id's of subnets needs to be whitelisted| NA |


# **Optional Parameters**

## containers ```map(object({}))```
    Map of Storage Containers to be created in a storage account.
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of container| NA |
| storage_account_name  | string | Required | Name of storage account| NA |
| container_access_type  | string | Optional | Name of storage account| blob, container or private. Defaults to private|

     
## blobs ```map(object({}))```
    Map of Storage blobs to be created in a storage account.
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of blob| NA |
| storage_account_name  | string | Required | Name of storage account| NA |
| storage_container_name  | string | Required | Name of storage container| NA |
| type  | string | Optional | The type of the storage blob to be created| Append, Block or Page|
| size | string | Optional | Used only for page blobs to specify the size in bytes of the blob to be created.| Append, Block or Page|
| type  | string | Optional | The type of the storage blob to be created| Append, Block or Page|
| content_type  | string | Optional | The content type of the storage blob| Append, Block or Page|
| source_uri  | string | Optional | The URI of an existing blob, or a file in the Azure File service, to use as the source contents for the blob to be created.| NA|
| metadata   | string | Optional | A map of custom blob metadata.| NA |

    

## file_shares ```map(object({}))``` 
    Map of Storages File Shares to be created in a storage account.
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of file share| NA |
| storage_account_name  | string | Required | Name of storage account| NA |
| quota  | string | Required | The maximum size of the share, in gigabytes. | For Standard storage accounts, this must be greater than 0 and less than 5120 GB (5 TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and less than 102400 GB (100 TB).  |    


## queues  ```map(object({}))```
    Map of storage queues to be created in a storage account.
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of queue| NA |
| storage_account_name  | string | Required | Name of storage account| NA |    

## tables  ```map(object({}))```
    Map of tables to be created in a storage account.
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- | :------------- |
| name   | string | Required | Name of the table| NA |
| storage_account_name  | string | Required | Name of storage account| NA |    

## sa_additional_tags ```map(string)```
    Map of tags for the storage account.

## subnet_ids ```map(string)```
    subnet id's in which private endpoints needs to be created.

## vnet_ids ```map(string)```
    VNET id's to which private DNS zones needs to be linked.

## key_vault_id ```string```
    resource id of key vault for creating access policies for storage MSI and creating a key for storage encryption.
## Outputs

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference
[azurerm_storage_account](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html) <br />
