variable "ResourceGroupName" {
    description = "The name of the resource group"
    type        = string
}

variable "ResourceGroupLocation" {
    description = "The location of the resource group"
    type        = string
}

variable "AppServiecName" {
    description = "The name of the App Service"
    type        = string
}

variable "VirtualNetworkResourceGroupName" {
    description = "The name of the resource group containing the virtual network"
    type        = string
}

variable "VirtualNetworkName" {
    description = "The name of the virtual network"
    type        = string
}

variable "PrivateEndpointSubnetName" {
    description = "The name of the subnet for the private endpoint"
    type        = string
}

variable "IntegrationSubnetName" {
    description = "The name of the subnet for integration"
    type        = string
}