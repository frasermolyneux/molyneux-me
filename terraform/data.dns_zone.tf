data "cloudflare_zone" "primary" {
  filter = {
    name = var.dns.domain
  }
}
