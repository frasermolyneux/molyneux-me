environment = "dev"
location    = "westeurope"

subscription_id = "ef3cc6c2-159e-4890-9193-13673dded835"

dns = {
  subscription_id     = "db34f572-8b71-40d6-8f99-f29a27612144"
  resource_group_name = "rg-platform-dns-prd-uksouth-01"
  domain              = "molyneux.me"
  subdomain           = "dev"
}

tags = {
  Environment = "dev",
  Workload    = "molyneux-me",
  DeployedBy  = "GitHub-Terraform",
  Git         = "https://github.com/frasermolyneux/molyneux-me"
}
