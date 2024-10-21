# Reference the existing subnet
data "azurerm_subnet" "private_endpoint_subnet" {
    name                 = var.SubnetName
    virtual_network_name = var.VirtualNetworkName
    resource_group_name  = var.VirtualNetworkResourceGroupName
}

# Create the container registry
resource "azurerm_container_registry" "container_registry" {
  name                = var.ContainerRegistryName
  resource_group_name = var.ResourceGroupName
  location            = var.ResourceGroupLocation
  sku                 = "Premium" # Premium SKU is required for VNet private endpoints and network rule sets
  admin_enabled       = false

  # Block public access, only allow acces from private endpoints
  #public_network_access_enabled = false
#Ignore Resource Group existing tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create the private endpoint for the container registry
resource "azurerm_private_endpoint" "container_registry_private_endpoint" {
  name                = "${var.ContainerRegistryName}-pe"
  resource_group_name = var.ResourceGroupName
  location            = var.ResourceGroupLocation
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_service_connection {
    name                           = "${var.ContainerRegistryName}-connection"
    private_connection_resource_id = azurerm_container_registry.container_registry.id
    subresource_names              = ["registry"]
    is_manual_connection           = false 
  }

  lifecycle {
    ignore_changes = [
      tags,
      private_dns_zone_group
    ]
  }
}

# Create the scope maps to be used (for example, to grant read/write access only to the incoming namespace)
resource "azurerm_container_registry_scope_map" "incoming_read_write_access" {
  name                    = "incomingReadWriteAccess"
  container_registry_name = azurerm_container_registry.container_registry.name
  resource_group_name     = azurerm_container_registry.container_registry.resource_group_name
  actions = [
    "repositories/incoming/*/content/read",
    "repositories/incoming/*/content/write"
  ]
}
# Create the scope maps to be used (for example, to grant read/write access only to the internal and incoming namespace)
resource "azurerm_container_registry_scope_map" "incoming_promoted_read_write_access" {
  name                    = "incomingPromotedReadWriteAccess"
  container_registry_name = azurerm_container_registry.container_registry.name
  resource_group_name     = azurerm_container_registry.container_registry.resource_group_name
  actions = [
    "repositories/incoming/*/content/read",
    "repositories/incoming/*/content/write",
    "repositories/promoted/*/content/read",
    "repositories/promoted/*/content/write"
  ]
}

# Generate the tokens that can be used to authenticate to the container registry
resource "azurerm_container_registry_token" "incoming_only_token" {
  name                    = "incomingOnlyToken"
  container_registry_name = azurerm_container_registry.container_registry.name
  resource_group_name     = azurerm_container_registry.container_registry.resource_group_name
  scope_map_id            = azurerm_container_registry_scope_map.incoming_read_write_access.id
}
# Generate the tokens that can be used to authenticate to the container registry
resource "azurerm_container_registry_token" "incoming_and_promoted_token" {
  name                    = "incomingAndPromotedToken"
  container_registry_name = azurerm_container_registry.container_registry.name
  resource_group_name     = azurerm_container_registry.container_registry.resource_group_name
  scope_map_id            = azurerm_container_registry_scope_map.incoming_promoted_read_write_access.id
}

