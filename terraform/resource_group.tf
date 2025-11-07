removed {
  from = azurerm_resource_group.rg

  lifecycle {
    destroy = false
  }
}
