# Create MySQL Server and MySQL Databases in Azure
This Module allows you to create and manage MySQL Server and one or many MySQL Databases in Microsoft Azure.

## Features
This module will:

- Create MySQL Server in Microsoft Azure.
- Create one or many MySQL Databases with in the created MySQL Server.
- Set the MySQL Server configuration parameters.
- Create one or many MySQL Virtual Network Rules.
- Create one or many MySQL Firewall Rules.
- Allow/Deny Public Network Access to MySQL Server.
- Add MySQL Server Admin Login Password to Key Vault secrets.

## Usage
```hcl
module "MySqlDatabase" {
  source                              = "../../common-library/TerraformModules/MySqlDatabase"
  resource_group_name                 = module.BaseInfrastructure.resource_group_name
  subnet_ids                          = module.BaseInfrastructure.map_subnet_ids
  key_vault_id                        = module.BaseInfrastructure.key_vault_id
  server_name                         = var.server_name
  database_names                      = var.database_names
  administrator_login_password        = var.administrator_login_password
  administrator_login_name            = var.administrator_user_name
  allowed_subnet_names                = var.allowed_subnet_names
  sku_name                            = var.sku_name
  mysql_version                       = var.mysql_version
  storage_mb                          = var.storage_mb
  backup_retention_days               = var.backup_retention_days
  geo_redundant_backup                = var.geo_redundant_backup
  auto_grow                           = var.auto_grow
  private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  mysql_additional_tags               = var.additional_tags
  firewall_rules                      = var.firewall_rules
  mysql_configurations                = var.mysql_configurations
}
```

## Example 
Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the resource group module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the resource group module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the resource group module.

## Best practices for variable declaration/defination
- All names of the Resources should be defined as per AT&T standard naming conventions.

- While declaring variables with data type 'map(object)' or 'object; or 'list(object)', It's mandatory to define all the attributes in object. If you don't want to set any attribute then define its value as null or empty list([]) or empty map({}) as per the object data type.

- Please make sure all the Required paramaters are set. Refer below section to understand the required and optional input values when using this module.

- Please verify that the values provided to the variables are in comfort with the allowed values for that variable. Refer below section to understand the allowed values for each variable when using this module.

## Inputs
### **Required Parameters**
These variables must be set in the ```module``` block when using this module.
#### resource_group_name   ```string```
    Description: Specifies the name of the resource group in which to create the MySQL Server.
#### subnet_ids     ```Map(string)```
    Description: Specifies the Map of Subnet Id's.
#### key_vault_id   ```string```
    Description: The Id of the Key Vault to which all secrets should be stored.
#### server_name    ```string```
    Description: Specifies the name of the MySQL Server. Changing this forces a new resource to be created. This needs to be globally unique within Azure.
#### database_names     ```list(string)```
    Description: Specifies the list of MySQL Database names.
#### administrator_login_name   ```string```
    Description:  The Administrator Login for the MySQL Server.

    Default: "dbadmin"
#### administrator_login_password   ```string```
    Description: The Password associated with the administrator_login for the MySQL Server.
#### sku_name   ```string```
    Description: Specifies the SKU Name for this MySQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8).

    Default: "GP_Gen5_2"
#### mysql_version  ```number```
    Description:  Specifies the version of MySQL to use. Valid values are 5.6, 5.7, and 8.0. Changing this forces a new resource to be created.

    Default: 5.7
#### storage_mb     ```number```
    Description: Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs.

    Default: 5120
#### private_endpoint_connection_enabled    ```bool```
    Description: Specify if only private endpoint connections will be allowed to access this resource.

    Default: false
#### allowed_subnet_names   ```list(string)```
    Description: The list of subnet names that the MySQL server will be connected to.

### **Optional Parameters**
#### mysql_additional_tags     ```map(string)```
    Description: A mapping of tags to assign to the resource. Specifies additional MySQL Server resources tags, in addition to the resource group tags.

    Default: {}
#### backup_retention_days  ```number```
    Description: Backup retention days for the server, supported values are between 7 and 35 days.

    Default: 7
#### geo_redundant_backup   ```string```
    Description:  Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier.

    Default: "Disabled"
#### auto_grow      ```string```
    Description: Defines whether autogrow is enabled or disabled for the storage. Valid values are Enabled or Disabled.

    Default: "Disabled"
#### mysql_configurations   ```map(any)```
    Description: Map of MySQL configuration settings to create. Key is name, value is server parameter value.

    Default: {}
#### firewall_rules         ```map(object({}))```
    Description: Specifies the Map of objects containing attributes for MySQL Server firewall Rules.
     
```hcl
Default: {
            "default" = {
                name             = "mysql-firewall-rule-default"
                start_ip_address = "0.0.0.0"
                end_ip_address   = "0.0.0.0"
            }
        }
```
| Attribute  | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: |  :------------- |  :------------- |
| name | string | Required | Specifies the name of the MySQL Firewall Rule. Changing this forces a new resource to be created. | |
| start_ip_address | string | Required | Specifies the Start IP Address associated with this Firewall Rule. Changing this forces a new resource to be created. | |
| end_ip_address | string | Required |  Specifies the End IP Address associated with this Firewall Rule. Changing this forces a new resource to be created. | |

## Outputs
#### mysql_server_id
    Description: The server id of MySQL Server.
#### mysql_server_name
    Description: The server name of MySQL Server.
#### mysql_fqdn
    Description: The FQDN of MySQL Server.
#### admin_username
    Description: The administrator username of MySQL Server.
#### mysql_databases_names
    Description: List of all MySQL database resource names.
#### mysql_database_ids
    Description: The list of all MySQL database resource ids.
#### mysql_firewall_rule_ids
    Description: List of MySQL Firewall Rule resource ids.
#### mysql_vnet_rule_ids
    Description: The list of all MySQL VNet Rule resource ids.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference
[azurerm_mysql_server](https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html) <br/>
[azurerm_mysql_database](https://www.terraform.io/docs/providers/azurerm/r/mysql_database.html) <br/>
[azurerm_mysql_virtual_network_rule](https://www.terraform.io/docs/providers/azurerm/r/mysql_virtual_network_rule.html) <br/>
[azurerm_mysql_firewall_rule](https://www.terraform.io/docs/providers/azurerm/r/mysql_firewall_rule.html) <br />
[azurerm_mysql_configuration](https://www.terraform.io/docs/providers/azurerm/r/mysql_configuration.html)