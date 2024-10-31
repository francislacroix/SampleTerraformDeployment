# Create the resource group that will contain the app infrustructure resources
resource "azurerm_resource_group" "application_rg" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}

# Create the container registry
module "AppService" {
  source = "../modules/sidecarappservice"
  
  ResourceGroupName               = azurerm_resource_group.application_rg.name
  ResourceGroupLocation           = azurerm_resource_group.application_rg.location
  AppServiceName                  = var.AppServiecName
  VirtualNetworkResourceGroupName = var.VirtualNetworkResourceGroupName
  VirtualNetworkName              = var.VirtualNetworkName
  PrivateEndpointSubnetName       = var.PrivateEndpointSubnetName
  IntegrationSubnetName           = var.IntegrationSubnetName
}