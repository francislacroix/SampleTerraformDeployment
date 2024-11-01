# Create the container registry
module "OpenWebUI" {
  source = "../modules/appservicecontainer"
  
  AppServiceResourceGroupName     = var.AppServiceResourceGroupName
  AppServiceName                  = var.AppServiceName
  ContainerName                   = "openwebui"
  ContainerImage                  = "evachatacrfl.azurecr.io/openwebui:latest"
  IsMainContainer                 = true
  TargetPort                      = "8080"
  EnvironmentVaribles             = [
      {
        name = "ENABLE_OLLAMA_API"
        value = "false"
      },
      {
        name = "OPENAI_API_BASE_URL"
        value = "http://localhost:9099"
      },
      {
        name = "OPENAI_API_KEY"
        value = "0p3n-w3bu!"
      }
    ]
  volumeMounts                    = []
}

module "OpenWebUIPipelines" {
  source = "../modules/appservicecontainer"
  
  AppServiceResourceGroupName     = var.AppServiceResourceGroupName
  AppServiceName                  = var.AppServiceName
  ContainerName                   = "openwebuipipelines"
  ContainerImage                  = "evachatacrfl.azurecr.io/openwebuipipelines:latest"
  IsMainContainer                 = false
  TargetPort                      = "9099"
  EnvironmentVaribles             = [
      {
        name = "PIPELINES_URLS"
        value = "https://github.com/francislacroix/open-webui-pipelines/blob/main/examples/pipelines/providers/azure_openai_pipeline.py"
      }
    ]
}