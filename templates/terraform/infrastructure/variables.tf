#Variables used by terraform to populate from tfvars file for all infrastructure resources
variable "ResourceGroupName" {
    description = "Name of the resource group in which to create the resources"
    type        = string
}

variable "ResourceGroupLocation" {
    description = "Location of the resource group in which to create the resources"
    type        = string
    default     = "canadacentral"
}

variable "VirtualNetworkResourceGroupName" {
    description = "Name of the resource group which contains the virtual network to use for private endpoints and integration"
    type        = string
}

variable "VirtualNetworkName" {
    description = "Name of the virtual network to attach the private endpoints"
    type        = string
}

variable "PrivateEndpointSubnetName" {
    description = "Name of the subnet to attach the private endpoints"
    type        = string
}

variable "IntegrationSubnetName" {
    description = "The name of the subnet for integration"
    type        = string
}

variable "ContainerRegistryName" {
    description = "Name of the container registry"
    type        = string
}

# Variable to store key vault name
variable "KeyVaultName" {
    description = "Name of the key vault"
    type        = string
}

variable "StorageAccountName" {
    description = "Name of the storage account"
    type        = string
}

variable "StorageFileShareName" {
    description = "Name of the storage file share"
    type        = string
}

variable "AppServiceName" {
    description = "The name of the App Service"
    type        = string
}

