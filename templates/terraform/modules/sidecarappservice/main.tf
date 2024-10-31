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

  logs {
    application_logs {
      file_system_level = "Verbose"
    }

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 50
      }
    }

    detailed_error_messages = true
    failed_request_tracing = true
  }

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

resource "azapi_resource" "appservice_main_container" {
  type = "Microsoft.Web/sites/sitecontainers@2024-04-01"
  name = "openwebui"

  parent_id = azurerm_linux_web_app.appservice.id

  body = {
    properties = {
      # authType = "SystemIdentity"
      # userManagedIdentityClientId = "SystemIdentity"
      authType: "UserCredentials"
      userName: "flacr"
      image = "flacr.azurecr.io/openwebui:latest"
      isMain = true
      targetPort = "8080"
      environmentVariables = [
        {
          name = "ENABLE_OLLAMA_API"
          value = "false"
        }
      ]
      volumeMounts = [
        # {
        #   containerMountPath = "string"
        #   data = "string"
        #   readOnly = bool
        #   volumeSubPath = "string"
        # }
      ]
    }
  }
}

# resource "azapi_resource" "appservice_pipelines_container" {
#   type = "Microsoft.Web/sites/sitecontainers@2024-04-01"
#   name = "openwebuipipelines"

#   parent_id = azurerm_linux_web_app.appservice.id

#   body = {
#     properties = {
#       authType = "SystemIdentity"
#       userManagedIdentityClientId = "SystemIdentity"
#       image = "flacr.azurecr.io/openwebuipipelines:latest"
#       isMain = false
#       targetPort = "9099"
#       environmentVariables = []
#       volumeMounts = []
#     }
#   }
#}