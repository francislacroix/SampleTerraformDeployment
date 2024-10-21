# Reference the existing subnet
data "azurerm_subnet" "private_endpoint_subnet" {
    name                 = var.SubnetName
    virtual_network_name = var.VirtualNetworkName
    resource_group_name  = var.VirtualNetworkResourceGroupName
}

//Create Storage Account
resource "azurerm_storage_account" "storageaccount" {
  name                     = var.StorageAccountName
  resource_group_name      = var.ResourceGroupName
  location                 = var.ResourceGroupLocation
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

//Create File Share
resource "azurerm_storage_share" "fileshare" {
  name                 = var.StorageFileShareName
  storage_account_name = azurerm_storage_account.storageaccount.name
  quota                = 100
}

#Create Private Endpoint
resource "azurerm_private_endpoint" "fs_pe" {
  name                = "${var.StorageAccountName}-pe"
  resource_group_name = var.ResourceGroupName
  location            = var.ResourceGroupLocation
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_service_connection {
    name                           = "${var.StorageAccountName}-connection"
    private_connection_resource_id = azurerm_storage_account.storageaccount.id
    is_manual_connection           = false
    subresource_names = ["file"]
  }

  lifecycle {
    ignore_changes = [
      tags,
      private_dns_zone_group
    ]
  }
}