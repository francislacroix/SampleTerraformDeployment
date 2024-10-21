# Create the resource group that will contain the app infrustructure resources
resource "azurerm_resource_group" "infrastructure_rg" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation

  tags = {
      ClientOrganization = "ESDC"
  }
}

# Create the container registry
module "ContainerRegistry" {
  source = "../modules/containerregistry"
  
  ResourceGroupName               = azurerm_resource_group.infrastructure_rg.name
  ResourceGroupLocation           = azurerm_resource_group.infrastructure_rg.location
  ContainerRegistryName           = var.ContainerRegistryName
  VirtualNetworkResourceGroupName = var.VirtualNetworkResourceGroupName
  VirtualNetworkName              = var.VirtualNetworkName
  SubnetName                      = var.PrivateEndpointSubnetName
}

# Create the KeyVault
module "KeyVault" {
  source = "../modules/keyvault"

  ResourceGroupName               = azurerm_resource_group.infrastructure_rg.name
  ResourceGroupLocation           = azurerm_resource_group.infrastructure_rg.location
  KeyVaultName                    = var.KeyVaultName
  VirtualNetworkResourceGroupName = var.VirtualNetworkResourceGroupName
  VirtualNetworkName              = var.VirtualNetworkName
  SubnetName                      = var.PrivateEndpointSubnetName
}

#Call to Storage Account module
module "StorageAcount" {
  source = "../modules/storageaccount"

  ResourceGroupName               = azurerm_resource_group.infrastructure_rg.name
  ResourceGroupLocation           = azurerm_resource_group.infrastructure_rg.location
  StorageAccountName              = var.straccountname
  StorageFileShareName            = var.StorageFileShareName
  VirtualNetworkResourceGroupName = var.VirtualNetworkResourceGroupName
  VirtualNetworkName              = var.VirtualNetworkName
  SubnetName                      = var.PrivateEndpointSubnetName
}