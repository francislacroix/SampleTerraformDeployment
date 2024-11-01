# Reference the existing integration subnet
data "azurerm_subnet" "integration_subnet" {
    name                 = var.IntegrationSubnetName
    virtual_network_name = var.VirtualNetworkName
    resource_group_name  = var.VirtualNetworkResourceGroupName
}

# Reference the existing private endpoint subnet
data "azurerm_subnet" "private_endpoint_subnet" {
    name                 = var.PrivateEndpointSubnetName
    virtual_network_name = var.VirtualNetworkName
    resource_group_name  = var.VirtualNetworkResourceGroupName
}

# Create App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.AppServiceName}-plan"
  resource_group_name = var.ResourceGroupName
  location            = var.ResourceGroupLocation
  os_type             = "Linux"
  sku_name            = "P0v3"
}

# Create App Service
resource "azurerm_linux_web_app" "appservice" {
  name                = var.AppServiceName
  resource_group_name = var.ResourceGroupName
  location            = var.ResourceGroupLocation

  service_plan_id     = azurerm_service_plan.appserviceplan.id

  https_only = true
  public_network_access_enabled = true //Change to false after debugging

  identity {
    type = "SystemAssigned"
  }

  # virtual_network_subnet_id = data.azurerm_subnet.integration_subnet.id

  site_config {}
}

resource "azapi_update_resource" "container_app_api" {
  type        = "Microsoft.Web/sites@2023-12-01"
  resource_id = azurerm_linux_web_app.appservice.id

  body = {
    properties = {
      siteConfig = {
        linuxFxVersion = "sitecontainers"
      }
    }
  }

  lifecycle {
    replace_triggered_by = [ azurerm_linux_web_app.appservice ]
  }
}

resource "azurerm_role_assignment" "acrReaderAccess" {
  scope                = var.ContainerRegistryID
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_web_app.appservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "acrPullAccess" {
  scope                = var.ContainerRegistryID
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.appservice.identity[0].principal_id
}