resource "azurerm_storage_account" "app_data_storage" {
  name                = local.app_data_storage_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  local_user_enabled        = false
  shared_access_key_enabled = false

  blob_properties {
    change_feed_enabled           = true
    change_feed_retention_in_days = 28

    versioning_enabled = true

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

  storage_account_id    = azurerm_storage_account.app_data_storage.id
  container_access_type = "blob"
}
