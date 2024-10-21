variable "ResourceGroupName" {
    description = "Name of the resource group in which to create the Storage Account"
    type        = string
}

variable "ResourceGroupLocation" {
    description = "Location of the resource group in which to create the Storage Account"
    type        = string
    default     = "canadacentral"
}

variable "StorageAccountName" {
  type        = string
  description = "The name of the Storage Account."
}

variable "VirtualNetworkResourceGroupName" {
    description = "Name of the resource group which contains the virtual network to attach the Storage Account"
    type        = string
}

variable "VirtualNetworkName" {
    description = "Name of the virtual network to attach the Storage Account"
    type        = string
}

variable "SubnetName" {
    description = "Name of the subnet to attach the Storage Account"
    type        = string
}

variable "StorageFileShareName" {
  type        = string
  description = "The name of the Storage File Share."
}