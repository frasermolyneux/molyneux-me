resource "azurerm_static_web_app" "app" {
  name                = local.static_web_app_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku_tier = "Free"
  sku_size = "Free"

  tags = var.tags
}

resource "azurerm_dns_cname_record" "app" {
  provider = azurerm.dns

  name                = var.dns.subdomain
  zone_name           = var.dns.domain
  resource_group_name = data.azurerm_dns_zone.primary.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.app.default_host_name
}

resource "time_sleep" "wait_for_cname" {
  depends_on = [azurerm_dns_cname_record.app]

  create_duration = "60s"
}

resource "azurerm_static_web_app_custom_domain" "app" {
  depends_on        = [time_sleep.wait_for_cname]
  static_web_app_id = azurerm_static_web_app.app.id
  domain_name       = "${azurerm_dns_cname_record.app.name}.${azurerm_dns_cname_record.app.zone_name}"
  validation_type   = "cname-delegation"
}
