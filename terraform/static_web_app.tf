resource "azurerm_static_web_app" "app" {
  name                = local.static_web_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku_tier = "Free"
  sku_size = "Free"
}

resource "azurerm_dns_cname_record" "app" {
  provider = azurerm.dns

  name                = var.dns.subdomain
  zone_name           = var.dns.domain
  resource_group_name = data.azurerm_dns_zone.molyneux-me.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.app.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "app" {
  static_web_app_id = azurerm_static_web_app.app.id
  domain_name       = "${azurerm_dns_cname_record.app.name}.${azurerm_dns_cname_record.app.zone_name}"
  validation_type   = "cname-delegation"
}
