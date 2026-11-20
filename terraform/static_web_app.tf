resource "azurerm_static_web_app" "app" {
  name                = local.static_web_app_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku_tier = "Free"
  sku_size = "Free"

  tags = var.tags
}

removed {
  from = azurerm_dns_cname_record.app

  lifecycle {
    destroy = false
  }
}

resource "cloudflare_dns_record" "app" {
  zone_id = data.cloudflare_zone.primary.id
  name    = "${var.dns.subdomain}.${var.dns.domain}"
  type    = "CNAME"
  ttl     = 300
  content = azurerm_static_web_app.app.default_host_name
  proxied = false
}

resource "time_sleep" "wait_for_cname" {
  depends_on = [cloudflare_dns_record.app]

  create_duration = "60s"
}

resource "azurerm_static_web_app_custom_domain" "app" {
  depends_on        = [time_sleep.wait_for_cname]
  static_web_app_id = azurerm_static_web_app.app.id
  domain_name       = "${var.dns.subdomain}.${var.dns.domain}"
  validation_type   = "cname-delegation"
}
