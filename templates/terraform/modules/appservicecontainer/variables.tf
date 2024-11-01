variable "AppServiceResourceGroupName" {
    description = "Name of the resource group in which to create the Key Vault"
    type        = string
}

variable "AppServiceName" {
  type        = string
  description = "The name of the Key Vault."
}

variable "ContainerName" {
  type        = string
  description = "The name of the container"
}

variable "ContainerImage" {
  type        = string
  description = "The image of the container"
}

variable "IsMainContainer" {
  type        = bool
  description = "Is this the main container"
}

variable "TargetPort" {
  type        = string
  description = "The target port"
}

variable "EnvironmentVaribles" {
  type        = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables"
  default = []
}

variable "volumeMounts" {
  type        = list(object({
    containerMountPath = string
    data               = string
    readOnly           = bool
    volumeSubPath      = string
  }))
  description = "The volume mounts"
  default = []
}

