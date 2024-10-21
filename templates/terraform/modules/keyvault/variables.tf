variable "ResourceGroupName" {
    description = "Name of the resource group in which to create the Key Vault"
    type        = string
}

variable "ResourceGroupLocation" {
    description = "Location of the resource group in which to create the Key Vault"
    type        = string
    default     = "canadacentral"
}

variable "KeyVaultName" {
  type        = string
  description = "The name of the Key Vault."
}

variable "VirtualNetworkResourceGroupName" {
    description = "Name of the resource group which contains the virtual network to attach the Key Vault"
    type        = string
}

variable "VirtualNetworkName" {
    description = "Name of the virtual network to attach the Key Vault"
    type        = string
}

variable "SubnetName" {
    description = "Name of the subnet to attach the Key Vault"
    type        = string
}


