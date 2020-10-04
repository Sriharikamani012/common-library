# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.1] - 2020-05-29
### Added
- Custom arguments to cloud-init script on VM and VMSS  [#87956](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/87956)
- Add VMInsights Extension to VM and VMSS [#91786](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91786)
- Add VMInsights Solution to Log Analytics Workspace [#91785](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91785)
- Added Azure Firewall Module [#87953](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/87953)

### Changed
- Refactor DNSARecord to accept custom names from user [#91829](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91829)
- Update DNSARecord Module to support multiple DNSARecord Creation [#91828](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91828)
- Enable/Disable Creation of DNS A Record from config [#91827](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91827)
- As a CD pipeline, I need to specify the name of the DNS A record entirely. [#81671](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81671)
- As a CD pipeline, I need to create multiple DNS A records per Private Endpoint [#81673](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81673)
- Refactor Azure Monitor to add Scheduled Query Rule Alerts [#91783](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91783)
- Update Azure Monitor Example Folder and Readme File [#91784](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91784)
- Create Feature of adding NIC to multiple backend pools of LB's [#91773](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91773)

## [0.4.0] - 2020-05-19
### Added
- Create private DNS zones and link for ADO agents [#90128](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/90128)
- Storage Account Module - Document Security Decisions in Code [#71740](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71740)
- VM Module - Document Security Decisions in Code [#71739](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71739)
- Added Example directories for VM,VMSS,storage account,log Analytics, key vault, Load balancer modules [#75892](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/75892)
- Added Public IP and outbound rules in LB module [#87243](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/87243)
- Create Azure Monitor Module [#87266](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/87266)
- BaseInfrastructure - Create examples directory with sample code [#71742](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71742)
- MySQLDatabase - Create examples directory with sample code [#75896](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75896)
- AzureSQLDatabase - Create examples directory with sample code [#81733](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81733)
- CosmosDB - Create examples directory with sample code [#81734](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81734)
- Ability to pass a custom data script from the VMSS jumpstart kit [#71435](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71435)
- Ability to pass a custom data script from the VM jumpstart kit [#75585](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75585)
- Azure Kubernetes Service module for jumpstart-aks [#24092](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/24092)

### Changed
- Override default storage diagnostics config in VM/VMSS [#88965](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/88965)
- Enable Large File Shares In SA Module [#89826](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/89826)
- Refactor Azure Monitor to accept resource_ids as an input from VM/VMSS output map [#89852](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/89852)

## [0.3.0] - 2020-05-07
### Added
- Create Application Insights module [#80610](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/80610)
- Remove PaasDB naming helpers (only user defined) [#72020](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/72020)
- PaasDB Separate DB providers into their own modules [#71745](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71745)
- Added Disk Encryption set for VM [#80977](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/80977)
- Added Network watcher extension to VM and VMSS module[#71746](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71746)
- Added Disk Encryption set for VMSS[#59512](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/59512)
- Set Backup Policy For VM [#75678](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75678)
- Create Recovery Vault module [#76284](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/76284)
- Added Vnet peering for Virtual networks [#52314](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/52314)

### Changed
- Removed references to VP Tower [#82735](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82735)
- Removed $repoPath in favour of $Build.Repository.Name [#82276](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82276)
- Remove "-arecord" from DNS name [#81666](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81666)
- Refactor VM or VMSS to attach specific load balancer backend pool [#82282](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82282)
- Refactor VNet Peering [#81593](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81593)
- KeyVault diagnostics should go to a storage account [#80468](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/80468)
- Refactor Load Balancer Module to support multiple Frontend IP's [#76289](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/76289)

## [0.2.0] - 2020-04-21
### Added
- Added customer managed key encryption for storage account [#50482](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/50482)
- Added key vault access policies to the storage MSI [#55871](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/55871)
- Enabled purge protection on key vault and set both purge protection and soft-delete to true by default [#70204](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/70204)
- Added PLS Terraform Module [#53447](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/53447)
- Enabled VMSS MSI identity & created KV access policy for VMSS Identity [#53437](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/53437)
- Added a publish pipeline artifact task to the Image Builder pipeline, publishing the Image ID created as a terraform .tfvars file for the next stage to consume [#7273](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/7273)
- Added a download pipeline artifact task to the Terraform pipeline to consume the generated image id (optional) [#7273](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/7273)
- Enable firewall on storage accounts [#43428](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43428)


### Changed
- Private Endpoints to trigger on resource type creation [#35855](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/35855)
- Correct 01,02,03,etc file names in VMSS, VM, BaseInfra [#53719](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/53719)
- Change Private Endpoint names in PE module [#43430](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43430)
- Rename MSSQL to AzureSQL in PaaS module [#43434](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43434)
- Refactored Existing Storage account TF module to multiple storage account [#43431](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/43431)
- Enable SQL firewall [#43435](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43435)
- Load Balancer naming convention changed to user defined [#43424](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43424)
- User must provide unique Log Analytics and Storage Account name for base infrastructure  [#59207](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/59207)
- User must provide the names of the SPN for the VP tower subscription and the application SPN as well as the object ID for the application SPN in order to access terraform state in VP subscription and deploy resources to application subscription [#24109](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/24109) 
- Bumped up Packer task version used on Image Builder to v1.5.1 [#33642](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/33642)
- User must provide unique Keyvault name instead of TF adjusting name to ensure unique  [#57893](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/57893)
- Refactored VM Module and Resolved naming convention issue for VM and VMSS Module  [#51432](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/51432)
- Stage.yaml in kits runs as an one job, which means Terraform.yaml is only tasks [#43423](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43423)
- Vnets names are now user defined without TF adding appending to the name [#43437](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43437)
- Resolved VMSS timeout issue in pipeline  [#47655](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/47655)
- Changes to the VM module include accepting an image_id variable when creating a Linux VM from a jumpstart kit either manually or generated from Image Builder. [#7273](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/7273)

### Removed

- AZ CLI Task that would Push the image version to a Shared Image Gallery, this is being done by the Packer task instead [#33642](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/33642)

## [0.1.0] - 2020-03-23
### Added
- Initial release

[Unreleased]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library
[0.1.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.1
[0.2.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.2.0
[0.3.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.3.0
[0.4.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.4.0
[0.4.1]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.4.1