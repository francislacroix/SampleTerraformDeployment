# Create App Service
data "azurerm_linux_web_app" "appservice" {
  name                = var.AppServiceName
  resource_group_name = var.AppServiceResourceGroupName
}

resource "azapi_resource" "appservice_container" {
  type = "Microsoft.Web/sites/sitecontainers@2024-04-01"
  name = var.ContainerName

  parent_id = data.azurerm_linux_web_app.appservice.id
 
  body = {    
    properties = {
      authType = "SystemIdentity"
      userManagedIdentityClientId = "SystemIdentity"
      image = var.ContainerImage
      isMain = var.IsMainContainer
      targetPort = var.TargetPort
      environmentVariables = var.EnvironmentVaribles
      volumeMounts = var.volumeMounts
    }
  }
}