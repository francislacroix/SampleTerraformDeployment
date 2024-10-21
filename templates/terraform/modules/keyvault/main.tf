# Reference the existing subnet
data "azurerm_subnet" "private_endpoint_subnet" {
    name                 = var.SubnetName
    virtual_network_name = var.VirtualNetworkName
    resource_group_name  = var.VirtualNetworkResourceGroupName
}

# Get the current config
data "azurerm_client_config" "current" {}

# Create Azure key Vault
resource "azurerm_key_vault" "keyvault" {
  name                       = var.KeyVaultName
  resource_group_name        = var.ResourceGroupName
  location                   = var.ResourceGroupLocation

  tenant_id                  = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  enable_rbac_authorization = true

  public_network_access_enabled = false

  sku_name = "standard"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

#set Private endpoint for Keyvault
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${var.KeyVaultName}-pe"
  resource_group_name = var.ResourceGroupName
  location            = var.ResourceGroupLocation
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_service_connection {
    name                           = "${var.KeyVaultName}-connection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names = ["Vault"]
  }

  lifecycle {
    ignore_changes = [
      tags,
      private_dns_zone_group
    ]
  }
}

  