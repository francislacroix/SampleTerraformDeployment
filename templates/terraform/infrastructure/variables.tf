#Variables used by terraform to populate from tfvars file for all infrastructure resources
variable "ResourceGroupName" {
    description = "Name of the resource group in which to create the container registry"
    type        = string
}

variable "ResourceGroupLocation" {
    description = "Location of the resource group in which to create the container registry"
    type        = string
    default     = "canadacentral"
}

variable "ContainerRegistryName" {
    description = "Name of the container registry"
    type        = string
}

variable "ContainerAppEnvironmentName" {
    description = "Name of the container registry"
    type        = string
}

variable "VirtualNetworkResourceGroupName" {
    description = "Name of the resource group which contains the virtual network to attach the ACR"
    type        = string
}

variable "VirtualNetworkName" {
    description = "Name of the virtual network to attach the ACR"
    type        = string
}

variable "PrivateEndpointSubnetName" {
    description = "Name of the subnet to attach the ACR"
    type        = string
}

variable "ContainerAppEnvironmentSubnetName" {
    description = "Name of the subnet to attach the ACR"
    type        = string
}

variable "AllowedCIDRBlocks" {
    description = "List of CIDR blocks to allow access to the container registry"
    type        = list(string)
    default     = null
}

variable "DataSubnetName" {
    description = "Name of the subnet to attach the data resources"
    type        = string
}

# Variable to store key vault name
variable "KeyVaultName" {
    description = "Name of the key vault"
    type        = string
}

variable "workspace" {
  description = "Name of the Log Analytics Workspace."
  type        = string
}

variable "logsrg" {
  description = "Name of the Log Analytics WorkspaceResource Group."
  type        = string
}

variable "straccountname" {
  description = "Name of the Storage Account."
  type        = string
}

variable "StorageFileShareName" {
  description = "Name of the Storage File Share."
  type        = string
}

variable "StorageNginxConfigFileShareName" {
  description = "Name of the Nginx Config File Share."
  type        = string
}

variable "redisname" {
  description = "Name of the Redis."
  type        = string
}

variable "postgresqlname" {
  description = "Name of the Postgre SQL."
  type        = string
}

variable "DBAdminLogin" {
  description = "The name of the Postgre SQL db admin."
  type        = string
}

variable "DBAdminPassword" {
  description = "The password of the Postgre SQL db admin."
  type        = string
  sensitive   = true
}

variable "mongodbname" {
  description = "Name of the CosmosDB."
  type        = string
}
variable "WorkloadProfiles" {
    description = "List of workload profiles to create for the container app environment"
    type        = list(object({
        name           = string
        type           = string
        minimum_count  = number
        maximum_count  = number
    }))
    default     = []
}
variable "loganalyticssku" {
    description = "SKU for Log Analytics Workspace"
    type        = string
}

variable "appinsightsname" {
  description = "The name of the Application Insights component."
  type        = string
}

variable "appinsightstype" {
  description = "The type of the Application Insights."
  type        = string
}