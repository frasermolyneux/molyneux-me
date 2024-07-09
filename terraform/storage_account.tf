resource "azurerm_storage_account" "app_data_storage" {
  name                = local.app_data_storage_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  blob_properties {
    change_feed_enabled           = true
    change_feed_retention_in_days = 14

    restore_policy {
      days = 14
    }

    delete_retention_policy {
      days = 28
    }

    container_delete_retention_policy {
      days = 28
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "images_container" {
  name = "images"

  storage_account_name  = azurerm_storage_account.app_data_storage.name
  container_access_type = "blob"
}
